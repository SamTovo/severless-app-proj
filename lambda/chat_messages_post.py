import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Chat-Messages')

def lambda_handler(event, context):
    response = table.put_item(
        Item={
            'ConversationId': event['id'],
            'Timestamp': str(int(time.time() * 1000)),
            'Message': event['message'],
            'Sender': 'Student'
        }
    )
    return response
#teste