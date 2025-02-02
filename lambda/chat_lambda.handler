import json
import boto3
from botocore.exceptions import ClientError

s3_client = boto3.client('s3')
bucket = '311141525611-severless-app-proj-static-site'

def handler(event, context):
    path = event['pathParameters']['proxy']

    key = None

    if path == 'conversations':
        key = 'data/conversations.json'
    elif path.startswith('conversations/'):
        id = path[len('conversations/'):]
        key = f'data/conversations/{id}.json'
    else:
        return done('No cases hit')

    try:
        response = s3_client.get_object(Bucket=bucket, Key=key)
        body = response['Body'].read().decode('utf-8')
        return done(None, json.loads(body))
    except ClientError as e:
        return done(e.response['Error']['Message'])

def done(err, res):
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
