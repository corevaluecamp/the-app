#!/bin/bash

#java
sudo yum remove java-1.7.0-openjdk
sudo yum install java-1.8.0-openjdk-devel -y

#tomcat
sudo yum -y install tomcat
sudo yum update -y
sudo systemctl enable tomcat
sudo systemctl start tomcat
#echo "welcome to tomcat,Hello World"

#apache
sudo yum -y install httpd
#sudo yum update -y
sudo systemctl start httpd

cat > /the-app/microservice/frontend/catalog/config/environments/production.json <<- EOF
"NAVIGATION_SERVICE_URL": "localhost:80/navigation/all"
"PRODUCT_SERVICE_URL": "localhost:80/product/all",
"CART_SERVICE_IMPL": "localhost:80/redis-microservice",
"CART_SERVICE_GET_URL": "localhost:80/cart/get/",
"CART_SERVICE_PUT_URL": "localhost:80/cart/create",
"CART_SERVICE_POST_URL": "localhost:80/cart/add",
"CART_SERVICE_DELETE_URL": "localhost:80/cart/removeItemFromCart",
"CHECKOUT_BASE_URL": "http://shop.monolith.io:8080/shop/checkout",
"GLOBAL_DISCOUNT": 0
EOF

#echo "ip redis-node" >> /etc/hosts
#echo "ip mongodb-node" >> /etc/hosts
echo "export BUCKET_NAME=${s3_bucketname}" >>  /home/ec2-user/.bashrc
echo "export NOW=$(date +'%b-%d-%H-%M-%S')" >>  /home/ec2-user/.bashrc

#set up Node.js on instance
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node
node -e "console.log('Running Node.js ' + process.version)"

mkdir /home/ec2-user/logs
touch /home/ec2-user/logs/app-product.log


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
yum install filebeat -y
sed -i -e 's/localhost:9200/${elastic_ip}:9200/g' /etc/filebeat/filebeat.yml
sed -i -e 's/enabled: false/enabled: true/g' /etc/filebeat/filebeat.yml
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