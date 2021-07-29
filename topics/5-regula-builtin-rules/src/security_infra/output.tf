
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "logging_bucket" {
  value = aws_s3_bucket.access_logging_bucket.id
}

output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrail_logging_bucket.id
}

output "kms_key" {
  value = aws_kms_key.logging_key.arn
}

output "logging_trail" {
  value = aws_cloudtrail.logging_trail.name
}
