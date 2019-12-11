# SET PROVIDER - AMAZON WEB SERVICES
provider "aws" {
  region = "${var.aws-region}"
}
terraform {
  required_version = "> 0.12.08"
}
module "network" {
  source          = "./modules/network/"
  mongo-server-ip = module.instances.mongo-server-ip
  redis-server-ip = module.instances.redis-server-ip
}
module "security" {
  source = "./modules/security/"
  vpc-id = module.network.vpc-id
  all-ip = module.network.all-ip
}
module "instances" {
  source                = "./modules/instances/"
  key-name              = module.security.key-name
  id-sg-bastion         = module.security.id-sg-bastion
  id-sg-private         = module.security.id-sg-private
  id-sg-mongodb         = module.security.id-sg-mongodb
  id-sg-jenkins         = module.security.id-sg-jenkins
  subnet-pub-a-id       = module.network.subnet-pub-a-id
  subnet-pub-b-id       = module.network.subnet-pub-b-id
  subnet-db-a-id        = module.network.subnet-db-a-id
  subnet-db-b-id        = module.network.subnet-db-b-id
  mongodb-server-domain = module.network.mongodb-server-domain
  redis-server-domain   = module.network.redis-server-domain
  subnet-priv-a-id      = module.network.subnet-priv-a-id
  subnet-priv-b-id      = module.network.subnet-priv-b-id
  id-sg-redis           = module.security.id-sg-redis
  filebeat-es-ip        = module.logging.elasticsearch_ip
}

module "jenkins" {
  source           = "./modules/jenkins/"
  id-sg-bastion    = module.security.id-sg-bastion
  id-sg-jenkins    = module.security.id-sg-jenkins
  id-sg-private    = module.security.id-sg-private
  id-sg-metrics    = module.security.id-sg-metrics
  key-name         = module.security.key-name
  subnet-pub-a-id  = module.network.subnet-pub-a-id
  subnet-pub-b-id  = module.network.subnet-pub-b-id
  subnet-priv-a-id = module.network.subnet-priv-a-id
  subnet-priv-b-id = module.network.subnet-priv-b-id
  jenkins_user     = "${var.jenkins_user}"
  jenkins_pass     = "${var.jenkins_pass}"
  iam_role         = module.backend.iam_s3
  elsip            = module.logging.elasticsearch_ip
  id-sg-load       = module.security.id-sg-load
  id-sg-mongodb    = module.security.id-sg-mongodb
  backend_s3_created_bucket_name = module.backend.backend_s3_created_bucket_name
  application_load_balancer_DNS = module.backend.application_load_balancer_dns
}

module "backend" {
  source                  = "./modules/backend"
  key                     = module.security.key-name
  s3_bucket_name          = "${var.s3_bucket_name}"
  id-sg-bastion           = module.security.id-sg-bastion
  id-sg-backend           = module.security.id-sg-backend
  id-sg-private           = module.security.id-sg-private
  id-sg-mongodb           = module.security.id-sg-mongodb
  id-sg-jenkins           = module.security.id-sg-jenkins
  id-sg-redis             = module.security.id-sg-redis
  id-sg-monitoring-access = module.security.id-sg-monitoring-access
  id-sg-kibana            = module.security.id-sg-kibana
  id-sg-metrics           = module.security.id-sg-metrics
  subnet-pub-a-id         = module.network.subnet-pub-a-id
  subnet-pub-b-id         = module.network.subnet-pub-b-id
  subnet-priv-a-id        = module.network.subnet-priv-a-id
  subnet-priv-b-id        = module.network.subnet-priv-b-id
  my_vpc                  = module.network.vpc-id
  mongo_ip                = module.instances.mongo-server-ip
  redis_ip                = module.instances.redis-server-ip
  kibana_id               = module.logging.kibana_id
  grafana_id              = module.monitoring.grafana_id
  jenkins_asg_id          = module.jenkins.jenkins_asg_id
  es_ip                   = module.logging.elasticsearch_ip
  id-sg-load              = module.security.id-sg-load
  s3force                 = true

}

module "monitoring" {
  source                         = "./modules/monitoring"
  key-name                       = module.security.key-name
  backend_s3_created_bucket_name = module.backend.backend_s3_created_bucket_name
  id-sg-metrics                  = module.security.id-sg-metrics
  id-sg-monitoring-access        = module.security.id-sg-monitoring-access
  id-sg-private                  = module.security.id-sg-es
  subnet-priv-a-id               = module.network.subnet-priv-a-id
  subnet-priv-b-id               = module.network.subnet-priv-b-id
  elasticip                      = module.logging.elasticsearch_ip
  id-sg-load                     = module.security.id-sg-load
}

module "logging" {
  source           = "./modules/logging"
  key-name         = module.security.key-name
  subnet-pub-a-id  = module.network.subnet-pub-a-id
  subnet-pub-b-id  = module.network.subnet-pub-b-id
  subnet-priv-a-id = module.network.subnet-priv-a-id
  subnet-priv-b-id = module.network.subnet-priv-b-id
  id-sg-es         = module.security.id-sg-es
  id-sg-kibana     = module.security.id-sg-kibana
  id-sg-private    = module.security.id-sg-es
  id-sg-jenkins    = module.security.id-sg-jenkins
  id-sg-bastion    = module.security.id-sg-bastion
  instance-ami     = module.instances.instance-ami
  instance-type    = module.instances.instance-type
  # my_vpc           = module.network.vpc-id
}
