import json
import boto3
from boto3.dynamodb.conditions import Key

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

bucket = '311141525611-severless-app-proj-static-site'

def handler(event, context):
    path = event['pathParameters']['proxy']

    try:
        if path == 'conversations':
            response = s3_client.get_object(Bucket=bucket, Key='data/conversations.json')
            return done(None, json.loads(response['Body'].read().decode('utf-8')))
        elif path.startswith('conversations/'):
            id = path[len('conversations/'):]
            return done(None, load_messages(id))
        else:
            return done('No cases hit')
    except Exception as e:
        return done(str(e))

def load_messages(id):
    table = dynamodb.Table('Chat-Messages')
    response = table.query(
        KeyConditionExpression=Key('ConversationId').eq(id),
        ProjectionExpression='#T, Sender, Message',
        ExpressionAttributeNames={'#T': 'Timestamp'}
    )

    messages = []
    for item in response['Items']:
        messages.append({
            'sender': item['Sender'],
            'time': int(item['Timestamp']),
            'message': item['Message']
        })

    return load_conversation_detail(id, messages)

def load_conversation_detail(id, messages):
    table = dynamodb.Table('Chat-Conversations')
    response = table.query(
        KeyConditionExpression=Key('ConversationId').eq(id),
        Select='ALL_ATTRIBUTES'
    )

    participants = [item['Username'] for item in response['Items']]

    return {
        'id': id,
        'participants': participants,
        'last': messages[-1]['time'] if messages else None,
        'messages': messages
    }

def done(err, res=None):
    if err:
        print(err)
    return {
        'statusCode': '400' if err else '200',
        'body': json.dumps(err) if err else json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
