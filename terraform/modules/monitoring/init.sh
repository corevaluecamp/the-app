#!/bin/bash

sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

sudo yum update -y

wget https://github.com/prometheus/prometheus/releases/download/v2.14.0/prometheus-2.14.0.linux-amd64.tar.gz -P /tmp

sudo tar xf /tmp/prometheus-2.14.0.linux-amd64.tar.gz -C /opt/

sudo cp /opt/prometheus-2.14.0.linux-amd64/prometheus /usr/local/bin/
sudo cp /opt/prometheus-2.14.0.linux-amd64/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r /opt/prometheus-2.14.0.linux-amd64/consoles /etc/prometheus
sudo cp -r /opt/prometheus-2.14.0.linux-amd64/console_libraries /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

sudo bash -c 'cat << EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: ec2
    scrape_interval: 5s
    ec2_sd_configs:
      - region: eu-west-3
        port: 9100
#       access_key: 
#       secret_key: 
EOF'

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

sudo bash -c 'cat << EOF >> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

wget https://dl.grafana.com/oss/release/grafana-6.5.0-1.x86_64.rpm -P /tmp
sudo yum install /tmp/grafana-6.5.0-1.x86_64.rpm -y
sudo service grafana-server start
sudo systemctl enable grafana-server.service

sudo bash -c 'cat << EOF >> /etc/grafana/provisioning/datasources/datasource.yml
# config file version
apiVersion: 1

# list of datasources that should be deleted from the database
deleteDatasources:
  - name: Prometheus
    orgId: 1

# list of datasources to insert/update depending
# whats available in the database
datasources:
  # <string, required> name of the datasource. Required
- name: Prometheus
  # <string, required> datasource type. Required
  type: prometheus
  # <string, required> access mode. direct or proxy. Required
  access: proxy
  # <int> org id. will default to orgId 1 if not specified
  orgId: 1
  # <string> url
  url: http://localhost:9090
  # <string> database password, if used
  password:
  # <string> database user, if used
  user:
  # <string> database name, if used
  database:
  # <bool> enable/disable basic auth
  #basicAuth: true
  # <string> basic auth username
  #basicAuthUser: admin
  # <string> basic auth password
  #basicAuthPassword: foobar
  # <bool> enable/disable with credentials headers
  withCredentials:
  # <bool> mark as default datasource. Max one per org
  isDefault:
  # <map> fields that will be converted to json and stored in json_data
  jsonData:
     graphiteVersion: "1.1"
     tlsAuth: false
     tlsAuthWithCACert: false
  # <string> json object of data that will be encrypted.
  #secureJsonData:
  # tlsCACert: "..."
  # tlsClientCert: "..."
  # tlsClientKey: "..."
  version: 1
  # <bool> allow users to edit datasources from the UI.
  editable: true
EOF'

sudo bash -c 'cat << EOF >> /etc/grafana/provisioning/dashboards/dashboard.yml
apiVersion: 1

providers:
- name: 'Prometheus'
  orgId: 1
  folder: ''
  type: file
  disableDeletion: false
  editable: true
  options:
    path: /var/lib/grafana/dashboards
EOF'

sudo mkdir /var/lib/grafana/dashboards
sudo bash -c 'cat << EOF >> /var/lib/grafana/dashboards/dashboard.json
# Dashboard here!
EOF'

sudo service grafana-server try-restart

# APPENDIX fileBeat
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

# APPENDIX Grafana dashboard import
yum install python3 -y
pip3 install boto3

echo "export BUCKET_NAME=${backend_s3_created_bucket_name}" >>  /home/ec2-user/.bashrc

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
systemctl start crond

cat <<EOF >> /etc/crontab
*/5 * * * * root /home/ec2-user/s3d.py ${backend_s3_created_bucket_name} Node_Exporter_Prometheus-1575384595496.json /var/lib/grafana/dashboards/Node_Exporter_Prometheus-1575384595496.json
EOF

systemctl restart crond
