#! /bin/bash
echo "Install Jenkins"
sudo su
yum -y update 
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
yum -y install java-1.8.0-openjdk jenkins git maven	golang python-pip ruby docker
sudo systemctl enable jenkins.service
sudo systemctl start jenkins.service
mkdir /var/lib/jenkins/init.groovy.d
touch /var/lib/jenkins/init.groovy.d/basic-security.groovy
cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy << EOF
#!groovy
import jenkins.model.*
import hudson.security.*
import jenkins.install.InstallState

def instance = Jenkins.getInstance()

// Create user with custom pass
def user = instance.getSecurityRealm().createAccount('${jenkins_user}', '${jenkins_pass}')
user.save()

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

instance.save()
EOF
sleep 120
sudo cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /tmp/jenkins-cli.jar

sudo systemctl restart jenkins.service
sleep 120
sudo mkdir /tmp/temp/
cd /tmp/temp/
git clone https://github.com/corevaluecamp/the-app/

sudo cp tmp/temp/the-app/jobs/files/config.xml /var/lib/jenkins/config.xml
sudo cp tmp/temp/the-app/jobs/files/jenkins.mvn.GlobalMavenConfig.xml /var/lib/jenkins/jenkins.mvn.GlobalMavenConfig.xml
sudo cp tmp/temp/the-app/jobs/files/hudson.tasks.Maven.xml /var/lib/jenkins/hudson.tasks.Maven.xml
sudo cp tmp/temp/the-app/jobs/files/org.jenkinsci.plugins.xvfb.Xvfb.xml /var/lib/jenkins/org.jenkinsci.plugins.xvfb.Xvfb.xml
sudo cp tmp/temp/the-app/jobs/files/org.jenkins.ci.plugins.xframe_filter.XFrameFilterPageDecorator.xml /var/lib/jenkins/org.jenkins.ci.plugins.xframe_filter.XFrameFilterPageDecorator.xml

sudo mkdir /var/lib/jenkins/repo-cache/

sudo java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} install-plugin git:4.0.0 github:1.29.5 terraform:1.0.9 ssh:2.6.1 job-dsl:1.76 workflow-aggregator:2.6 blueocean:1.21.0 pipeline-maven chucknorris:1.2 htmlpublisher:1.21 buildgraph-view:1.8 copyartifact:1.43 jacoco:3.0.4 greenballs -restart

sleep 120

echo "restore Jobs"
for BUILD in $(cat /tmp/temp/the-app/jobs/files/jobs.txt)
do
		cat "/tmp/temp/the-app/jobs/files/$BUILD.xml" | java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} create-job "$BUILD"
	if [ "$?" -ne "0" ]; then
	    cat "/tmp/temp/the-app/jobs/files/$BUILD.xml" | java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ -auth ${jenkins_user}:${jenkins_pass} create-job update-job "$BUILD"
    fi
done
