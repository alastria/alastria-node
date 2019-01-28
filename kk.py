from __future__ import print_function
import json
import boto3
import logging

import commands
logger = logging.getLogger()

def handler(event, context):
    print ('event: {}' + json.dumps(event))
    filter = ''
    if 'filter' in event:
        filter =  event['filter']
    logger.info ("filter : " + filter)
    output = commands.getstatusoutput('sh ./validatorRestart.sh '+ filter)[1]

    message = output
    client = boto3.client('sns', region_name='eu-west-1')
    response = client.publish(
        TopicArn='arn:aws:sns:eu-west-1:881980153898:alastria-core-email',
        Message=message,
        Subject='Bender has executed a validator restart with filter = ' + filter,
        MessageStructure='string'
)
    return output
