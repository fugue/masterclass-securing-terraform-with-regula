
resource "aws_iam_user" "joe" {
  name = "joe"
  path = "/"
  tags = {
    department = "engineering"
  }
}

resource "aws_iam_access_key" "user-key" {
  user = aws_iam_user.joe.name
}
