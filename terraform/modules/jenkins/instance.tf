	data "template_file" "install-jenkins" {
	template = "${file("install_jenkins.sh")}"
	vars = {
    jenkins_user = "1"
	jenkins_pass = "1"
	
  }
}

resource "aws_instance" "jenkins" {
    ami = "${var.instance-ami[2]}"
    instance_type = "t2.micro"
	key_name = "${var.key-name}"
    vpc_security_group_ids = ["${var.id-sg-bastion}"]
    subnet_id = "${var.subnet-pub-a-id}"
    associate_public_ip_address = true
    source_dest_check = false

	user_data = "${data.template_file.install-jenkins.rendered}"

    tags = {
        Name = "Jenkins"
    }
}

resource "aws_autoscaling_group" "jenkins-asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  launch_template {
    id      = "${aws_instance.jenkins.id}"
    version = "$Latest"
  }
}

resource "aws_eip" "jenkins" {
    instance = "${aws_instance.jenkins.id}"
    vpc = true
}
