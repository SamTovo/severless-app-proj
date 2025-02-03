import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError
import time
import json
dynamodb = boto3.resource('dynamodb')
client = boto3.client('dynamodb')

def handler(event, context):
    path = event['pathParameters']['proxy']

    try:
        if path == 'conversations':
            conversation_ids = []
            table = dynamodb.Table('Chat-Conversations')
            response = table.query(
                IndexName='Username-ConversationId-index',
                KeyConditionExpression=Key('Username').eq('Student'),
                ProjectionExpression='ConversationId'
            )
            for item in response['Items']:
                conversation_ids.append(item['ConversationId'])

            lasts = load_convos_last(conversation_ids)
            parts = load_convo_participants(conversation_ids)

            result_objs = [
                {
                    'id': id,
                    'last': lasts.get(id),
                    'participants': parts.get(id)
                }
                for id in conversation_ids
            ]
            return done(None, result_objs)
        elif path.startswith('conversations/'):
            id = path[len('conversations/'):]

            if event['httpMethod'] == 'GET':
                    return done(None, load_messages(id))
            elif event['httpMethod'] == 'POST':
                table = dynamodb.Table('Chat-Messages')
                response = table.put_item(
                    Item={
                        'ConversationId': id,
                        'Timestamp': int(time.time()),
                        'Message': event['body'],
                        'Sender': 'Student'
                    }
                )
                return done(None, response)
            else:
                return done('No cases hit')
        else:
            return done('No cases hit')
    except ClientError as e:
        return done(str(e))

def load_messages(id):
    messages = []
    table = dynamodb.Table('Chat-Messages')
    response = table.query(
        KeyConditionExpression=Key('ConversationId').eq(id),
        ProjectionExpression='#T, Sender, Message',
        ExpressionAttributeNames={'#T': 'Timestamp'}
    )
    for item in response['Items']:
        messages.append({
            'sender': item['Sender'],
            'time': item['Timestamp'],
            'message': item['Message']
        })
    return load_conversation_detail(id, messages)

def load_conversation_detail(id, messages):
    participants = []
    table = dynamodb.Table('Chat-Conversations')
    response = table.query(
        KeyConditionExpression=Key('ConversationId').eq(id)
    )
    for item in response['Items']:
        participants.append(item['Username'])

    return {
        'id': id,
        'participants': participants,
        'last': messages[-1]['time'] if messages else None,
        'messages': messages
    }

def load_convos_last(ids):
    result = {}
    for id in ids:
        table = dynamodb.Table('Chat-Messages')
        response = table.query(
            KeyConditionExpression=Key('ConversationId').eq(id),
            ProjectionExpression='ConversationId, #T',
            ExpressionAttributeNames={'#T': 'Timestamp'},
            Limit=1,
            ScanIndexForward=False
        )
        if response['Items']:
            result[id] = response['Items'][0]['Timestamp']
    return result

def load_convo_participants(ids):
    result = {}
    for id in ids:
        participants = []
        table = dynamodb.Table('Chat-Conversations')
        response = table.query(
            KeyConditionExpression=Key('ConversationId').eq(id)
        )
        for item in response['Items']:
            participants.append(item['Username'])
        result[id] = participants
    return result

def done(err, res=None):
    if err:
        print(err)
    return {
        'statusCode': '400' if err else '200',
        'body': err if err else res,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
