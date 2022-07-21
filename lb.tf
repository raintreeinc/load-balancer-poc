resource "aws_lb" "this" {
  name                        = "NLB-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  internal                    = false
  load_balancer_type          = "network"
  subnets                     = data.aws_subnet_ids.app-subnets-public.ids
  enable_deletion_protection  = false
}

resource "aws_lb_target_group" "this" {
  name      = "TG-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  port      = 10021
  protocol  = "TCP"
  vpc_id    = data.aws_vpc.this.id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn   = aws_lb.this.arn
  port                = "10021"
  protocol            = "TCP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.this.arn
  }
}
