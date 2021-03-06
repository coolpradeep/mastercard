# Add all variables related to creation of resource vpc inside this block
vpc_attributes = {
  create_vpc                     = true           # Set true to create vpc, add attributes in variable vpc_attributes 
  vpc_name                       = "masterVpc"      # Name of the VPC
  vpc_cidr                       = "20.10.0.0/16" # The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
  instance_tenancy               = "default"      # A tenancy option for instances launched into the VPC
  enable_ipv6                    = false          # Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block.
  enable_dns_support             = true           # Should be true to enable DNS support in the Default VPC
  enable_dns_hostnames           = true           # Should be true to enable DNS hostnames in the VPC
  enable_classiclink             = false          # Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic.
  enable_classiclink_dns_support = false          # Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic.

}

# Add all variables related to creation of resource subnet inside this block
subnet_attributes = {
  subnet_name           = "master-subnet"                                    # Name for the subnets
  vpc_id                = "30.10.11.0/24"                                     # Input Required if vpc is not created using create vpc attribute in vpc_attributes else give a default value
  public_subnet_cidr    = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"] # The cidr for all the public subnets required, if no public subnets put [] as the value
  private_subnet_cidr   = ["20.10.14.0/24", "20.10.15.0/24", "20.10.16.0/24"] # The cidr for all the private subnets required, if no private subnets put [] as the value
  azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]          # The azs in which subnets has to be created
  public_route_name = "public-route"
  private_route_name ="private-route"
  igw_name = "master-igw"
  nat_eip_name = "master-nat-eip"
  nat_gw_name = "master-nat"
}

# Add all routes to route tables here
route_table_attributes = {

  public_routes = [] # if not required put [], Add destination_cidr_block and instance_id if required to add routes

  private_routes = [] # if not required put [], Add destination_cidr_block and instance_id if required to add routes

}

launchconfig= {
  create_lc                   = true
  lc_name                     = "master-card-lc"
  image_id                    = "ami-0915bcb5fa77e4892"
  instance_type               = "t2.micro"
  key_name                    = "pradeep"
  associate_public_ip_address = false
  enable_monitoring           = false
  


}
sg_attributes ={
  sg_name         = "master_sg"
  description   = "this security group is for master card"
  sg_rules = [{
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
      {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

asgconfig = {
  name                      = "master_asg"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  }

lb_attribute = {
  name  = "master-elb"
  instance_port     = 80
  instance_protocol = "http"
  lb_port           = 80
  lb_protocol       = "http"
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout             = 3
  target              = "HTTP:80/"
  interval            = 30

  }
lb_sg_attributes ={
  sg_name         = "masterlb_sg"
  description   = "this security group is for elb"
  sg_rules = [{
    type        = "ingress"
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ]
}

