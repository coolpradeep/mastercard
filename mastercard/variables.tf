variable "vpc_attributes" {
  description = "Should be added when creating vpc, contains all the attributes for creating VPC "
  type        = map(string)
  default = {
    create_vpc                     = false
    vpc_name                       = "default"
    vpc_cidr                       = "0.0.0.0/0" # The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
    instance_tenancy               = "default"   # A tenancy option for instances launched into the VPC
    enable_ipv6                    = false       # Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block.
    enable_dns_support             = false       # Should be true to enable DNS support in the Default VPC
    enable_dns_hostnames           = false       # Should be true to enable DNS hostnames in the VPC
    enable_classiclink             = false       # Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic.
    enable_classiclink_dns_support = false       # Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic.
  }
  /*validation {
    condition     =              # Specify the condition for validation     
    error_message =              # Error message to be displayed when condition turns flase
  }*/
}
variable "subnet_attributes" {
  description = "Should be added when creating subnet, contains all the attributes for creating subnet "
  type        = any
  default = {
    subnet_name             = ""
    vpc_id                  = ""
    public_subnet_cidr      = []
    private_subnet_cidr     = []
    azs                     = []
    map_public_ip_on_launch = false
  }
}


# variable "nacl_attributes" {
#   description = "Variable for acl rules"
#   type        = any
# }

variable "route_table_attributes" {
  description = "Variable for routes in route table"
  type        = any
}

variable "launchconfig" {
  description = "launched configuration attributes"
  type        = any
  default = {
    create_lc = false
  }
}
variable "sg_attributes" {
  description = "security group variables for the environment"
  type        = any
}
variable "asgconfig" {
  description = "autoscalling group"
  type        = any
  default = null
}
variable "vpc_zone_identifier" {
  description = "providing the vpc zone identifier"
  type        = any
  default = null
}
variable "lb_attribute" {
  type    = any
  default = ""
}
variable "lb_sg_attributes" {
  type    = any
  default = ""
}


