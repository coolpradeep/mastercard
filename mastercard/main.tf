module "vpc" {
  source                 = "../modules/vpc/"
  vpc_attributes         = var.vpc_attributes
  subnet_attributes      = var.subnet_attributes
  route_table_attributes = var.route_table_attributes
  
}
module "master-sg" {
  source    = "../modules/sg/"
  sg_attributes = var.sg_attributes
  vpc_id = module.vpc.vpc_id

}

module "asg" {
  source   = "../modules/asg/"
  launchconfig = var.launchconfig 
  lc_security_group = module.master-sg.security_group_id
  lc_user_data =  data.template_file.userdata.rendered
  asgconfig = var.asgconfig
  vpc_zone_identifier = module.vpc.private_subnets
}

module "elb" {
  source = "../modules/load_balancer/"
  asgname = module.asg.asg_id
  lb_attribute = var.lb_attribute
  lb_subnets = module.vpc.public_subnets
  lb_securitygroups = module.masterlb-sg.security_group_id
  
}
module "masterlb-sg" {
  source    = "../modules/sg/"
  sg_attributes = var.lb_sg_attributes
  vpc_id = module.vpc.vpc_id

}