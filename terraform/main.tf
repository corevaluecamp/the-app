# SET PROVIDER - AMAZON WEB SERVICES
terraform {
  required_version = "> 0.12.08"
}

provider "aws" {
  region = "${var.aws-region}"
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
  subnet-pub-a-id       = module.network.subnet-pub-a-id
  subnet-pub-b-id       = module.network.subnet-pub-b-id
  subnet-db-a-id        = module.network.subnet-db-a-id
  mongodb-server-domain = module.network.mongodb-server-domain
}

module "jenkins" {
  source          = "./modules/jenkins/"
  id-sg-bastion   = module.security.id-sg-bastion
  key-name        = module.security.key-name
  subnet-pub-a-id = module.network.subnet-pub-a-id
  jenkins_user1   = 1
}

/* module "backend" {
  source         = "./modules/backend"
  key            = module.security.key-name
  s3_bucket_name = "${var.s3_bucket_name}"
  #my_private_subnet = ""
  #my_public_subnet  = ""
  #my_sg             = ""
  my_vpc   = module.network.vpc-id
  mongo_ip = module.instances.mongo-server-ip
}
 */