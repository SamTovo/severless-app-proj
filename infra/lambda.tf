
data "archive_file" "lambda_file" {
  type        = "zip"
  source_file = "../lambda/chat_lambda.py"
  output_path = "../lambda/chat_lambda.zip"
}
data "aws_s3_object" "package" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_lambda.zip"
}

resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_lambda.zip"
  source = data.archive_file.lambda_file.output_path
  etag   = filemd5(data.archive_file.lambda_file.output_path)
}
resource "aws_lambda_function" "chat_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name    = "chat_lambda"
  role             = aws_iam_role.lambda_role.arn
  s3_bucket        = aws_s3_bucket.lambda.bucket
  s3_key           = "chat_lambda.zip"
  handler          = "chat_lambda.handler"
  runtime          = "python3.8"
  source_code_hash = aws_s3_object.file_upload.etag
}