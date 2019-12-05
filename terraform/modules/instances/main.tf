resource "aws_launch_template" "dos-bastion-launch-tmpl" {
  name                    = "${var.bastion-name}"
  image_id                = "${var.instance-ami[1]}"
  instance_type           = "${var.instance-type[0]}"
  key_name                = "${var.key-name}"
  vpc_security_group_ids  = ["${var.id-sg-bastion}"]
  disable_api_termination = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.bastion-name}"
    }
  }
  tags = {
    Name = "${var.bastion-name}-launch-tmpl"
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
    "${var.id-sg-jenkins-ssh}"
  ]
  subnet_id = "${var.subnet-db-a-id}"
  user_data = templatefile("${var.userdata-path}userdata-mongo.tpl", {
    dbhost = "${var.mongodb-server-domain}"
  })
  tags = {
    Name = "${var.mongodb-name}"
  }
}
