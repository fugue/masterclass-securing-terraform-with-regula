
###################################
###### Access Logging Bucket ######
###################################

resource "aws_s3_bucket" "access_logging_bucket" {
  bucket = "superstore-logging-${data.aws_caller_identity.current.account_id}"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "transition_current_version"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }

  lifecycle_rule {
    id      = "transition_noncurrent_version"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access_logging_bucket_blocker" {
  bucket = aws_s3_bucket.access_logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "access_logging_bucket" {
  bucket = aws_s3_bucket.access_logging_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BucketVersioning",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:PutBucketVersioning",
        "s3:ObjectOwnerOverrideToBucketOwner",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.access_logging_bucket.arn}/*",
        "${aws_s3_bucket.access_logging_bucket.arn}"
      ]
  },
  {
      "Sid": "Require HTTPS",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.access_logging_bucket.arn}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

#######################################
###### CloudTrail Logging Bucket ######
#######################################

resource "aws_s3_bucket" "cloudtrail_logging_bucket" {
  bucket = "superstore-cloudtrail-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.access_logging_bucket.id
    target_prefix = "cloudtrail/"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.logging_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "transition_current_version"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }

  lifecycle_rule {
    id      = "transition_noncurrent_version"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_logging_bucket_blocker" {
  bucket                  = aws_s3_bucket.cloudtrail_logging_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail_logging_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_logging_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
          "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.cloudtrail_logging_bucket.arn}"
    },
    {
      "Sid": "CloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": [
        "${aws_s3_bucket.cloudtrail_logging_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "Require HTTPS",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.cloudtrail_logging_bucket.arn}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

############################
##### Logging KMS Key #####
############################

resource "aws_kms_key" "logging_key" {
  is_enabled          = true
  # enable_key_rotation = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "cloudtrail-key-policy",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Enable CloudTrail",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "kms:GenerateDataKey*",
            "Resource": "*"
        },
        {
            "Sid": "Logs access",
            "Effect": "Allow",
            "Principal": {
              "Service": "logs.us-east-2.amazonaws.com"
            },
            "Action": [
              "kms:Encrypt*",
              "kms:Decrypt*",
              "kms:ReEncrypt*",
              "kms:GenerateDataKey*",
              "kms:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail access",
            "Effect": "Allow",
            "Action": "kms:DescribeKey",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_kms_alias" "logging_key_alias" {
  name          = "alias/logging-key"
  target_key_id = aws_kms_key.logging_key.key_id
}

#########################
##### Logging Trail #####
#########################

resource "aws_cloudwatch_log_group" "trail_logs" {
  name              = "superstore-trail"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.logging_key.arn
}

resource "aws_iam_role" "trail_logs_role" {
  name               = "superstore-trail-logging"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "trails_logs_attach" {
  role       = aws_iam_role.trail_logs_role.name
  policy_arn = aws_iam_policy.trails_logs_policy.arn
}

resource "aws_iam_policy" "trails_logs_policy" {
  name   = "superstore-trail-logs-policy"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "LogActions",
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  }]}
EOF
}

resource "aws_cloudtrail" "logging_trail" {
  name                          = "superstore-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logging_bucket.id
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  # kms_key_id                    = aws_kms_key.logging_key.arn
  # enable_logging                = true
  # cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.trail_logs.arn}:*"
  # cloud_watch_logs_role_arn     = aws_iam_role.trail_logs_role.arn
}
