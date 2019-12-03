resource "aws_instance" "jenkins" {
    ami = "${var.instance-ami[2]}"
    instance_type = "t2.micro"
	key_name = "${var.key-name}"
    vpc_security_group_ids = ["${var.id-sg-bastion}"]
    subnet_id = "${var.subnet-pub-a-id}"
    associate_public_ip_address = true
    source_dest_check = false

  user_data = templatefile("${var.userdata-path}/install_jenkins.sh", {
    jenkins_user = "1"
    jenkins_pass = "1"
  })
	
    tags = {
        Name = "Jenkins"
    }
	
}
