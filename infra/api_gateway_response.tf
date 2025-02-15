



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


resource "aws_api_gateway_method_response" "method_response_200_id_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.post_ids.http_method
  status_code = "204"
  response_models = {
    "application/json" = aws_api_gateway_model.convo_id.name
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200_id_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.conversations_api.id
  http_method = aws_api_gateway_method.post_ids.http_method
  status_code = aws_api_gateway_method_response.method_response_200_id_post.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}