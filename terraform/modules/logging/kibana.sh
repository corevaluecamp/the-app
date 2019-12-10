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
yum update -y
yum install kibana -y
sed -i -e 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
cat >> /etc/kibana/kibana.yml <<-EOF
elasticsearch.hosts: ["http://${elastic_ip}:9200"]
EOF
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
systemctl start kibana.service
sleep 150
IP=`curl -k -s http://ifconfig.co`
curl -X POST "http://$IP:5601/api/kibana/settings" --header "Content-type: application/json" -H 'kbn-xsrf: true' -d '{"changes":{"theme:darkMode":true}}'
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
