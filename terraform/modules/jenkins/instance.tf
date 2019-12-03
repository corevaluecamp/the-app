	data "template_file" "install-jenkins" {
	template = "${file("install_jenkins.sh")}"
	vars = {
    jenkins_user = "${var.jenkins_user}"
	jenkins_pass = "${var.jenkins_pass}"
	
  }
}

resource "aws_instance" "jenkins" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-2a"
    instance_type = "t2.micro"
	key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

	user_data = "${data.template_file.install-jenkins.rendered}"

    tags = {
        Name = "Jenkins"
    }
}

resource "aws_eip" "jenkins" {
    instance = "${aws_instance.jenkins.id}"
    vpc = true
}
