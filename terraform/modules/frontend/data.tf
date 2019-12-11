data "template_file" "frontend_catalog_template" {
  template = "${file("${path.module}/frontend_catalog_template.sh")}"

  vars = {
    s3_bucketname = "${var.s3_bucket_name}"
    elastic_ip = "${var.es_ip}"
  }
} 