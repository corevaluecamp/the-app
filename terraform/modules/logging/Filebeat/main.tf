variable "elsip" {}
resource "aws_instance" "Beat" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_for_filebeat.id]
  key_name               = var.key
  tags = {
    Name = "Beat"
  }
  user_data = data.template_file.scriptfilebeat.rendered
}
data "template_file" "scriptfilebeat" {
  template = "${file("${path.module}/filebeat.sh")}"
  vars = {
    elastic_ip = var.elsip
  }
}
resource "aws_security_group" "security_for_filebeat" {
  name        = "SecurityForFilebeat"
  description = "Security For Filebeat"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
