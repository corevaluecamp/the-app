#!/bin/bash
sudo yum update
sudo timedatectl set-timezone Europe/Kiev
sudo cat <<EOF > /etc/yum.repos.d/mongodb.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

sudo yum install -y mongodb-org > "/var/log/mongodb-install_$(date +%d-%m-%Y@%k:%M:%S).log"
sudo service mongod stop
sudo cat << EOF > /etc/mongod.conf
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
sudo service mongod start
