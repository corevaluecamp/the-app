

data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
}

resource "aws_instance" "Monitoring" {
  ami           = var.my_ami
  instance_type = var.instance_type
  key_name = var.key-name
  subnet_id = var.subnet_id
  # iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  associate_public_ip_address = "false"
  user_data = "${data.template_file.init.rendered}"
  vpc_security_group_ids = [
    "${var.id-sg-metrics}", "${var.id-sg-monitoring-access}"]
  tags = {
	Name = "Monitoring"
  }
}
