#!/bin/bash

yum update -y
yum install java-1.8.0-openjdk-devel -y
yum install python3 -y
pip3 install boto3 

#echo "ip redis-node" >> /etc/hosts
#echo "ip mongodb-node" >> /etc/hosts
echo "export BUCKET_NAME=${s3_bucketname}" >>  /home/ec2-user/.bashrc
echo "export NOW=$(date +'%b-%d-%H-%M-%S')" >>  /home/ec2-user/.bashrc

cat <<EOF > /home/ec2-user/s3d.py
#!/bin/python3
import boto3
from sys import argv

bucket_name = argv[1]
name_in_bucket = argv[2]
name = argv[3]

s3 = boto3.client('s3')
s3.download_file(bucket_name, name_in_bucket, name)
EOF

chmod +x /home/ec2-user/s3d.py

mkdir /home/ec2-user/logs
mkdir /home/ec2-user/jar
touch /home/ec2-user/logs/app-navigation.log

systemctl start crond

cat <<EOF >> /etc/crontab
*/5 * * * * root /home/ec2-user/s3d.py ${s3_bucketname} navigation.jar /home/ec2-user/jar/navigation.jar
*/6 * * * * root java -jar /home/ec2-user/jar/navigation.jar >> /home/ec2-user/logs/app-navigation.log
EOF

chmod +rw /home/ec2-user/logs
chown ec2-user /home/ec2-user/logs/app-navigation.log
chmod +rw /home/ec2-user/jar

systemctl restart crond


