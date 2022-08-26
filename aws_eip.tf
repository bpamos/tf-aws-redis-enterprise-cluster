# Resource: aws_eip (provides an elastic IP resource)
# EIPs will be used as the IP addresses in your DNS 
# and attached as the public IP address to each Redis Cluster EC2.

# resource "aws_eip" "rs_cluster_instance_1" {
#   network_border_group = var.region
#   vpc      = false

#   tags = {
#       Name = format("%s-%s-eip1", var.base_name, var.region),
#       Owner = var.owner
#   }

# }
