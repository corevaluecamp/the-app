resource "aws_instance" "cart_service" {
  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  associate_public_ip_address = true
  subnet_id                   = "${var.my_public_subnet}"
  security_groups             = ["${var.my_sg}"]

  user_data = "${data.template_file.backend_cart_template.rendered}"

  tags = {
    Name = "Cart"

  }
}


resource "aws_instance" "navigation_service" {
  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  associate_public_ip_address = true
  subnet_id                   = "${var.my_public_subnet}"
  security_groups             = ["${var.my_sg}"]

  user_data = "${data.template_file.backend_navigation_template.rendered}"

  tags = {
    Name = "Navigation"

  }
}

resource "aws_instance" "product_service" {
  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  associate_public_ip_address = true
  subnet_id                   = "${var.my_public_subnet}"
  security_groups             = ["${var.my_sg}"]

  user_data = "${data.template_file.backend_product_template.rendered}"
  tags = {
    Name = "Product"

  }
}

#for build change to micro to medium 
resource "aws_instance" "jenkins" {
  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  associate_public_ip_address = true
  subnet_id                   = "${var.my_public_subnet}"
  security_groups             = ["${var.my_sg}"]

  user_data = "${data.template_file.jenkins_instances_template.rendered}"
  tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "frontend" {
  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  associate_public_ip_address = true
  subnet_id                   = "${var.my_public_subnet}"
  security_groups             = ["${var.my_sg}"]

  user_data = "${data.template_file.frontend_instances_template.rendered}"
  tags = {
    Name = "front"
  }
}





