resource "aws_alb" "main" {
  name            = "app-load-balancer"
  subnets         = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}", "${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  security_groups =  ["${var.id-sg-bastion}", "${var.id-sg-backend}", "${var.id-sg-private}", "${var.id-sg-mongodb}", "${var.id-sg-jenkins}"]

}
##################################################################
#*---------------------ALB target group ------------------------*#
##################################################################

/* resource "aws_alb_target_group" "frontend" {
  name     = "frontend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
} */

resource "aws_alb_target_group" "app-cart" {
  name     = "app-cart-target-group"
  port     = 18100
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "app-navigation" {
  name     = "app-navigation-target-group"
  port     = 18090
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_target_group" "app-product" {
  name     = "app-product-target-group"
  port     = 18080
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc}"


  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}
##################################################################
#*--------------------- ALB listener ---------------------------*#
##################################################################

# Redirect all traffic from the ALB to the target group
/* resource "aws_alb_listener" "frontend" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.frontend.id}"
    type             = "forward"

  }


} */
/* resource "aws_alb_listener_rule" "frontend_rule" {
  listener_arn = "${aws_alb_listener.frontend.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.frontend.id}"
  }
  condition {
    field  = "path-pattern"
    values = ["/shop/*"]
  }
} */

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
##################################################################
#*---------------------ALB attachment---------------------------*#
##################################################################
/* resource "aws_alb_target_group_attachment" "frontend-attachment" {
  target_group_arn = "${aws_alb_target_group.frontend.arn}"
  target_id        = "${aws_instance.frontend.id}"
  port             = 80
}
 */


resource "aws_autoscaling_attachment" "app-cart-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.app-cart.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.cart-asg.id}"
}

resource "aws_autoscaling_attachment" "app-navigation-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.app-navigation.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.navigation-asg.id}"
}

resource "aws_autoscaling_attachment" "app-autoscaling-attachment" {
  alb_target_group_arn   = "${aws_alb_target_group.app-product.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.product-asg.id}"
}
