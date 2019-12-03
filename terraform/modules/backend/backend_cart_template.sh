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
mkdir /home/ec2-user/cronjobs
touch /home/ec2-user/logs/app-cart.log

systemctl start crond

cat <<EOF >> /etc/crontab
*/5 * * * * root /home/ec2-user/s3d.py ${s3_bucketname} cart.jar /home/ec2-user/jar/cart.jar
*/6 * * * * root java -jar /home/ec2-user/jar/cart.jar >> /home/ec2-user/logs/app-cart.log
EOF

chmod +rw /home/ec2-user/logs
chown ec2-user /home/ec2-user/logs/app-cart.log
chmod +rw /home/ec2-user/jar

systemctl restart crond

#logging
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elasticsearch.repo <<- EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install filebeat -y
sed -i -e 's/localhost:9200/${elastic_ip}:9200/g' /etc/filebeat/filebeat.yml
sed -i -e 's/enabled: false/enabled: true/g' /etc/filebeat/filebeat.yml
systemctl enable filebeat
systemctl start filebeat


