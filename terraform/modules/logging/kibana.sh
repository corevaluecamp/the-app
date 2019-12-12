#!/bin/bash
# Download and install kibana
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
yum update -y
yum install kibana -y
# Configure kibana
sed -i -e 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
cat >> /etc/kibana/kibana.yml <<-EOF
elasticsearch.hosts: ["http://${elastic_ip}:9200"]
EOF
# Add kibana to startup
systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service
sleep 50
# Set  dark mode
IP=`curl -k -s http://ifconfig.co`
curl -X POST "http://$IP:5601/api/kibana/settings" --header "Content-type: application/json" -H 'kbn-xsrf: true' -d '{"changes":{"theme:darkMode":true}}'
# Install filebeat
yum install filebeat -y
# Configure filebeat
sed -i -e 's/localhost:9200/${elastic_ip}:9200/g' /etc/filebeat/filebeat.yml
sed -i -e 's/enabled: false/enabled: true/g' /etc/filebeat/filebeat.yml
sed -i '31c\    - /home/ec2-user/logs/*.log' /etc/filebeat/filebeat.yml
# Create custom index name
cat >> /etc/filebeat/filebeat.yml <<-EOF
setup.ilm.rollover_alias: "kibana"
setup.ilm.overwrite: true
EOF
# Add filebeat to startup
systemctl enable filebeat
systemctl start filebeat
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
