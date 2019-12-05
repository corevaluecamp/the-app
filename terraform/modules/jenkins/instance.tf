resource "aws_launch_template" "jenkins-launch-tmpl" {
  name                    = "Jenkins"
  image_id                = "${var.instance-ami[0]}"
  instance_type           = "${var.instance-type[1]}"
  key_name                = "${var.key-name}"
  vpc_security_group_ids  = ["${var.id-sg-bastion}"]
  disable_api_termination = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Jenkins"
    }
  }
    user_data = templatefile("${var.userdata-path}/install_jenkins.sh", {
    jenkins_user = "1"
    jenkins_pass = "1"
  })
  
  tags = {
    Name = "jenkins-launch-tmpl"
  }
}
resource "aws_autoscaling_group" "jenkins" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  launch_template {
    id      = "${aws_launch_template.jenkins-launch-tmpl.id}"
    version = "$Latest"
  }
}
