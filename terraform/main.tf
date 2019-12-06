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
}
module "security" {
  source = "./modules/security/"
  vpc-id = module.network.vpc-id
}
module "instances" {
  source                = "./modules/instances/"
  key-name              = module.security.key-name
  id-sg-bastion         = module.security.id-sg-bastion
  id-sg-private         = module.security.id-sg-private
  id-sg-mongodb         = module.security.id-sg-mongodb
  id-sg-jenkins         = module.security.id-sg-jenkins
  id-sg-jenkins-ssh     = module.security.id-sg-jenkins-ssh
  subnet-pub-a-id       = module.network.subnet-pub-a-id
  subnet-pub-b-id       = module.network.subnet-pub-b-id
  subnet-db-a-id        = module.network.subnet-db-a-id
  mongodb-server-domain = module.network.mongodb-server-domain
  # subnet-priv-a-id      = module.network.subnet-priv-a-id
  # subnet-priv-b-id      = module.network.subnet-priv-b-id
}

module "jenkins" {
  source            = "./modules/jenkins/"
  id-sg-bastion     = module.security.id-sg-bastion
  id-sg-jenkins     = module.security.id-sg-jenkins
  id-sg-jenkins-ssh = module.security.id-sg-jenkins-ssh
  id-sg-private     = module.security.id-sg-private
  key-name          = module.security.key-name
  subnet-pub-a-id   = module.network.subnet-pub-a-id
  subnet-pub-b-id   = module.network.subnet-pub-b-id
  subnet-priv-a-id  = module.network.subnet-priv-a-id
  subnet-priv-b-id  = module.network.subnet-priv-b-id
  jenkins_user      = "${var.jenkins_user}"
  jenkins_pass      = "${var.jenkins_pass}"
  iam_role          = module.backend.iam_s3
}

module "backend" {
  source         = "./modules/backend"
  key            = module.security.key-name
  s3_bucket_name = "${var.s3_bucket_name}"
  id-sg-bastion = module.security.id-sg-bastion
  id-sg-backend = module.security.id-sg-backend
  id-sg-private = module.security.id-sg-private
  id-sg-mongodb = module.security.id-sg-mongodb
  id-sg-jenkins = module.security.id-sg-jenkins
  subnet-pub-a-id = module.network.subnet-pub-a-id
  subnet-pub-b-id = module.network.subnet-pub-b-id
  subnet-priv-a-id = module.network.subnet-priv-a-id
  subnet-priv-b-id = module.network.subnet-priv-b-id
  my_vpc = module.network.vpc-id
  mongo_ip = module.instances.mongo-server-ip
  #es_ip = module.logging.elasticsearch_ip
  #force_des = true
  # my_sg  = module.security.id-sg-bastion

}

module "monitoring" {
  source                     = "./modules/monitoring"
  key-name                   = module.security.key-name
  subnet_id                  = module.network.subnet-pub-a-id
  # s3_bucket_name = "${var.s3_bucket_name}"
  id-sg-metrics              = module.security.id-sg-metrics
  id-sg-monitoring-access    = module.security.id-sg-monitoring-access
}

module "logging" {
  source                     = "./modules/logging"
  key-name          = module.security.key-name
  subnet-pub-a-id   = module.network.subnet-pub-a-id
  subnet-pub-b-id   = module.network.subnet-pub-b-id
  subnet-priv-a-id  = module.network.subnet-priv-a-id
  subnet-priv-b-id  = module.network.subnet-priv-b-id
  my_vpc = module.network.vpc-id
}
