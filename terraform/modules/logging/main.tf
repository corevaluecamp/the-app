resource "aws_instance" "ELSearch" {
  ami                    = var.instance-ami[0]
  instance_type          = var.instance-type[1]
  vpc_security_group_ids = [var.id-sg-private, var.id-sg-jenkins, var.dos-metrics-logging]
  key_name               = var.key-name
  user_data              = file("${path.module}/elasticsearch.sh")
  subnet_id              = "${var.subnet-priv-a-id}"
  tags = {
    Name = "ELSearch"
  }
}
resource "aws_instance" "Kibana" {
  ami                    = var.instance-ami[0]
  instance_type          = var.instance-type[1]
  vpc_security_group_ids = [var.id-sg-private, var.id-sg-jenkins, var.dos-metrics-logging]
  # vpc_security_group_ids = [var.id-sg-es, var.id-sg-kibana, var.id-sg-private, var.id-sg-jenkins]
  # vpc_security_group_ids = [aws_security_group.security_for_kibana.id]
  key_name  = var.key-name
  user_data = data.template_file.scriptkibana.rendered
  # subnet_id = "${var.subnet-pub-a-id}"
  subnet_id = "${var.subnet-priv-a-id}"
  tags = {
    Name = "Kibana"
  }
}
data "template_file" "scriptkibana" {
  template = "${file("${path.module}/kibana.sh")}"
  vars = {
    elastic_ip = aws_instance.ELSearch.private_ip
  }
}
# resource "aws_security_group" "security_for_kibana" {
#   name        = "SecurityForKibana"
#   description = "Security For Kibana"
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 5601
#     to_port     = 5601
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# resource "aws_security_group" "security_for_elasticsearch" {
#   name        = "SecurityForElasticsearch"
#   description = "Security For Elasticsearch"
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 9200
#     to_port     = 9200
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
