resource "aws_autoscaling_group" "app" {
  name                  = "ASG-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}-APP"
  vpc_zone_identifier   = data.aws_subnet_ids.app-subnets-public.ids
  desired_capacity      = 2
  max_size              = 2
  min_size              = 2
  target_group_arns     = [aws_lb_target_group.this.arn]
  launch_template {
    id                  = data.aws_launch_template.app.id
    version             = "$Latest"
  }
  instance_refresh {
    strategy            = "Rolling"
  }
}

resource "aws_autoscaling_group" "db" {
  name                  = "ASG-${upper(local.local_data.tag_prefix)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}-DB"
  vpc_zone_identifier   = data.aws_subnet_ids.data-subnets-private.ids
  desired_capacity      = 2
  max_size              = 2
  min_size              = 2
  launch_template {
    id                  = data.aws_launch_template.db.id
    version             = "$Latest"
  }
  instance_refresh {
    strategy            = "Rolling"
  }
}

resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name  = aws_autoscaling_group.app.id
  alb_target_group_arn    = aws_lb_target_group.this.arn
}