resource "aws_iam_role" "monitoring-role" {
  name = "monitoring-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "monitoring-role"
  }
}

resource "aws_iam_instance_profile" "monitoring-profile" {
  name = "monitoring-profile"
  role = "${aws_iam_role.monitoring-role.name}"
}

resource "aws_iam_role_policy" "discovery_policy" {
  name = "discovery_policy"
  role = "${aws_iam_role.monitoring-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}