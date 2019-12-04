output "backend_instance_ip_cart" {
  description = ""
  value       = "${aws_instance.cart_service.public_ip}"
}
output "backend_instance_ip_product" {
  description = ""
  value       = "${aws_instance.product_service.public_ip}"
}
output "backend_instance_ip_navigation" {
  description = ""
  value       = "${aws_instance.navigation_service.public_ip}"
}
output "backend_s3_created_bucket_name" {
  description = ""
  value       = "${var.s3_bucket_name}"
}
output "backend_region" {
  description = ""
  value       = "${var.region}"
}
output "backend_instance_type" {
  description = ""
  value       = "${var.instance_type}"
}
output "backend_image_id" {
  description = ""
  value       = "${var.instance_type}"
}
output "iam_s3" {
  description = ""
  value       = "${aws_iam_instance_profile.s3_profile.name}"
}

