# Resource: aws_eip (provides an elastic IP resource)
# EIPs will be used as the IP addresses in your DNS 
# and attached as the public IP address to each Redis Cluster EC2.

resource "aws_eip" "re_cluster_instance_eip" {
  count = var.data-node-count
  network_border_group = var.region
  vpc      = true

  tags = {
      Name = format("%s-%s-eip-%s", var.base_name, var.region, count.index),
      Owner = var.owner
  }

}
