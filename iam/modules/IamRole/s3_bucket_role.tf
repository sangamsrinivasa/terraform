resource "aws_iam_policy" "s3_access" {
  name        = "s3-access-policy"
  description = "Policy to allow access to the S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.example.arn}/*"
      },
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.example.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachement" "s3_policy_role" {

  user = "

}
