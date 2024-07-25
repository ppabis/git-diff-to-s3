locals {
  ENDPOINTS = [
    /*     "com.amazonaws.eu-west-1.ecr.api",
    "com.amazonaws.eu-west-1.ecr.dkr",
    "com.amazonaws.eu-west-1.ecs",
    "com.amazonaws.eu-west-1.git-codecommit",
    "com.amazonaws.eu-west-1.codecommit" */
  ]
}

resource "aws_vpc_endpoint" "endpoints" {
  count               = length(local.ENDPOINTS)
  vpc_id              = aws_vpc.ECS_ClusterVpc.id
  service_name        = local.ENDPOINTS[count.index]
  security_group_ids  = [aws_security_group.Endpoints_SG.id]
  subnet_ids          = [aws_subnet.Subnet.id]
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  policy              = <<-POLICY
    {
        "Statement": [ {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*",
            "Condition": {
                "IpAddress": { "aws:SourceIp": ["${aws_vpc.ECS_ClusterVpc.cidr_block}"] }
            }
        } ]
    }
  POLICY
}
