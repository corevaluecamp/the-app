data "template_file" "backend_cart_template" {
  template = "${file("${path.module}/backend_cart_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
    elastic_ip = "${var.es_ip}"
    mongo = "{var.mongo_ip}"
  }
}

data "template_file" "backend_product_template" {
  template = "${file("${path.module}/backend_product_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
    elastic_ip = "${var.es_ip}"
    mongo = "{var.mongo_ip}"
  }
}

data "template_file" "backend_navigation_template" {
  template = "${file("${path.module}/backend_navigation_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
    elastic_ip = "${var.es_ip}"
    mongo = "{var.mongo_ip}"
  }
}

