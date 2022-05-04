import boto3
import json
import os

START_INSTANCES_EVENT = os.environ['START_INSTANCES_EVENT']
STOP_INSTANCES_EVENT = os.environ['STOP_INSTANCES_EVENT']
TAG_KEY = os.environ["TAG_KEY"]
TAG_VALUE = os.environ["TAG_VALUE"]


def handler(event, context):
    print(event)
    start_stop_instances(event["eventType"], TAG_KEY, TAG_VALUE)


def start_stop_instances(eventType, tagKey, tagValue):
    ec2client = boto3.client('ec2')
    instancelist = []
    if(eventType == START_INSTANCES_EVENT):
        instances = ec2client.describe_instances(
            Filters=[
                {
                    'Name': 'tag:'+tagKey,
                    'Values': [tagValue]
                },
                {
                    'Name': 'instance-state-code',
                    'Values': ["80"],
                }
            ]
        )
        for reservation in (instances["Reservations"]):
            for instance in reservation["Instances"]:
                instancelist.append(instance["InstanceId"])
        print(instancelist)

        if(len(instancelist) > 0):
            print("Started Instances with IDs", instancelist)
            ec2client.start_instances(InstanceIds=instancelist)
    if(eventType == STOP_INSTANCES_EVENT):
        instances = ec2client.describe_instances(
            Filters=[
                {
                    'Name': 'tag:'+tagKey,
                    'Values': [tagValue]
                },
                {
                    'Name': 'instance-state-code',
                    'Values': ["16"],
                }
            ]
        )
        for reservation in (instances["Reservations"]):
            for instance in reservation["Instances"]:
                instancelist.append(instance["InstanceId"])
        print(instancelist)
        if(len(instancelist) > 0):
            print("Stopped Instances with IDs", instancelist)
            ec2client.stop_instances(InstanceIds=instancelist)
