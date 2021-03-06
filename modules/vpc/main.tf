
# VPC resource creation block

resource "aws_vpc" "vpc" {
  count = var.vpc_attributes["create_vpc"] ? 1 : 0

  cidr_block                       = var.vpc_attributes["vpc_cidr"]
  instance_tenancy                 = var.vpc_attributes["instance_tenancy"]
  enable_dns_hostnames             = var.vpc_attributes["enable_dns_hostnames"]
  enable_dns_support               = var.vpc_attributes["enable_dns_support"]
  enable_classiclink               = var.vpc_attributes["enable_classiclink"]
  enable_classiclink_dns_support   = var.vpc_attributes["enable_classiclink_dns_support"]
  assign_generated_ipv6_cidr_block = var.vpc_attributes["enable_ipv6"]

  tags = map("Name", "${var.vpc_attributes["vpc_name"]}")
  
}

# Public Subnet resource creation block

resource "aws_subnet" "public" {
  count = length(var.subnet_attributes["public_subnet_cidr"])

  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.subnet_attributes["public_subnet_cidr"], [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.subnet_attributes["azs"], count.index))) > 0 ? element(var.subnet_attributes["azs"], count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.subnet_attributes["azs"], count.index))) == 0 ? element(var.subnet_attributes["azs"], count.index) : null
  map_public_ip_on_launch = true

  tags = map("Name", "${var.subnet_attributes["subnet_name"]}-public-${count.index}")
  
}


# Private Subnet resource creation block

resource "aws_subnet" "private" {
  count = length(var.subnet_attributes["private_subnet_cidr"])

  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.subnet_attributes["private_subnet_cidr"], [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.subnet_attributes["azs"], count.index))) > 0 ? element(var.subnet_attributes["azs"], count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.subnet_attributes["azs"], count.index))) == 0 ? element(var.subnet_attributes["azs"], count.index) : null
  map_public_ip_on_launch = false

  tags = map("Name", "${var.subnet_attributes["subnet_name"]}-private-${count.index}")
}


# Public Route Table creation block 

resource "aws_route_table" "public" {
  count = length(var.subnet_attributes["public_subnet_cidr"]) > 0 ? 1 : 0

  vpc_id = local.vpc_id

 tags = map("Name", "${var.subnet_attributes["public_route_name"]}")
}


# Private Route Table creation block 

resource "aws_route_table" "private" {
  count = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? 1 : 0

  vpc_id = local.vpc_id

   tags = map("Name", "${var.subnet_attributes["private_route_name"]}")

}


# Internet Gateway creation block 


resource "aws_internet_gateway" "igw" {
  count = length(var.subnet_attributes["public_subnet_cidr"]) > 0 ? 1 : 0

  vpc_id = local.vpc_id

   tags = map("Name", "${var.subnet_attributes["igw_name"]}")
}

# NAT Gateway creation block 

resource "aws_eip" "nat_eip" {
  count = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? 1 : 0
  vpc   = true
  tags = map("Name", "${var.subnet_attributes["nat_eip_name"]}")

}

resource "aws_nat_gateway" "nat" {
  count         = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  tags = map("Name", "${var.subnet_attributes["nat_gw_name"]}")
  depends_on = [aws_internet_gateway.igw]
}

# Routes block 

resource "aws_route" "public_internet_gateway" {
  count                  = length(var.subnet_attributes["public_subnet_cidr"]) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}


resource "aws_route" "private_nat_gateway" {
  count                  = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_route" {
  count                  = length(var.route_table_attributes["public_routes"])
  route_table_id         = aws_route_table.public[0].id
  instance_id            = lookup(var.route_table_attributes["public_routes"][count.index], "instance_id", null)
  destination_cidr_block = lookup(var.route_table_attributes["public_routes"][count.index], "destination_cidr_block", null)
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "private_route" {
  count                  = length(var.route_table_attributes["private_routes"])
  route_table_id         = aws_route_table.public[0].id
  instance_id            = lookup(var.route_table_attributes["private_routes"][count.index], "instance_id", null)
  destination_cidr_block = lookup(var.route_table_attributes["private_routes"][count.index], "destination_cidr_block", null)
  depends_on             = [aws_route_table.private]
}


resource "aws_route_table_association" "public_route_subnet" {
  count          = length(var.subnet_attributes["public_subnet_cidr"])
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private_route_subnet" {
  count          = length(var.subnet_attributes["private_subnet_cidr"])
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private[0].id
}

# NACL block public 

# resource "aws_network_acl" "public" {
#   count      = length(var.subnet_attributes["public_subnet_cidr"]) > 0 ? 1 : 0
#   vpc_id     = local.vpc_id
#   subnet_ids = aws_subnet.public.*.id

#   tags = merge(
#     var.global_variables["default_tags"],
#     map("Name", "${var.global_variables["prefix"]}public-nacl${var.global_variables["suffix"]}")
#   )

# }

# resource "aws_network_acl_rule" "public_inbound" {
#   count = length(var.subnet_attributes["public_subnet_cidr"]) > 0 ? length(var.nacl_attributes["public_inbound_acl_rules"]) : 0

#   network_acl_id = aws_network_acl.public[0].id

#   egress      = false
#   rule_number = var.nacl_attributes["public_inbound_acl_rules"][count.index]["rule_number"]
#   rule_action = var.nacl_attributes["public_inbound_acl_rules"][count.index]["rule_action"]
#   from_port   = lookup(var.nacl_attributes["public_inbound_acl_rules"][count.index], "from_port", null)
#   to_port     = lookup(var.nacl_attributes["public_inbound_acl_rules"][count.index], "to_port", null)
#   protocol    = var.nacl_attributes["public_inbound_acl_rules"][count.index]["protocol"]
#   cidr_block  = lookup(var.nacl_attributes["public_inbound_acl_rules"][count.index], "cidr_block", null)
# }

# resource "aws_network_acl_rule" "public_outbound" {
#   count = length(var.subnet_attributes["public_subnet_cidr"]) > 0 ? length(var.nacl_attributes["public_outbound_acl_rules"]) : 0

#   network_acl_id = aws_network_acl.public[0].id

#   egress      = true
#   rule_number = var.nacl_attributes["public_outbound_acl_rules"][count.index]["rule_number"]
#   rule_action = var.nacl_attributes["public_outbound_acl_rules"][count.index]["rule_action"]
#   from_port   = lookup(var.nacl_attributes["public_outbound_acl_rules"][count.index], "from_port", null)
#   to_port     = lookup(var.nacl_attributes["public_outbound_acl_rules"][count.index], "to_port", null)
#   protocol    = var.nacl_attributes["public_outbound_acl_rules"][count.index]["protocol"]
#   cidr_block  = lookup(var.nacl_attributes["public_outbound_acl_rules"][count.index], "cidr_block", null)
# }

# # NACL block Private 

# resource "aws_network_acl" "private" {
#   count      = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? 1 : 0
#   vpc_id     = local.vpc_id
#   subnet_ids = aws_subnet.private.*.id

#   tags = merge(
#     var.global_variables["default_tags"],
#     map("Name", "${var.global_variables["prefix"]}private-nacl${var.global_variables["suffix"]}")
#   )

# }

# resource "aws_network_acl_rule" "private_inbound" {
#   count = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? length(var.nacl_attributes["private_inbound_acl_rules"]) : 0

#   network_acl_id = aws_network_acl.private[0].id

#   egress      = false
#   rule_number = var.nacl_attributes["private_inbound_acl_rules"][count.index]["rule_number"]
#   rule_action = var.nacl_attributes["private_inbound_acl_rules"][count.index]["rule_action"]
#   from_port   = lookup(var.nacl_attributes["private_inbound_acl_rules"][count.index], "from_port", null)
#   to_port     = lookup(var.nacl_attributes["private_inbound_acl_rules"][count.index], "to_port", null)
#   protocol    = var.nacl_attributes["private_inbound_acl_rules"][count.index]["protocol"]
#   cidr_block  = lookup(var.nacl_attributes["private_inbound_acl_rules"][count.index], "cidr_block", null)
# }

# resource "aws_network_acl_rule" "private_outbound" {
#   count = length(var.subnet_attributes["private_subnet_cidr"]) > 0 ? length(var.nacl_attributes["private_outbound_acl_rules"]) : 0

#   network_acl_id = aws_network_acl.private[0].id

#   egress      = true
#   rule_number = var.nacl_attributes["private_outbound_acl_rules"][count.index]["rule_number"]
#   rule_action = var.nacl_attributes["private_outbound_acl_rules"][count.index]["rule_action"]
#   from_port   = lookup(var.nacl_attributes["private_outbound_acl_rules"][count.index], "from_port", null)
#   to_port     = lookup(var.nacl_attributes["private_outbound_acl_rules"][count.index], "to_port", null)
#   protocol    = var.nacl_attributes["private_outbound_acl_rules"][count.index]["protocol"]
#   cidr_block  = lookup(var.nacl_attributes["private_outbound_acl_rules"][count.index], "cidr_block", null)
# }
