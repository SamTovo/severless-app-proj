resource "aws_dynamodb_table" "chat_messages" {
  name           = "Chat-Messages"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ConversationId"
  range_key      = "Timestamp"
  attribute {
    name = "ConversationId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "S"
  }
  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
    Version     = "1.1"
  }
}

resource "aws_dynamodb_table" "chat_conversations" {
  name           = "Chat-Conversations"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ConversationId"
  range_key      = "Username"
  attribute {
    name = "ConversationId"
    type = "S"
  }

  attribute {
    name = "Username"
    type = "S"
  }
  tags = {
    Name        = "dynamodb-table-2"
    Environment = "production"
  }

  global_secondary_index {
    name            = "Username-ConversationId-index"
    hash_key        = "Username"
    range_key       = "ConversationId"
    write_capacity  = 1
    read_capacity   = 1
    projection_type = "ALL"
  }
}