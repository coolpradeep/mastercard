resource "aws_launch_configuration" "this" {
  count = var.launchconfig["create_lc"] ? 1 : 0

  name_prefix                 = var.launchconfig["lc_name"]
  image_id                    = var.launchconfig["image_id"]
  instance_type               = var.launchconfig["instance_type"]
  iam_instance_profile        = lookup(var.launchconfig, "iam_instance_profile", null)
  key_name                    = var.launchconfig["key_name"]
  security_groups             = var.lc_security_group
  associate_public_ip_address = var.launchconfig["associate_public_ip_address"]
  user_data                   = var.lc_user_data
  enable_monitoring           = var.launchconfig["enable_monitoring"]


  dynamic "ebs_block_device" {
    for_each = lookup(var.launchconfig,"ebs_block_device", [])
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      no_device             = lookup(ebs_block_device.value, "no_device", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }


  dynamic "root_block_device" {
    for_each = lookup(var.launchconfig,"root_block_device",[])
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "masterasg" {
  name                      = var.asgconfig["name"]
  max_size                  = var.asgconfig["max_size"]
  min_size                  = var.asgconfig["min_size"]
  health_check_grace_period = var.asgconfig["health_check_grace_period"]
  health_check_type         = var.asgconfig["health_check_type"]
  desired_capacity          = var.asgconfig["desired_capacity"]
  launch_configuration      = aws_launch_configuration.this.*.name[0]
  vpc_zone_identifier       = var.vpc_zone_identifier



  timeouts {
    delete = "15m"
  }
}

