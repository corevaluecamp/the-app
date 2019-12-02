import logging
import boto3
from botocore.exceptions import ClientError
from sys import argv

name = argv[1]
#bucket_name = argv[2]
name_in_bucket = argv[2]

s3_client = boto3.client('s3')
s3_bucket_names = s3_client.list_buckets()
contains_in_name = 'artifacts'

for bucket in s3_bucket_names['Buckets']:
    if contains_in_name in bucket["Name"]:
       #print(f'{bucket["Name"]}')
       bucket_name=(f'{bucket["Name"]}')
    else:
        print('Bucket name not contains: ',contains_in_name)

def upload_file(file_name, bucket, object_name=None):
    # If S3 object_name was not specified, use file_name
    if object_name is None:
        object_name = file_name

    # Upload the file
    try:
        s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True

upload_file(name,bucket_name,name_in_bucket)
