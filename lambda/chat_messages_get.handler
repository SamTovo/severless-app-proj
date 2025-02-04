import boto3
import json
dynamodb = boto3.client('dynamodb')

def handler(event, context):
    messages = []
    paginator = dynamodb.get_paginator('query')
    response_iterator = paginator.paginate(
        TableName='Chat-Messages',
        ProjectionExpression='#T, Sender, Message',
        ExpressionAttributeNames={'#T': 'Timestamp'},
        KeyConditionExpression='ConversationId = :id',
        ExpressionAttributeValues={':id': {'S': event['id']}}
    )

    for page in response_iterator:
        for message in page['Items']:
            messages.append({
                'sender': message['Sender']['S'],
                'time': int(message['Timestamp']['S']),
                'message': message['Message']['S']
            })

    return load_conversation_detail(event['id'], messages)

def load_conversation_detail(id, messages):
    paginator = dynamodb.get_paginator('query')
    response_iterator = paginator.paginate(
        TableName='Chat-Conversations',
        Select='ALL_ATTRIBUTES',
        KeyConditionExpression='ConversationId = :id',
        ExpressionAttributeValues={':id': {'S': id}}
    )

    participants = []

    for page in response_iterator:
        for item in page['Items']:
            participants.append(item['Username']['S'])
 
    return {
        'statusCode': 200,
        'body': json.dumps({
            'id': id,
            'participants': participants,
            'last': messages[-1]['time'] if messages else None,
            'messages': messages})
    }
