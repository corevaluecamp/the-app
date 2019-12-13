resource "aws_alb" "main" {
  name = "devops-school"
  subnets = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  security_groups = ["${var.id-sg-load}"]

}
##################################################################
#*---------------------ALB target group ------------------------*#
##################################################################
resource "aws_alb_target_group" "app-cart" {
  name     = "app-cart-target-group"
  port     = 18100
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/api/cart/info"
  }
}

resource "aws_alb_target_group" "app-navigation" {
  name     = "app-navigation-target-group"
  port     = 18090
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/api/navigation/info"
  }
}

resource "aws_alb_target_group" "app-product" {
  name     = "app-product-target-group"
  port     = 18080
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/api/product/info"
  }
}

resource "aws_alb_target_group" "grafana" {
  name     = "grafana-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/api/health"
  }
}

resource "aws_alb_target_group" "kibana" {
  name     = "kibana-target-group"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/status"
  }
}

resource "aws_alb_target_group" "jenkins" {
  name     = "jenkins-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/login"
  }
}

resource "aws_alb_target_group" "tomcat" {
  name     = "tomcat-target-group"
  port     = 8880
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
    path                = "/shop/version"
  }
}
##################################################################
#*--------------------- ALB listener ---------------------------*#
##################################################################
resource "aws_alb_listener" "app-cart-backend" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 18100
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.app-cart.id}"
    type             = "forward"
  }

}
resource "aws_alb_listener_rule" "app-cart-backend_rule" {
  listener_arn = "${aws_alb_listener.app-cart-backend.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app-cart.id}"

  }
  condition {
    field  = "path-pattern"
    values = ["/api/cart/*"]
  }
}

resource "aws_alb_listener" "app-navigation-backend" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 18090
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.app-navigation.id}"
    type             = "forward"
  }


}
resource "aws_alb_listener_rule" "app-navigation-backend_rule" {
  listener_arn = "${aws_alb_listener.app-navigation-backend.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app-navigation.id}"

  }
  condition {
    field  = "path-pattern"
    values = ["/api/navigation/*"]
  }
}

resource "aws_alb_listener" "app-product-backend" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 18080
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.app-product.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "app-product-backend_rule" {
  listener_arn = "${aws_alb_listener.app-product-backend.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.app-product.id}"

  }
  condition {
    field  = "path-pattern"
    values = ["/api/product/*"]
  }
}


resource "aws_alb_listener" "grafana_listener" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 3000
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.grafana.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "kibana_listener" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 5601
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.kibana.id}"
    type             = "forward"
  }
}
resource "aws_alb_listener" "jenkins_listener" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 8080
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.jenkins.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "tomcat_listener" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.tomcat.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "tomcat_rule" {
  listener_arn = "${aws_alb_listener.tomcat_listener.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.tomcat.id}"

  }
  condition {
    field  = "path-pattern"
    values = ["/shop/*"]
  }
}


##################################################################
#*---------------------ALB attachment---------------------------*#
##################################################################

resource "aws_autoscaling_attachment" "app-cart-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.app-cart.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.cart-asg.id}"
}

resource "aws_autoscaling_attachment" "app-navigation-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.app-navigation.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.navigation-asg.id}"
}

resource "aws_autoscaling_attachment" "app-product-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.app-product.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.product-asg.id}"
}

resource "aws_autoscaling_attachment" "jenkins-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.jenkins.arn}"
  autoscaling_group_name = "${var.jenkins_asg_id}"
}

resource "aws_autoscaling_attachment" "tomcat-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.tomcat.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.tomcat-asg.id}"
}
#Instance Attachment
resource "aws_alb_target_group_attachment" "grafana_attachment" {
  target_group_arn = "${aws_alb_target_group.grafana.arn}"
  target_id        = "${var.grafana_id}"
  port             = 3000
}

resource "aws_alb_target_group_attachment" "kibana_attachment" {
  target_group_arn = "${aws_alb_target_group.kibana.arn}"
  target_id        = "${var.kibana_id}"
  port             = 5601
}

