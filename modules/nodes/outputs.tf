
# locals {
#     fqdn = format("%s-%s.${data.aws_route53_zone.selected.name}", var.base_name, var.region)
# }

# output "RedisEnterpriseClusterFQDN" {
#     value = "https://${local.fqdn}:8443/"
# }

# output "RedisEnterpriseClusterUsername" {
#     value = "${var.re_cluster_username}"
# }

# output "RedisEnterpriseClusterPassword" {
#     value = "${var.re_cluster_password}"
# }

# output "subnet_cidr_blocks_ids" {
#     value = [aws_subnet.re_subnet1.id, aws_subnet.re_subnet2.id, aws_subnet.re_subnet3.id]
# }


output "re-data-node-eips" {
  value = aws_eip.re_cluster_instance_eip[*].public_ip
}

output "re-data-node-internal-ips" {
  value = aws_instance.re_cluster_instance[*].private_ip
}

output "re-data-node-public-dns" {
  value = aws_instance.re_cluster_instance[*].public_dns
}

# output "test-node-eips" {
#   value = aws_eip.test_node_eip[*].public_ip
# }

# output "test-node-internal-ips" {
#   value = aws_instance.test_node[*].private_ip
# }


# output "testFile" {
#   value = file(var.ssh_key_path)
# }
