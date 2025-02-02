
data "aws_s3_object" "package" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_lambda.zip"
}


resource "aws_lambda_function" "chat_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name = "chat_lambda"
  role          = aws_iam_role.lambda_role.arn
  s3_bucket = aws_s3_bucket.lambda.bucket
  s3_key    = "chat_lambda.zip"
  handler = "chat_lambda.handler"
  runtime = "python3.8"
  source_code_hash = data.aws_s3_object.package.metadata.hash
}