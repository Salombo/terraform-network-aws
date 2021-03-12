resource "aws_vpc" "epsi-tf" {
    cidr_block = var.main_network
}

locals {
//[*] -> tous les éléments du tableau ...-> lister tous les éléments
  addrs_by_idx  = cidrsubnets(var.main_network, var.networks[*].net_bits...)
  addrs_by_name = { for i, n in var.networks : n.name => local.addrs_by_idx[i] if n.name != null }
  network_objs = [for i, n in var.networks : {
    name                = n.name
    net_bits            = n.net_bits
    cidr_block          = local.addrs_by_idx[i]
    availability_zone   = n.availability_zone
    public              = n.public
  }]
  
  publicArray = [
    for i, subnet in var.networks:
      i
      if subnet.public == "yes"
  ]
}

resource "aws_subnet" "subnets" {
  count = length(local.network_objs)

  vpc_id            = aws_vpc.epsi-tf.id
  availability_zone = local.network_objs[count.index].availability_zone
  cidr_block        = local.network_objs[count.index].cidr_block
  
  tags = {
      Name      = local.network_objs[count.index].name
      Public    = local.network_objs[count.index].public
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.epsi-tf.id

  tags = {
    Name = "Main-GW"
  }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.epsi-tf.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "public-tf"
    }
}

resource "aws_route_table_association" "routes" {
    count = length(local.publicArray)
    subnet_id = aws_subnet.subnets[local.publicArray[count.index]].id
    route_table_id = aws_route_table.public.id
}