
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

data "archive_file" "lambda_file_message_post" {
  type        = "zip"
  source_file = "../lambda/chat_messages_post.py"
  output_path = "../lambda/chat_messages_post.zip"
}
data "aws_s3_object" "package_post" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_messages_post.zip"
}

resource "aws_s3_object" "file_upload_post" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_messages_post.zip"
  source = data.archive_file.lambda_file_message_post.output_path
  etag   = filemd5(data.archive_file.lambda_file_message_post.output_path)
}


resource "aws_lambda_function" "messages_post_lambda" {
  function_name    = "chat_messages_post"
  role             = aws_iam_role.lambda_role.arn
  s3_bucket        = aws_s3_bucket.lambda.bucket
  s3_key           = "chat_messages_post.zip"
  handler          = "chat_messages_post.handler"
  runtime          = "python3.8"
  source_code_hash = aws_s3_object.file_upload_post.etag
}

data "archive_file" "lambda_file_user_get" {
  type        = "zip"
  source_file = "../lambda/chat_users_get.py"
  output_path = "../lambda/chat_users_get.zip"
}
data "aws_s3_object" "package_user_get" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_users_get.zip"
}

resource "aws_s3_object" "file_upload_user_get" {
  bucket = aws_s3_bucket.lambda.bucket
  key    = "chat_users_get.zip"
  source = data.archive_file.lambda_file_user_get.output_path
  etag   = filemd5(data.archive_file.lambda_file_user_get.output_path)
}


resource "aws_lambda_function" "user_get_lambda" {
  function_name    = "chat_users_get"
  role             = aws_iam_role.lambda_role.arn
  s3_bucket        = aws_s3_bucket.lambda.bucket
  s3_key           = "chat_users_get.zip"
  handler          = "chat_users_get.handler"
  runtime          = "python3.8"
  source_code_hash = aws_s3_object.package_user_get.etag
}