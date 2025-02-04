
data "archive_file" "lambda_file" {
  type        = "zip"
  source_file = "../lambda/chat_messages_get.py"
  output_path = "../lambda/chat_messages_get.zip"
}
data "aws_s3_object" "package" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_messages_get.zip"
}

resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_messages_get.zip"
  source = data.archive_file.lambda_file.output_path
  etag   = filemd5(data.archive_file.lambda_file.output_path)
}
resource "aws_lambda_function" "chat_messages_get" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name    = "chat_messages_get"
  role             = aws_iam_role.lambda_role.arn
  s3_bucket        = aws_s3_bucket.lambda.bucket
  s3_key           = "chat_messages_get.zip"
  handler          = "chat_messages_get.handler"
  runtime          = "python3.8"
  source_code_hash = aws_s3_object.file_upload.etag
}


data "archive_file" "lambda_file_convo" {
  type        = "zip"
  source_file = "../lambda/chat_conversations_get.py"
  output_path = "../lambda/chat_conversations_get.zip"
}
data "aws_s3_object" "package_convo" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_conversations_get.zip"
}

resource "aws_s3_object" "file_upload_convo" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_conversations_get.zip"
  source = data.archive_file.lambda_file_convo.output_path
  etag   = filemd5(data.archive_file.lambda_file_convo.output_path)
}


resource "aws_lambda_function" "chat_conversation_lambda_convo" {
  function_name    = "chat_conversation_lambda_get"
  role             = aws_iam_role.lambda_role.arn
  s3_bucket        = aws_s3_bucket.lambda.bucket
  s3_key           = "chat_conversations_get.zip"
  handler          = "chat_conversations_get.handler"
  runtime          = "python3.8"
  source_code_hash = aws_s3_object.file_upload_convo.etag
}