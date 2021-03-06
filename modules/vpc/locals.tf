locals {
  vpc_id = var.vpc_attributes["create_vpc"] ? concat(aws_vpc.vpc.*.id, [""])[0] : var.subnet_attributes["vpc_id"]
}