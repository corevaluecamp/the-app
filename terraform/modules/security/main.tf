# module "network" {
#   source = "../../modules/network/"
# }
# MY IP ADDRESS LOCATION
data "http" "my-ipaddress" {
  url = "${var.my-ip}"
}

# CREATE SECURITY GROUPS WITH RULES
# security group allows remote connection to bastion host
resource "aws_security_group" "dos-bastion-access" {
  name        = "dos-bastion-access"
  description = "Allow access to bastion host"
  vpc_id      = "${var.vpc-id}"
  tags = {
    Name = "${var.sg-name[0]}"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my-ipaddress.body)}/32"]
    description = "Allow SSH connection to bastion host"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# security group allows connection to private area hosts from bastion over SSH
resource "aws_security_group" "dos-private-access" {
  name        = "dos-private-access"
  description = "Allow access to private network hosts"
  vpc_id      = "${var.vpc-id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg-name[1]}"
  }
}
resource "aws_security_group_rule" "dos-private-access-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.dos-private-access.id}"
  source_security_group_id = "${aws_security_group.dos-bastion-access.id}"
}
# security group allows connection to MongoDB host
resource "aws_security_group" "dos-mongodb-connect" {
  name        = "dos-mongodb-connect"
  description = "Allow connection to MongoDB"
  vpc_id      = "${var.vpc-id}"
  tags = {
    Name = "${var.sg-name[2]}"
  }
}
resource "aws_security_group_rule" "dos-mongodb-ingress" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.dos-mongodb-connect.id}"
}
resource "aws_security_group_rule" "dos-mongodb-egress" {
  type              = "egress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.dos-mongodb-connect.id}"
}
# for replication servers only
# resource "aws_security_group" "dos-mongodb-replica" {
#   name        = "dos-mongodb-replica"
#   description = "Allow MongoDB replication"
#   vpc_id      = "${aws_vpc.dos-vpc.id}"
#   tags = {
#     Name = "dos-mongodb-replica"
#   }
# }
# resource "aws_security_group_rule" "dos-mongodb-replica" {
#   type              = "ingress"
#   from_port         = 27017
#   to_port           = 27019
#   protocol          = "tcp"
#   self              = true
#   security_group_id = "${aws_security_group.dos-mongodb-replica.id}"
# }
# Redis security group
resource "aws_security_group" "dos-redis" {
  name        = "dos-redis"
  description = "Allow connection to Redis host"
  vpc_id      = "${var.vpc-id}"
  tags = {
    Name = "${var.sg-name[3]}"
  }
}
resource "aws_security_group_rule" "dos-redis-ingress" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.dos-redis.id}"
}
resource "aws_security_group_rule" "dos-redis-egress" {
  type              = "egress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.dos-redis.id}"
}

resource "aws_security_group" "dos-metrics-connect" {
  name        = "dos-metrics-connect"
  description = "Allow Node Exporter metrics exchange"
  vpc_id      = "${var.vpc-id}"
  tags = {
    Name = "${var.sg-name[4]}"
  }
}
resource "aws_security_group_rule" "dos-metrics-ingress" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  # self              = true
  security_group_id = "${aws_security_group.dos-metrics-connect.id}"
}
resource "aws_security_group_rule" "dos-metrics-egress" {
  type              = "egress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  # self              = true
  security_group_id = "${aws_security_group.dos-metrics-connect.id}"
}

resource "aws_security_group" "dos-monitoring-access" {
  name        = "dos-monitoring-access"
  description = "Allows Grafana and Prometheus to work properly on monitoring machine"
  vpc_id      = "${var.vpc-id}"

  # Makes Prometheus closed to outher connections
  # ingress {
  #   from_port   = 9090
  #   to_port     = 9090
  #   protocol    = "tcp"
  #   # cidr_blocks = ["${var.my_IP}"]
  # }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # cidr_blocks = ["${var.my_IP}"]
  }
  egress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    # cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.sg-name[5]}"
  }
}

# CREATE KEY PAIR
resource "aws_key_pair" "dos-key" {
  key_name   = "${var.key-name}"
  public_key = "${var.pub-key}"
}
