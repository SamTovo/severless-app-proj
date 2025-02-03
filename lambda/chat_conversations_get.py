
import boto3
from boto3.dynamodb.conditions import Key

import json
dynamodb = boto3.resource('dynamodb')
client = boto3.client('dynamodb')

def handler(event, context):
    table = dynamodb.Table('Chat-Conversations')
    response = table.query(
        IndexName='Username-ConversationId-index',
        Select='ALL_PROJECTED_ATTRIBUTES',
        KeyConditionExpression=Key('Username').eq('Student')
    )

    conversation_ids = [item['ConversationId'] for item in response['Items']]

    lasts = load_convos_last(conversation_ids)
    parts = load_convo_participants(conversation_ids)
    return {
        'statusCode': 200,
        'body': json.dumps([
            {
                'id': id,
                'last': lasts.get(id),
                'participants': parts.get(id)
            }
            for id in conversation_ids
        ])
    }

def load_convos_last(ids):
    table = dynamodb.Table('Chat-Messages')
    result = {}

    for id in ids:
        response = table.query(
            ProjectionExpression='ConversationId, #T',
            Limit=1,
            ScanIndexForward=False,
            KeyConditionExpression=Key('ConversationId').eq(id),
            ExpressionAttributeNames={'#T': 'Timestamp'}
        )
        if response['Items']:
            result[id] = int(response['Items'][0]['Timestamp'])

    return result

def load_convo_participants(ids):
    table = dynamodb.Table('Chat-Conversations')
    result = {}

    for id in ids:
        response = table.query(
            Select='ALL_ATTRIBUTES',
            KeyConditionExpression=Key('ConversationId').eq(id)
        )
        participants = [item['Username'] for item in response['Items']]
        result[id] = participants

    return result
