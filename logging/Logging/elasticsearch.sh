#!/bin/bash
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elasticsearch.repo <<-EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum install elasticsearch -y
sed -i -e 's/-Xms1g/-Xms512m/g' /etc/elasticsearch/jvm.options
sed -i -e 's/-Xmx1g/-Xmx512m/g' /etc/elasticsearch/jvm.options
cat >> /etc/elasticsearch/elasticsearch.yml <<-EOF
network.host: _site_
discovery.type: single-node
EOF
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
systemctl start elasticsearch.service
