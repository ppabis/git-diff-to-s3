resource "aws_security_group" "ECS_TaskSG" {
  vpc_id = aws_vpc.ECS_ClusterVpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Endpoints_SG" {
  vpc_id = aws_vpc.ECS_ClusterVpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ECS_ClusterVpc.cidr_block]
  }
}
