# SET PROVIDER - AMAZON WEB SERVICES
provider "aws" {
  region = "${var.aws-region}"
}

module "network" {
  source = "./modules/network/"
}
module "security" {
  source = "./modules/security/"
  vpc-id = module.network.vpc-id
}
module "instances" {
  source          = "./modules/instances/"
  key-name        = module.security.key-name
  id-sg-bastion   = module.security.id-sg-bastion
  id-sg-private   = module.security.id-sg-private
  id-sg-mongodb   = module.security.id-sg-mongodb
  subnet-pub-a-id = module.network.subnet-pub-a-id
  subnet-pub-b-id = module.network.subnet-pub-b-id
  subnet-db-a-id  = module.network.subnet-db-a-id
}