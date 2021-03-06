
variable "sg_attributes" {
  description = "security group variables for the environment"
  type        = any
}
variable "vpc_id" {
  type    = string
  default = ""
}