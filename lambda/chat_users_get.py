import boto3
from botocore.paginate import Paginator

client = boto3.client('cognito-idp')

def handler(event, context):
    paginator = client.get_paginator('list_users')
    response_iterator = paginator.paginate(
        UserPoolId='us-east-1_uftxmctjR',
        AttributesToGet=[],
        Filter='',
        PaginationConfig={'PageSize': 60}
    )

    logins = []

    for page in response_iterator:
        for user in page['Users']:
            logins.append(user['Username'])

    return logins
#force push2