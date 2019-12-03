module "elk" {
  source = "./Logging"
}
module "filebeat" {
  source = "./Filebeat"
  elsip  = module.elk.elasticsearch_ip
}
