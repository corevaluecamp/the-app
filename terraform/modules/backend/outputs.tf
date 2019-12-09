output "backend_s3_created_bucket_name" {
  description = ""
  value       = "${aws_s3_bucket.artifacts_bucket.bucket}"
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

output "application_load_balancer_dns" {
  description = ""
  value       = "${aws_alb.main.dns_name}"
}