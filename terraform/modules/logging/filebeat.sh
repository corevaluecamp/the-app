#!/bin/bash
# Download and install filebeat
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elasticsearch.repo << EOF
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
sed -i '29c\    - /var/log/mongodb/mongodb.log' /etc/filebeat/filebeat.yml
sed -i '30c\    - /var/log/jenkins/jenkins.log' /etc/filebeat/filebeat.yml
sed -i '31c\    - /home/ec2-user/logs/*.log' /etc/filebeat/filebeat.yml
# Create custom index name
cat >> /etc/filebeat/filebeat.yml << EOF
setup.ilm.rollover_alias: "customindexname"
setup.ilm.overwrite: true
EOF
# Add filebeat to startup
systemctl enable filebeat
systemctl start filebeat
