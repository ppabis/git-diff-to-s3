output "vpc_id" {
  value = aws_vpc.ECS_ClusterVpc.id
}

output "vpc_cidr" {
  value = aws_vpc.ECS_ClusterVpc.cidr_block
}

output "subnet_id" {
  value = aws_subnet.Subnet.id
}

output "security_group" {
  value = aws_security_group.ECS_TaskSG.id
}
