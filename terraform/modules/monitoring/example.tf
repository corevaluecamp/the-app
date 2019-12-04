

data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
}

resource "aws_instance" "Monitoring" {
  ami           = var.my_ami
  instance_type = var.instance_type
  key_name = var.key
  associate_public_ip_address = "true"
  user_data = "${data.template_file.init.rendered}"
  vpc_security_group_ids = [
    "${aws_security_group.HTTP_SSH_Admin.id}", "${aws_security_group.Metrics_Admin.id}"]
  tags = {
	Name = "Monitoring"
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
  description = "Allows Prometheus, Node Exporter and Grafana outher traffic"
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
