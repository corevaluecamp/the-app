import os
import logging
import boto3
from botocore.exceptions import ClientError
from sys import argv


path = argv[1]
#bucket_name = argv[2]

s3_client = boto3.client('s3')
s3_resource = boto3.resource("s3")
s3_bucket_names = s3_client.list_buckets()
contains_in_name = 'publishbicycle'

for bucket in s3_bucket_names['Buckets']:
    if contains_in_name in bucket["Name"]:
       bucket_name=(f'{bucket["Name"]}')
    else:
        print('Bucket name not contains: ',contains_in_name)

def upload_directory(root_path,bucket_name):
    try:
        bucket = s3_resource.Bucket(bucket_name)

        for path, subdirs, files in os.walk(root_path):
            path = path.replace("\\","/")
            directory_name = path.replace(root_path,"")
            for file in files:
                bucket.upload_file(os.path.join(path, file), directory_name+'/'+file)

    except Exception as err:
        print(err)

upload_directory(path,bucket_name)