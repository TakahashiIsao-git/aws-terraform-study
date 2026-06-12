# ----------------------------------
# ALB
# ----------------------------------

# ----------------------------------
# Application Load Balancer
# ----------------------------------

resource "aws_lb" "study_alb" {

  name = "${var.project_name}-alb"

  internal = false

  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# ----------------------------------
# Target Group
# ----------------------------------

resource "aws_lb_target_group" "study_tg" {

  name = "${var.project_name}-tg"

  vpc_id = aws_vpc.study_vpc.id

  protocol = "HTTP"

  port = 80

  health_check {

    protocol = "HTTP"

    path = "/"

    port = "traffic-port"

    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30

    matcher = "200-301"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# ----------------------------------
# Target Attachment
# ----------------------------------

resource "aws_lb_target_group_attachment" "study_tg_attach" {

  target_group_arn = aws_lb_target_group.study_tg.arn

  target_id = aws_instance.study_ec2.id

  port = 80
}

# ----------------------------------
# Listener
# ----------------------------------

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.study_alb.arn

  protocol = "HTTP"

  port = 80

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.study_tg.arn
  }
}
