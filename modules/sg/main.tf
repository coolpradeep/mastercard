resource "aws_security_group" "sg" {
  count       = length(var.sg_attributes) > 0 ? 1 : 0
  name        = "${lookup(var.sg_attributes, "sg_name", "default")}"
  description = var.sg_attributes["description"]
  vpc_id      = var.vpc_id

  tags = map("Name" , "${lookup(var.sg_attributes, "sg_name", "default")}")
   
}

resource "aws_security_group_rule" "sg_rule" {
  count                    = length(var.sg_attributes["sg_rules"])
  type                     = lookup(var.sg_attributes["sg_rules"][count.index], "type", null)
  from_port                = lookup(var.sg_attributes["sg_rules"][count.index], "from_port", null)
  to_port                  = lookup(var.sg_attributes["sg_rules"][count.index], "to_port", null)
  protocol                 = lookup(var.sg_attributes["sg_rules"][count.index], "protocol", null)
  cidr_blocks              = lookup(var.sg_attributes["sg_rules"][count.index], "cidr_blocks", null)
  source_security_group_id = lookup(var.sg_attributes["sg_rules"][count.index], "source_sg_id", null)
  security_group_id        = concat(aws_security_group.sg.*.id, [""])[0]
}     