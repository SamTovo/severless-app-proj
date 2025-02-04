resource "aws_api_gateway_rest_api" "api" {
  name        = "ChatAPI"
  description = "This is my API Gateway"
}

resource "aws_api_gateway_resource" "conversations_api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "conversations"
}
resource "aws_api_gateway_resource" "conversations_id_api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.conversations_api.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_conversations" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.conversations_api.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chat_conversation_lambda_convo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:311141525611:3d346uvk7h/*/GET/conversations"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.conversations_api.id
  http_method             = aws_api_gateway_method.get_conversations.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chat_conversation_lambda_convo.invoke_arn
}
resource "aws_api_gateway_model" "conversation_list" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "ConversationList"
  content_type = "application/json"
  schema       = file("${path.module}/models/Conversationlist.json")
}

resource "aws_api_gateway_method_response" "method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.get_conversations.http_method
  status_code = "200"
  response_models = {
    "application/json" = aws_api_gateway_model.conversation_list.name
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.get_conversations.http_method
  status_code = aws_api_gateway_method_response.method_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method" "cors_options" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.conversations_api.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.cors_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "cors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "cors_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}
