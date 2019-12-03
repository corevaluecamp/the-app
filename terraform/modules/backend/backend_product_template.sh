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
mkdir /home/ec2-user/tar
touch /home/ec2-user/logs/app-product.log

cat <<EOF > /home/ec2-user/run.sh
#!/bin/bash
tar -xvf /home/ec2-user/tar/product.tar
chmod +x /home/ec2-user/product-0.6.4/bin/product
/home/ec2-user/product-0.6.4/bin/product >> /home/ec2-user/logs/app-product.log
EOF

chmod +x /home/ec2-user/run.sh

systemctl start crond

cat <<EOF >> /etc/crontab
*/5 * * * * root /home/ec2-user/s3d.py ${s3_bucketname} product.tar /home/ec2-user/tar/product.tar
*/6 * * * * root /home/ec2-user/run.sh 
EOF

chmod +rw /home/ec2-user/logs
chown ec2-user /home/ec2-user/logs/app-product.log
chmod +rw /home/ec2-user/tar

systemctl restart crond
