import boto3
from boto3.dynamodb.conditions import Key

client = boto3.client('dynamodb')

def handler(event, context):
    path = event['pathParameters']['proxy']

    try:
        if path == 'conversations':
            paginator = client.get_paginator('query')
            response_iterator = paginator.paginate(
                TableName='Chat-Conversations',
                IndexName='Username-ConversationId-index',
                Select='ALL_PROJECTED_ATTRIBUTES',
                KeyConditionExpression=Key('Username').eq('Student')
            )

            conversation_ids = []
            for page in response_iterator:
                for item in page['Items']:
                    conversation_ids.append(item['ConversationId']['S'])

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

            return done(None, load_messages(id))
        else:
            return done('No cases hit')
    except Exception as e:
        return done(e)

def load_messages(id):
    messages = []
    paginator = client.get_paginator('query')
    response_iterator = paginator.paginate(
        TableName='Chat-Messages',
        ProjectionExpression='#T, Sender, Message',
        ExpressionAttributeNames={'#T': 'Timestamp'},
        KeyConditionExpression=Key('ConversationId').eq(id)
    )

    for page in response_iterator:
        for message in page['Items']:
            messages.append({
                'sender': message['Sender']['S'],
                'time': int(message['Timestamp']['N']),
                'message': message['Message']['S']
            })

    return load_conversation_detail(id, messages)

def load_conversation_detail(id, messages):
    paginator = client.get_paginator('query')
    response_iterator = paginator.paginate(
        TableName='Chat-Conversations',
        Select='ALL_ATTRIBUTES',
        KeyConditionExpression=Key('ConversationId').eq(id)
    )

    participants = []

    for page in response_iterator:
        for item in page['Items']:
            participants.append(item['Username']['S'])

    return {
        'id': id,
        'participants': participants,
        'last': messages[-1]['time'] if messages else None,
        'messages': messages
    }

def load_convos_last(ids):
    query_results = [
        client.query(
            TableName='Chat-Messages',
            ProjectionExpression='ConversationId, #T',
            Limit=1,
            ScanIndexForward=False,
            KeyConditionExpression=Key('ConversationId').eq(id),
            ExpressionAttributeNames={'#T': 'Timestamp'}
        )
        for id in ids
    ]

    result = {}

    for qr in query_results:
        if qr['Items']:
            result[qr['Items'][0]['ConversationId']['S']] = int(qr['Items'][0]['Timestamp']['N'])

    return result

def load_convo_participants(ids):
    query_results = [
        client.query(
            TableName='Chat-Conversations',
            Select='ALL_ATTRIBUTES',
            KeyConditionExpression=Key('ConversationId').eq(id)
        )
        for id in ids
    ]

    result = {}

    for qr in query_results:
        participants = [item['Username']['S'] for item in qr['Items']]
        result[qr['Items'][0]['ConversationId']['S']] = participants

    return result

def done(err, res):
    if err:
        print(err)
    return {
        'statusCode': '400' if err else '200',
        'body': str(err) if err else str(res),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
#function end