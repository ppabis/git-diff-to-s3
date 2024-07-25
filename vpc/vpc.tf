resource "aws_vpc" "ECS_ClusterVpc" {
  cidr_block = "10.9.0.0/16"
  tags = {
    Name = "ECS_Cluster_Vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "Subnet" {
  vpc_id     = aws_vpc.ECS_ClusterVpc.id
  cidr_block = "10.9.1.0/24"
  tags = {
    Name = "ECS_PublicSubnet"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_vpc.ECS_ClusterVpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ECS_Gateway.id
}

resource "aws_internet_gateway" "ECS_Gateway" {
  vpc_id = aws_vpc.ECS_ClusterVpc.id
}
