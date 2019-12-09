data "template_file" "install-jenkins" {
  template = "${file("${var.userdata-path}/install_jenkins.sh")}"
  vars = {
    jenkins_user = "${var.jenkins_user}"
    jenkins_pass = "${var.jenkins_pass}"
    elastic_ip   = "127.0.0.1"
  }
}


resource "aws_launch_template" "jenkins-launch-tmpl" {
  name          = "Jenkins"
  image_id      = "${var.instance-ami[0]}"
  instance_type = "${var.instance-type[1]}"
  key_name      = "${var.key-name}"
  #  vpc_security_group_ids = ["${var.id-sg-bastion}"]
  vpc_security_group_ids  = ["${var.id-sg-jenkins}", "${var.id-sg-private}"]
  disable_api_termination = true

  iam_instance_profile {
    name = "${var.iam_role}"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Jenkins"
    }
  }
  user_data = "${base64encode(data.template_file.install-jenkins.rendered)}"

  tags = {
    Name = "jenkins-launch-tmpl"
  }
}
resource "aws_autoscaling_group" "jenkins" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  # vpc_zone_identifier = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  vpc_zone_identifier = ["${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  launch_template {
    id      = "${aws_launch_template.jenkins-launch-tmpl.id}"
    version = "$Latest"
  }
}
