resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.conversations_api.id
  http_method             = aws_api_gateway_method.get_conversations.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.chat_conversation_lambda_convo.invoke_arn

  request_templates = {
    "application/json" = file("${path.module}/mapping_templates/Chat-Conversation-GET-Input.vtl")
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_integration" "lambda_get_ids" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.conversations_id_api.id
  http_method             = aws_api_gateway_method.get_ids.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.chat_messages_get.invoke_arn

  request_templates = {
    "application/json" = file("${path.module}/mapping_templates/Chat-Messages-GET-Input.vtl")
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_integration" "lambda_post_ids" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.conversations_id_api.id
  http_method             = aws_api_gateway_method.post_ids.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.messages_post_lambda.invoke_arn
    request_templates = {
    "application/json" = file("${path.module}/mapping_templates/Chat-Messages-POST-Input.vtl")
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_integration" "lambda_users_get" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.users_api.id
  http_method             = aws_api_gateway_method.get_users.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.user_get_lambda.invoke_arn

}

resource "aws_api_gateway_integration" "lambda_convo_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.conversations_api.id
  http_method             = aws_api_gateway_method.post_conversations.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.chat_conversation_lambda_convo_post.invoke_arn
    request_templates = {
    "application/json" = file("${path.module}/mapping_templates/Chat-Conversation-POST-Input.vtl")
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}