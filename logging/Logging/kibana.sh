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
yum install kibana -y
sed -i -e 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
cat >> /etc/kibana/kibana.yml <<-EOF
elasticsearch.hosts: ["http://${elastic_ip}:9200"]
EOF
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
systemctl start kibana.service
