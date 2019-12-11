resource "aws_iam_role" "s3_deploy_frontend" {
  name = "s3_deploy_frontend"

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
    Name = "s3_deployer_frontend"
  }
}

resource "aws_iam_instance_profile" "s3_profile_frontend" {
  name = "s3_profile_frontend"
  role = "${aws_iam_role.s3_deploy.name}"
}

resource "aws_iam_role_policy" "s3_policy_frontend" {
  name = "s3_policy_frontend"
  role = "${aws_iam_role.s3_deploy.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}