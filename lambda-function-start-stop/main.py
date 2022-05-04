import boto3
import json
START_INSTANCES_EVENT = "start-instances"
STOP_INSTANCES_EVENT = "stop-instances"


def handler(event, context):
    print("EVENT", event)
    print(list_instances_by_tag_value("scheduled", "true"))


def list_instances_by_tag_value(tagkey, tagvalue):
    # Return a list of instances with specific tag key and tag name

    ec2client = boto3.client('ec2')

    response = ec2client.describe_instances(
        Filters=[
            {
                'Name': 'tag:'+tagkey,
                'Values': [tagvalue]
            }
        ]
    )
    instancelist = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instancelist.append(instance)
    return instancelist


def start_stop_instances(eventType, tagKey, tagValue):
    ec2client = boto3.client('ec2')
    instanceIds = []
    instances = list_instances_by_tag_value(tagKey, tagValue)
    for instance in instances:
        if(eventType == START_INSTANCES_EVENT):
            if(instance["State"]["Code"] == "80" or instance["State"]["Code"] == "64"):
                instanceIds.append(instance["InstanceId"])
        if(eventType == STOP_INSTANCES_EVENT):
            if(instance["State"]["Code"] == "16"):
                instanceIds.append(instance["InstanceId"])
