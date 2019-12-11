resource "aws_instance" "frontend_catalog" {
  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3_profile.name}"
  #associate_public_ip_address = true
  subnet_id                   = "${var.my_public_subnet}"

  user_data = "${data.template_file.frontend_catalog_template.rendered}"
  tags = {
    Name = "Catalog"
  }
}