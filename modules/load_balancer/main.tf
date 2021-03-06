resource "aws_elb" "mastercardelb" {
  name               = var.lb_attribute["name"]
  

  listener {
    instance_port     = var.lb_attribute["instance_port"]
    instance_protocol = var.lb_attribute["instance_protocol"]
    lb_port           = var.lb_attribute["lb_port"]
    lb_protocol       = var.lb_attribute["lb_protocol"]
  }

  health_check {
    healthy_threshold   = var.lb_attribute["healthy_threshold"]
    unhealthy_threshold = var.lb_attribute["unhealthy_threshold"]
    timeout             = var.lb_attribute["timeout"]
    target              = var.lb_attribute["target"]
    interval            = var.lb_attribute["interval"]
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  subnets = var.lb_subnets
  security_groups = var.lb_securitygroups

  tags = map("Name", "${var.lb_attribute["name"]}")
    
  
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = var.asgname
  elb                    = aws_elb.mastercardelb.id
}