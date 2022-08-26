# Security Group
# Security Group is for the EC2s.
# TODO: Lock it down!

resource "aws_security_group" "re_sg" {
  name        = format("%s-re-sg1", var.base_name)
  description = "Redis Enterprise Security Group"
  vpc_id      = aws_vpc.redis_cluster_vpc.id

  tags = {
    Name = format("%s-%s-cluster-sg", var.base_name, var.region),
    Owner = var.owner
  }

  ingress {
    protocol = "tcp"
    from_port = 36379
    to_port = 36379
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 36380
    to_port = 36380
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 3333
    to_port = 3337
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    # cidr_block ["0.0.0.0/0"] This means all ip address are allowed to ssh
    # do not do in production.
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 9443
    to_port = 9443
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 10000
    to_port = 19999
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "udp"
    from_port = 53
    to_port = 53
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "udp"
    from_port = 5353
    to_port = 5353
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    protocol = "tcp"
    from_port = 20000
    to_port = 29999
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}