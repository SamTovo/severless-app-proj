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

resource "aws_api_gateway_model" "convo_id" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "ConversationId"
  content_type = "application/json"
  schema       = file("${path.module}/models/ConversationId.json")
}

resource "aws_api_gateway_model" "new_convo" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "NewConversation"
  content_type = "application/json"
  schema       = file("${path.module}/models/NewConversation.json")
}



