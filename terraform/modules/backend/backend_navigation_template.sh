#!/bin/bash

yum update -y
yum install java-1.8.0-openjdk-devel -y
yum install python3 -y
pip3 install boto3 

echo "${redis} redis-node" >> /etc/hosts
echo "${mongo} mongodb-node" >> /etc/hosts
echo "export NAVIGATION_SERVICE_MONGODB_URL=mongodb.dos.net" >>  /home/ec2-user/.bashrc
echo "export CART_SERVICE_REDIS_URL=redis.dos.net" >>  /home/ec2-user/.bashrc
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
CART_SERVICE_REDIS_URL=redis.dos.net
NAVIGATION_SERVICE_MONGODB_URL=mongodb.dos.net

*/10 * * * * root pkill java ; /home/ec2-user/s3d.py ${s3_bucketname} navigation.jar /home/ec2-user/jar/navigation.jar ; java -jar /home/ec2-user/jar/navigation.jar >> /home/ec2-user/logs/app-navigation.log
EOF

chmod +rw /home/ec2-user/logs
chown ec2-user /home/ec2-user/logs/app-navigation.log
chmod +rw /home/ec2-user/jar

systemctl restart crond

#**************************************************************************#
#logging
#**************************************************************************#
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
yum update -y
yum install filebeat -y
# Configure filebeat
sed -i -e 's/localhost:9200/${elastic_ip}:9200/g' /etc/filebeat/filebeat.yml
sed -i -e 's/enabled: false/enabled: true/g' /etc/filebeat/filebeat.yml
sed -i '29c\    - /var/log/*.log' /etc/filebeat/filebeat.yml
sed -i '30c\    - /home/ec2-user/logs/*.log' /etc/filebeat/filebeat.yml
# Create custom index name
cat >> /etc/filebeat/filebeat.yml <<-EOF
setup.ilm.rollover_alias: "backend_navigation_app"
setup.ilm.overwrite: true
EOF
# Add filebeat to startup
systemctl enable filebeat
systemctl start filebeat

#**************************************************************************#
#monitoring
#**************************************************************************#
# Downloading the node exporter package
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz -P /tmp

# Unpacking the tarball 
sudo tar xf /tmp/node_exporter-0.18.1.linux-amd64.tar.gz -C /opt/

# Moving the node export binary to /usr/local/bin
sudo mv /opt/node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/

# Creating a node_exporter user to run the node exporter service *}
sudo useradd -rs /bin/false node_exporter

# Creating a node_exporter service file under systemd
sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF'

# Reloading the system daemon and starting the node exporter service
sudo systemctl daemon-reload
sudo systemctl start node_exporter

# systemctl is-active --quiet node_exporter && echo "node_exporter is running" || echo "node_exporter is NOT running"

# Enabling the node exporter service to the system startup *}
sudo systemctl enable node_exporter