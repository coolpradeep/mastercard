variable "launchconfig" {
  description = "launched configuration attributes"
  type        = any
  default = {
    create_lc = false
  }
}
variable "lc_security_group" {
  description = "launched configuration security group"
  type        = any
  default = ""
}
variable "lc_user_data" {
  description = "lc user data"
  type        = any
  default = null
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


