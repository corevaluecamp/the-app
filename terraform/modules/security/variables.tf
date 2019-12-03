variable "my-ip" {
  type        = "string"
  default     = "http://ipv4.icanhazip.com"
  description = "My ip address"
}
variable "sg-name" {
  type = "list"
  default = [
    "dos-bastion-access",
    "dos-private-access",
    "dos-mongodb-connect",
    "dos-redis-connect",
  ]
  description = "List of security group's names"
}
variable "key-name" {
  type        = "string"
  default     = "dos-key"
  description = "Key pair name"
}
variable "pub-key" {
  type        = "string"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZj1m6di8Ia/g8TiBp9f/pZUMNYbLpa6PqV+XMS1PMycWy63uz/Pnb9B25tFb3PE1Mkmc6TWWlHvD/0rAuiZLklXf6aP6tEUPcRN1fQ1IZeF9ZPH7ntW0kEEZVDHboEi7IWicvUbg9YFGui7HjM6zkwaOsayqWqI5bL1y6nZExJYfJFL23864FmrjS4sEm0xDkknmSTEL3nLn5Zu/EkSqHEWWg6UgqHs4vEbbN61k+fqcETklpZFCtrGQlSRxxuMwWmAUwXRiXJmd9IQIoVSBADLWY/4F4mtQznuYdol7hKJf7SMPglXyeFEpPZCcuoc2LFOWLjotPj0JDdffHfJp7 kukushioku@DESKTOP-85ERL4C"
  description = "Public part of key pair"
}
variable "vpc-id" {}
