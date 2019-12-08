data "template_file" "backend_cart_template" {
  template = "${file("${path.module}/backend_cart_template.sh")}"

  vars = {
    s3_bucketname = "${aws_s3_bucket.artifacts_bucket.bucket}"
    elastic_ip    = "${var.es_ip}"
    mongo         = "${var.mongo_ip}"
    redis         = "${var.redis_ip}"
  }
}

data "template_file" "backend_product_template" {
  template = "${file("${path.module}/backend_product_template.sh")}"

  vars = {
    s3_bucketname = "${aws_s3_bucket.artifacts_bucket.bucket}"
    elastic_ip    = "${var.es_ip}"
    mongo         = "${var.mongo_ip}"
    redis         = "${var.redis_ip}"
  }
}

data "template_file" "backend_navigation_template" {
  template = "${file("${path.module}/backend_navigation_template.sh")}"

  vars = {
    s3_bucketname = "${aws_s3_bucket.artifacts_bucket.bucket}"
    elastic_ip    = "${var.es_ip}"
    mongo         = "${var.mongo_ip}"
    redis         = "${var.redis_ip}"
  }
}

data "template_file" "backend_tomcat_template" {
  template = "${file("${path.module}/backend_tomcat_template.sh")}"

  vars = {
    s3_bucketname = "${aws_s3_bucket.artifacts_bucket.bucket}"
    elastic_ip    = "${var.es_ip}"
    mongo         = "${var.mongo_ip}"
    redis         = "${var.redis_ip}"
  }
}


