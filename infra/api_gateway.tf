resource "aws_api_gateway_rest_api" "api" {
  name        = "ChatAPI"
  description = "This is my API Gateway"
}

resource "aws_api_gateway_resource" "conversations_api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "conversations"
}
resource "aws_api_gateway_resource" "users_api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
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


resource "aws_api_gateway_method" "get_ids" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.conversations_id_api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_ids" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.conversations_id_api.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "get_users" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.users_api.id
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

resource "aws_lambda_permission" "api_gateway_get_ids" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chat_messages_get.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:311141525611:3d346uvk7h/*/GET/conversations/{id}"
}

resource "aws_lambda_permission" "api_gateway_post_ids" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.messages_post_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:311141525611:3d346uvk7h/*/POST/conversations/{id}"
}

resource "aws_lambda_permission" "api_gateway_users_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_get_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:311141525611:3d346uvk7h/*/GET/users"
}

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
  #   request_templates = {
  #   "application/json" = file("${path.module}/mapping_templates/Chat-Messages-POST-Input.vtl")
  # }
  # passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_model" "conversation_list" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "ConversationList"
  content_type = "application/json"
  schema       = file("${path.module}/models/Conversationlist.json")
}

resource "aws_api_gateway_model" "conversation" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "Conversation"
  content_type = "application/json"
  schema       = file("${path.module}/models/Conversation.json")
}

resource "aws_api_gateway_model" "new_message" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "NewMessage"
  content_type = "application/json"
  schema       = file("${path.module}/models/NewMessage.json")
}

resource "aws_api_gateway_model" "user_get" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "UserList"
  content_type = "application/json"
  schema       = file("${path.module}/models/UserList.json")
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



resource "aws_api_gateway_method_response" "method_response_users_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users_api.id
  http_method = aws_api_gateway_method.get_users.http_method
  status_code = "200"
  response_models = {
    "application/json" = aws_api_gateway_model.user_get.name
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_users_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users_api.id
  http_method = aws_api_gateway_method.get_users.http_method
  status_code = aws_api_gateway_method_response.method_response_users_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}



resource "aws_api_gateway_method_response" "method_response_200_id_get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.get_ids.http_method
  status_code = "200"
  response_models = {
    "application/json" = aws_api_gateway_model.conversation.name
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200_id_get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.get_ids.http_method
  status_code = aws_api_gateway_method_response.method_response_200_id_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}


resource "aws_api_gateway_method_response" "method_response_204_id_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.post_ids.http_method
  status_code = "204"
  response_models = {
    "application/json" = aws_api_gateway_model.new_message.name
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_204_id_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.post_ids.http_method
  status_code = aws_api_gateway_method_response.method_response_204_id_post.status_code

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


resource "aws_api_gateway_method" "cors_options_id" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.conversations_id_api.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_integration_id" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.cors_options_id.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "cors_integration_response_id" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.cors_options_id.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "cors_method_response_id" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_id_api.id
  http_method = aws_api_gateway_method.cors_options_id.http_method
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



resource "aws_api_gateway_method" "cors_users_options" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.users_api.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_users_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users_api.id
  http_method = aws_api_gateway_method.cors_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "cors_users_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users_api.id
  http_method = aws_api_gateway_method.cors_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "cors_users_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users_api.id
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
