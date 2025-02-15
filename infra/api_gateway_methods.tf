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

resource "aws_api_gateway_method" "post_conversations" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.conversations_api.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.new_convo.name
  }

}