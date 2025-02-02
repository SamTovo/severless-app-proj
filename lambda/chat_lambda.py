import json
import boto3
from botocore.exceptions import ClientError

s3_client = boto3.client('s3')
#testando hash
bucket = '311141525611-severless-app-proj-static-site'

def handler(event, context):
    try:
        response = s3_client.get_object(Bucket=bucket, Key='data/conversations.json')
        data = json.loads(response['Body'].read().decode('utf-8'))
        return done(None, data)
    except ClientError as e:
        return done(e)

def done(err, res):
    if err:
        print(err)
        return {
            'statusCode': '400',
            'body': json.dumps(str(err)),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
    return {
        'statusCode': '200',
        'body': json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
