resource "aws_launch_template" "cart_lt" {
  name                   = "cart_service_lt"
  image_id               = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key}"
  vpc_security_group_ids = ["${var.id-sg-redis}", "${var.id-sg-backend}", "${var.id-sg-private}", "${var.id-sg-mongodb}"]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.s3_profile.name}"
  }
  user_data = "${base64encode(data.template_file.backend_cart_template.rendered)}"

  disable_api_termination = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Cart-app"
    }
  }
  tags = {
    Name = "cart_lt"
  }
}

resource "aws_autoscaling_group" "cart-asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = ["${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  launch_template {
    id      = "${aws_launch_template.cart_lt.id}"
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cart-asg-policy" {
  name                   = "cart-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.cart-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cart-asg-alarm" {
  alarm_name          = "cart-asg-cw-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.cart-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.cart-asg-policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cart-asg-alarm-min" {
  alarm_name          = "cart-asg-cw-alarm-min"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.cart-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.cart-asg-policy.arn}"]
}

##############################################################################

resource "aws_launch_template" "navigation_lt" {
  name                   = "navigation_service_lt"
  image_id               = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key}"
  vpc_security_group_ids = ["${var.id-sg-redis}", "${var.id-sg-backend}", "${var.id-sg-private}", "${var.id-sg-mongodb}"]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.s3_profile.name}"
  }
  user_data = "${base64encode(data.template_file.backend_navigation_template.rendered)}"

  disable_api_termination = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Navigation-app"
    }
  }
  tags = {
    Name = "navigation_lt"
  }
}

resource "aws_autoscaling_group" "navigation-asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = ["${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  launch_template {
    id      = "${aws_launch_template.navigation_lt.id}"
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "navigation-asg-policy" {
  name                   = "navigation-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.navigation-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "navigation-asg-alarm" {
  alarm_name          = "navigation-asg-cw-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.navigation-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.navigation-asg-policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "navigation-asg-alarm-min" {
  alarm_name          = "navigation-asg-cw-alarm-min"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.navigation-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.navigation-asg-policy.arn}"]
}


####################################################################################

resource "aws_launch_template" "product_lt" {
  name                   = "product_service_lt"
  image_id               = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key}"
  vpc_security_group_ids = ["${var.id-sg-redis}", "${var.id-sg-backend}", "${var.id-sg-private}", "${var.id-sg-mongodb}"]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.s3_profile.name}"
  }
  user_data = "${base64encode(data.template_file.backend_product_template.rendered)}"

  disable_api_termination = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Product-app"
    }
  }
  tags = {
    Name = "product_lt"
  }
}

resource "aws_autoscaling_group" "product-asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = ["${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  launch_template {
    id      = "${aws_launch_template.product_lt.id}"
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "product-asg-policy" {
  name                   = "product-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.product-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "product-asg-alarm" {
  alarm_name          = "product-asg-cw-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.product-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.product-asg-policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "product-asg-alarm-min" {
  alarm_name          = "product-asg-cw-alarm-min"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.product-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.product-asg-policy.arn}"]
}

######################################################################################################

resource "aws_launch_template" "tomcat_lt" {
  name                   = "tomcat_service_lt"
  image_id               = "${var.image_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key}"
  vpc_security_group_ids = ["${var.id-sg-redis}", "${var.id-sg-backend}", "${var.id-sg-private}", "${var.id-sg-mongodb}"]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.s3_profile.name}"
  }
  user_data = "${base64encode(data.template_file.backend_tomcat_template.rendered)}"

  disable_api_termination = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Tomcat monolithic"
    }
  }
  tags = {
    Name = "Tomcat lt"
  }
}

resource "aws_autoscaling_group" "tomcat-asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = ["${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  launch_template {
    id      = "${aws_launch_template.tomcat_lt.id}"
    version = "$Latest"
  }
}

