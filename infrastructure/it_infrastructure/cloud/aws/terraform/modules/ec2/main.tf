resource "aws_instance" "this" {
  # Instance Identity
  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )

  # Computation
  ami           = var.ami_id
  user_data     = var.user_data
  instance_type = var.instance_type

  # Security  
  key_name             = var.key_name != "" ? var.key_name : null
  iam_instance_profile = var.iam_instance_profile != "" ? var.iam_instance_profile : null

  # Network
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip


  # Storage
  ebs_optimized = var.ebs_optimized

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  # Others
  monitoring = var.enable_monitoring


}