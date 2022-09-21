

output "test-node-eips" {
  value = aws_eip.test_node_eip[*].public_ip
}

output "test-node-internal-ips" {
  value = aws_instance.test_node[*].private_ip
}

