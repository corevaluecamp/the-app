/*output "backend_instance_ip_cart" {
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
}*/
output "frontend_instance_ip_catalog" {
  description = ""
  value       = "${aws_instance.frontend_catalog.public_ip}"
}
output "frontend_s3_created_bucket_name" {
  description = ""
  value       = "${var.s3_bucket_name}"
}
output "frontend_region" {
  description = ""
  value       = "${var.region}"
}
output "frontend_instance_type" {
  description = ""
  value       = "${var.instance_type}"
}
output "frontend_image_id" {
  description = ""
  value       = "${var.instance_type}"
}