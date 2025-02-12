import uuid
import boto3

dynamodb = boto3.client('dynamodb')

def handler(event, context):
    id = str(uuid.uuid4())
    users = event['users']
    users.append(event['cognitoUsername'])
    records = [{
        'PutRequest': {
            'Item': {
                'ConversationId': {'S': id},
                'Username': {'S': user}
            }
        }
    } for user in users]

    dynamodb.batch_write_item(
        RequestItems={
            'Chat-Conversations': records
        }
    )

    return id
