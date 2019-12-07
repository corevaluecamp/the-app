#!/bin/bash
yum update -y > "/var/log/yum-update_$(date +%d-%m-%Y@%k:%M:%S).log"
timedatectl set-timezone Europe/Kiev
cat <<EOF > /etc/yum.repos.d/mongodb.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

yum install -y mongodb-org > "/var/log/mongodb-install_$(date +%d-%m-%Y@%k:%M:%S).log"
service mongod stop
cat <<EOF > /etc/mongod.conf
# mongod.conf
# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/
# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
# how the process runs
processManagement:
  fork: true  # fork and run in background
  pidFilePath: /var/run/mongodb/mongod.pid  # location of pidfile
  timeZoneInfo: /usr/share/zoneinfo
# Where and how to store data.
storage:
  dbPath: /var/lib/mongo
  journal:
    enabled: true
  engine: wiredTiger
  wiredTiger:
    collectionConfig:
      blockCompressor: none
# network interfaces
net:
  port: 27017
  bindIp: ${dbhost}  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.
#  ssl:
#    mode: requireSSL
#    PEMKeyFile: /etc/ssl/mongo_ssl/mongodb.pem
#    CAFile: /etc/ssl/mongo_ssl/CA.pem
#    allowInvalidCertificates: true
#    allowInvalidHostnames: true
#security:
#  authorization: enabled
#  keyFile: /var/lib/mongo/rsetkey
#operationProfiling:
#replication:
#  replSetName: TestRS-0
#sharding:
## Enterprise-Only Options
#auditLog:
#snmp:
EOF

sudo chkconfig mongod on
service mongod start
service mongod status > "/var/log/mongod-status_$(date +%d-%m-%Y@%k:%M:%S).log"

######################################
# Installing Node Exporter user-data #
######################################
dnf search wget > "/var/log/wget-search_$(date +%d-%m-%Y@%k:%M:%S).log"
dnf install wget -y > "/var/log/wget-install-$(date +%d-%m-%Y@%k:%M:%S).log"
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz -P /tmp
tar xf /tmp/node_exporter-0.18.1.linux-amd64.tar.gz -C /opt/
mv /opt/node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
useradd -rs /bin/false node_exporter
cat <<EOF > /etc/systemd/system/node_exporter.service
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
EOF

systemctl enable node_exporter
systemctl daemon-reload
systemctl start node_exporter

#################################
# Installing Filebeat user-data #
#################################
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF > /etc/yum.repos.d/elasticsearch.repo
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
sed -i -e 's/enabled: false/enabled: true/g' /etc/filebeat/filebeat.yml
systemctl enable filebeat
systemctl start filebeat
