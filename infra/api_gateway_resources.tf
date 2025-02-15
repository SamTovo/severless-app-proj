
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
