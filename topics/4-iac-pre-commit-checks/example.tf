
resource "aws_iam_role" "footgun" {
  name = "footgun"
  # assume_role_policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Action = "sts:AssumeRole"
  #       Effect = "Allow"
  #       Sid    = ""
  #       Principal = {
  #         AWS = "*"
  #       }
  #     },
  #   ]
  # })
}
