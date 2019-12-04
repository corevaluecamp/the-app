variable "region" {} 
variable "shared_credentials_file" {}
variable "profile" {}
variable "my_ami" {
  type = "map"
}
variable "subnet-def-3-ID" {}
variable "my_IP" {}


provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
}

data "aws_subnet" "selected" {
  id = "${var.subnet-def-3-ID}"
}

data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
}

data "template_file" "init_node" {
  template = "${file("${path.module}/init_node.tpl")}"
}


resource "aws_instance" "inst-BE" {
  ami           = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-def-3-ID}"
  associate_public_ip_address = "true"
  key_name = "UbuntuBase"
  vpc_security_group_ids = [
    "${aws_security_group.HTTP_SSH_Admin.id}", "${aws_security_group.Metrics_Admin.id}", "${aws_default_security_group.default.id}"]
  user_data = "${data.template_file.init_node.rendered}"
  tags = {
	Name = "inst-BE"
  }
}

resource "aws_instance" "inst-M" {
  ami           = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-def-3-ID}"
  associate_public_ip_address = "true"
  key_name = "UbuntuBase"
  vpc_security_group_ids = [
    "${aws_security_group.HTTP_SSH_Admin.id}", "${aws_security_group.Metrics_Admin.id}", "${aws_default_security_group.default.id}"]
  user_data = "${data.template_file.init.rendered}"
  tags = {
	Name = "Monitoring"
  }
}

resource "aws_instance" "inst-J" {
  ami           = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-def-3-ID}"
  associate_public_ip_address = "true"
  key_name = "UbuntuBase"
  vpc_security_group_ids = [
    "${aws_security_group.HTTP_SSH_Admin.id}", "${aws_security_group.Metrics_Admin.id}", "${aws_default_security_group.default.id}"]
  user_data = "${data.template_file.init_node.rendered}"
  tags = {
	Name = "inst-J"
  }
}

resource "aws_instance" "inst-J1" {
  ami           = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-def-3-ID}"
  associate_public_ip_address = "true"
  key_name = "UbuntuBase"
  vpc_security_group_ids = [
    "${aws_security_group.HTTP_SSH_Admin.id}", "${aws_security_group.Metrics_Admin.id}", "${aws_default_security_group.default.id}"]
  user_data = "${data.template_file.init_node.rendered}"
  tags = {
	Name = "inst-J1"
  }
}

resource "aws_instance" "inst-J2" {
  ami           = "${lookup(var.my_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-def-3-ID}"
  associate_public_ip_address = "true"
  key_name = "UbuntuBase"
  vpc_security_group_ids = [
    "${aws_security_group.HTTP_SSH_Admin.id}", "${aws_security_group.Metrics_Admin.id}", "${aws_default_security_group.default.id}"]
  user_data = "${data.template_file.init_node.rendered}"
  tags = {
	Name = "inst-J2"
  }
}

resource "aws_security_group" "HTTP_SSH_Admin" {
  name = "HTTP_SSH_Admin"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id = "${data.aws_subnet.selected.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_IP}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.my_IP}"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.my_IP}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
	Name = "HTTP_SSH_Admin"
  }
}

resource "aws_security_group" "Metrics_Admin" {
  name = "Metrics_Admin"
  description = "Allows Prometheus and Node Exporter outher traffic"
  vpc_id = "${data.aws_subnet.selected.vpc_id}"

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["${var.my_IP}"]
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["${var.my_IP}"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["${var.my_IP}"]
  }

  tags = {
	Name = "Metrics_Admin"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${data.aws_subnet.selected.vpc_id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
	Name = "default"
  }
}