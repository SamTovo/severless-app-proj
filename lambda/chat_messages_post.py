import boto3
from boto3.dynamodb.conditions import Key
import time

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Chat-Messages')

def handler(event, context):
    response = table.put_item(
        Item={
            'ConversationId': event['id'],
            'Timestamp': str(int(time.time() * 1000)),
            'Message': event['message'],
            'Sender': event['cognitoUsername']
        }
    )
    return response
#teste2