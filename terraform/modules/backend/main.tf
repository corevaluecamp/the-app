resource "aws_instance" "cart_service" {
  ami                  = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key}"
  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"
  #associate_public_ip_address = true
  subnet_id       = "${var.my_public_subnet}"
  security_groups = ["${aws_security_group.my_sg.id}"]
  # security_groups = ["${var.id-sg-backend}", "${var.id-sg-private}", "${var.id-sg-mongodb}", "${var.id-sg-jenkins}"]

  user_data = "${data.template_file.backend_cart_template.rendered}"

  tags = {
    Name = "Cart"

  }
}


resource "aws_instance" "navigation_service" {
  ami                  = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key}"
  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"
  # associate_public_ip_address = true
  subnet_id       = "${var.my_public_subnet}"
  security_groups = ["${aws_security_group.my_sg.id}"]

  user_data = "${data.template_file.backend_navigation_template.rendered}"

  tags = {
    Name = "Navigation"

  }
}

resource "aws_instance" "product_service" {
  ami                  = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key}"
  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"
  #associate_public_ip_address = true
  subnet_id       = "${var.my_public_subnet}"
  security_groups = ["${aws_security_group.my_sg.id}"]

  user_data = "${data.template_file.backend_product_template.rendered}"
  tags = {
    Name = "Product"

  }
}
