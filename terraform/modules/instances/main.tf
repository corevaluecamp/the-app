resource "aws_instance" "dos-bastion" {
  count                  = 1
  ami                    = "${var.instance-ami[1]}"
  instance_type          = "${var.instance-type[0]}"
  key_name               = "${var.key-name}"
  vpc_security_group_ids = ["${var.id-sg-bastion}"]
  subnet_id              = "${var.subnet-pub-a-id}"
  tags = {
    Name = "${var.bastion-name}"
  }
}
resource "aws_instance" "dos-mongodb" {
  count                  = 1
  ami                    = "${var.instance-ami[0]}"
  instance_type          = "${var.instance-type[0]}"
  key_name               = "${var.key-name}"
  vpc_security_group_ids = ["${var.id-sg-bastion}", "${var.id-sg-mongodb}"]
  subnet_id              = "${var.subnet-db-a-id}"
  tags = {
    Name = "${var.mongodb-name}"
  }
}
