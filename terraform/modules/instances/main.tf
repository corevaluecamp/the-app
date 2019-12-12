data "template_file" "userdata-bastion" {
  template = "${file("${var.userdata-path}/userdata-bastion.tpl")}"
  vars = {
    filebeat-es-ip = "${var.filebeat-es-ip}",
    hostname       = "${var.name-tag[0]}"
  }
}
resource "aws_launch_template" "dos-bastion-launch-tmpl" {
  name          = "${var.name-tag[0]}"
  image_id      = "${var.instance-ami[0]}"
  instance_type = "${var.instance-type[0]}"
  key_name      = "${var.key-name}"
  vpc_security_group_ids = [
    "${var.id-sg-bastion}",
    "${var.dos-metrics-logging}"
  ]
  disable_api_termination = true
  user_data               = "${base64encode(data.template_file.userdata-bastion.rendered)}"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name-tag[0]}"
    }
  }
  tags = {
    Name = "${var.name-tag[0]}-launch-tmpl"
  }
}
resource "aws_autoscaling_group" "dos-bastion-asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  launch_template {
    id      = "${aws_launch_template.dos-bastion-launch-tmpl.id}"
    version = "$Latest"
  }
}
resource "aws_instance" "dos-mongodb" {
  count         = 1
  ami           = "${var.instance-ami[2]}"
  instance_type = "${var.instance-type[0]}"
  key_name      = "${var.key-name}"
  vpc_security_group_ids = [
    "${var.id-sg-private}",
    "${var.id-sg-mongodb}",
    "${var.id-sg-jenkins}",
    "${var.dos-metrics-logging}"
  ]
  subnet_id = "${var.subnet-db-a-id}"
  user_data = templatefile("${var.userdata-path}/userdata-mongo.tpl", {
    dbhost         = "${var.mongodb-server-domain}"
    filebeat-es-ip = "${var.filebeat-es-ip}"
    hostname       = "${var.name-tag[1]}"
  })
  tags = {
    Name = "${var.name-tag[1]}"
  }
}
resource "aws_instance" "dos-redis" {
  count         = 1
  ami           = "${var.instance-ami[1]}"
  instance_type = "${var.instance-type[0]}"
  key_name      = "${var.key-name}"
  vpc_security_group_ids = [
    "${var.id-sg-private}",
    "${var.id-sg-redis}",
    "${var.dos-metrics-logging}"
  ]
  subnet_id = "${var.subnet-db-a-id}"
  user_data = templatefile("${var.userdata-path}/userdata-redis.tpl", {
    filebeat-es-ip = "${var.filebeat-es-ip}"
    hostname       = "${var.name-tag[2]}"
  })
  tags = {
    Name = "${var.name-tag[2]}"
  }
}
