data "template_file" "backend_cart_template" {
  template = "${file("${path.module}/backend_cart_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
  }
}

data "template_file" "backend_product_template" {
  template = "${file("${path.module}/backend_product_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
  }
}

data "template_file" "backend_navigation_template" {
  template = "${file("${path.module}/backend_navigation_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
  }
}


data "template_file" "jenkins_instances_template" {
  template = "${file("${path.module}/jenkins_template_file.sh")}"
  vars = {
    s3_bucketname_jen = "${var.s3_bucket_name}"
  }
}

data "template_file" "frontend_instances_template" {
  template = "${file("${path.module}/frontend_template_file.sh")}"

}
