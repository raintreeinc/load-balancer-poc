resource "aws_lb" "client" {
  name                        = "NLB-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  internal                    = false
  load_balancer_type          = "network"
  subnets                     = data.aws_subnet_ids.app-subnets-public.ids
  enable_deletion_protection  = false
}

resource "aws_lb" "web" {
  name                        = "ALB-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = data.aws_subnet_ids.app-subnets-public.ids
  enable_deletion_protection  = false
  security_groups             = [data.aws_security_group.web-inbound.id]
}

resource "aws_lb_target_group" "primary" {
  name      = "10021-TG-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  port      = 10021
  protocol  = "TCP"
  vpc_id    = data.aws_vpc.this.id
  stickiness {
    type      = "source_ip"
    enabled   = true
  }
}

resource "aws_lb_target_group" "secondary" {
  name      = "10022-TG-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  port      = 10022
  protocol  = "TCP"
  vpc_id    = data.aws_vpc.this.id
  stickiness {
    type      = "source_ip"
    enabled   = true
  }
}

resource "aws_lb_target_group" "https" {
  name              = "443-TG-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}-HTTPS"
  port              = 443
  protocol          = "HTTPS"
  vpc_id            = data.aws_vpc.this.id
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 604800
    enabled         = true
  }
}

resource "aws_lb_listener" "primary" {
  load_balancer_arn   = aws_lb.client.arn
  port                = "10021"
  protocol            = "TCP"
  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.primary.arn
  }
}

resource "aws_lb_listener" "secondary" {
  load_balancer_arn   = aws_lb.client.arn
  port                = "10022"
  protocol            = "TCP"
  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.secondary.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn   = aws_lb.web.arn
  port                = "443"
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  certificate_arn     = data.aws_acm_certificate.this.arn
  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.https.arn
  }
}

# resource "aws_lb_listener_rule" "primary" {
#   listener_arn = aws_lb_listener.primary.arn
#   action {
#     type = "forward"
#     forward {
#       target_group {
#         arn    = aws_lb_target_group.primary.arn
#       }
#       target_group {
#         arn    = aws_lb_target_group.secondary.arn
#       }
#       stickiness {
#         enabled  = true
#         duration = 604800
#       }
#     }
#   }
#   condition {
#     host_header {
#       values = ["rt-test.dev.raintreeinc.com"]
#     }
#   }
# }