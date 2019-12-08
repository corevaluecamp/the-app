#! /bin/bash

###################################
# Installing and settings Jenkins #
###################################
 
# Install pre-requisites and updates
echo "Install Jenkins"
yum -y update 
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
yum -y install java-1.8.0-openjdk-devel jenkins git golang python-pip python3 docker gcc-c++ make nodejs 
pip3 install boto3
amazon-linux-extras install ruby2.6
yum install -y ruby-devel
gem install compass --no-user-install
npm install -g grunt-cli
npm install -g bower
npm install typescript
npm install typings

# Enabling Jenkins service
systemctl enable jenkins.service

# Starting Jenkins with new credintials
systemctl start jenkins.service

# Creating Jenkins groovy script that create new user from terraform template
mkdir /var/lib/jenkins/init.groovy.d
touch /var/lib/jenkins/init.groovy.d/basic-security.groovy
cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy << EOF
#!groovy
import jenkins.model.*
import hudson.security.*
import jenkins.install.InstallState
def instance = Jenkins.getInstance()
def user = instance.getSecurityRealm().createAccount('${jenkins_user}', '${jenkins_pass}')
user.save()
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
instance.save()
EOF

# Waiting for Jenkins start
sleep 40

# Downloading Jenkins CLI
cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /tmp/jenkins-cli.jar

# Waiting for Jenkins restart
systemctl restart jenkins.service
sleep 40

# Cloning github project
mkdir /tmp/temp
git clone https://github.com/corevaluecamp/the-app/ /tmp/temp/

# Copying Jenkins settings
cp /tmp/temp/terraform/modules/jenkins/files/config.xml /var/lib/jenkins/config.xml
cp /tmp/temp/terraform/modules/jenkins/files/jenkins.mvn.GlobalMavenConfig.xml /var/lib/jenkins/jenkins.mvn.GlobalMavenConfig.xml
cp /tmp/temp/terraform/modules/jenkins/files/hudson.tasks.Maven.xml /var/lib/jenkins/hudson.tasks.Maven.xml
cp /tmp/temp/terraform/modules/jenkins/files/org.jenkinsci.plugins.xvfb.Xvfb.xml /var/lib/jenkins/org.jenkinsci.plugins.xvfb.Xvfb.xml
cp /tmp/temp/terraform/modules/jenkins/files/org.jenkins.ci.plugins.xframe_filter.XFrameFilterPageDecorator.xml /var/lib/jenkins/org.jenkins.ci.plugins.xframe_filter.XFrameFilterPageDecorator.xml
cp /tmp/temp/terraform/modules/jenkins/files/locale.xml /var/lib/jenkins/locale.xml

mkdir /var/lib/jenkins/appstash
chmod 777 /var/lib/jenkins/appstash
chown jenkins:jenkins /var/lib/jenkins/appstash
git clone https://github.com/corevaluecamp/the-app/ /var/lib/jenkins/appstash

//mkdir /home/ec2-user/corevalue/
//git clone https://github.com/corevaluecamp/the-app/ /home/ec2-user/corevalue/

# Installing Jenkins Plugins and restart Jenkins
java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} install-plugin git:4.0.0 github:1.29.5 terraform:1.0.9 ssh:2.6.1 job-dsl:1.76 workflow-aggregator:2.6 blueocean:1.21.0 pipeline-maven chucknorris:1.2 htmlpublisher:1.21 buildgraph-view:1.8 copyartifact:1.43 jacoco:3.0.4 greenballs locale:1.4 -restart

# Waiting for Jenkins restart
sleep 60

# Restoring(Updating) Jobs
for BUILD in $(cat /tmp/temp/jobs/files/jobs.txt)
do
		cat "/tmp/temp/jobs/files/$BUILD.xml" | java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} create-job "$BUILD"
	if [ "$?" -ne "0" ]; then
	    cat "/tmp/temp/jobs/files/$BUILD.xml" | java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} create-job update-job "$BUILD"
    fi
done

for BUILD in $(cat /tmp/temp/jobs/files/monolitic/jobs.txt)
do
		cat "/tmp/temp/jobs/files/monolitic/$BUILD.xml" | java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} create-job "$BUILD"
	if [ "$?" -ne "0" ]; then
	    cat "/tmp/temp/jobs/files/monolitic/$BUILD.xml" | java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} create-job update-job "$BUILD"
    fi
done


######################################
# Installing Node Exporter user-data #
######################################

# Downloading the node exporter package
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz -P /tmp

# Unpacking the tarball 
tar xf /tmp/node_exporter-0.18.1.linux-amd64.tar.gz -C /opt/

# Moving the node export binary to /usr/local/bin
mv /opt/node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/

# Creating a node_exporter user to run the node exporter service *}
useradd -rs /bin/false node_exporter

# Creating a node_exporter service file under systemd
bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
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
systemctl daemon-reload
systemctl start node_exporter

# systemctl is-active --quiet node_exporter && echo "node_exporter is running" || echo "node_exporter is NOT running"

# Enabling the node exporter service to the system startup *}
systemctl enable node_exporter

#################################
# Installing Filebeat user-data #
#################################

#!/bin/bash

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

sed -i -e 's/enabled: false/enabled: true/g' /etc/filebeat/filebeat.yml
systemctl enable filebeat
systemctl start filebeat
