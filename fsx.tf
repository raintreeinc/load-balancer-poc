resource "aws_fsx_windows_file_system" "this" {
  active_directory_id = data.aws_directory_service_directory.this.id
  kms_key_id          = data.aws_kms_key.this.arn
  storage_capacity    = 32
  subnet_ids          = ["${element(tolist(data.aws_subnet_ids.data-subnets-private.ids), 0)}"]
  throughput_capacity = 1024
  security_group_ids  = [data.aws_security_group.data-inbound.id, data.aws_security_group.data-outbound.id]
}