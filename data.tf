data "aws_launch_template" "app" {
  name = "lt-${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-win-2019"
}

data "aws_launch_template" "db" {
  name = "lt-${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-win-2019-mysql"
}

data "aws_vpc" "this" {
  tags = {
    Purpose = "Application"
  }
}

data "aws_vpc" "db" {
  tags = {
    Purpose = "Data"
  }
}

data "aws_subnet_ids" "app-subnets-public" {
  vpc_id                  = data.aws_vpc.this.id
  tags = {
    Tier = "Public"
  }
}

data "aws_subnet_ids" "data-subnets-private" {
  vpc_id                  = data.aws_vpc.db.id
  tags = {
    Tier = "Private"
  }
}

data "aws_directory_service_directory" "this" {
  directory_id = "${lower(local.local_data.aws_directory_id)}"
}

data "aws_kms_key" "this" {
  key_id = "alias/${lower(local.local_data.aws_region_code)}-kms-${lower(local.local_data.tag_env)}-${lower(local.local_data.aws_team)}"
}

data "aws_security_group" "data-inbound" {
  name    = "${lower(local.local_data.aws_region_code)}-sg-${lower(local.local_data.tag_env)}-data-fsx"
}

data "aws_security_group" "data-outbound" {
  name    = "${lower(local.local_data.aws_region_code)}-sg-${lower(local.local_data.tag_env)}-db-outbound"
}