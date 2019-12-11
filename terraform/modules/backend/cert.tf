/* resource "aws_acm_certificate" "cert" {
  domain_name       = "dos.net"
  validation_method = "DNS"

  tags = {
    Name = "Main cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
 */