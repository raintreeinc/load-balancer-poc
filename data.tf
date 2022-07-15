data "aws_launch_template" "this" {
  name = "lt-${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-win-standalone"
}

data "aws_vpc" "this" {
  tags = {
    Purpose = "Application"
  }
}

data "aws_subnet_ids" "app-subnets-public" {
  vpc_id                  = data.aws_vpc.this.id
  tags = {
    Tier = "Public"
  }
}