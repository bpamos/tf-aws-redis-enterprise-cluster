#### Outputs

### tester node
output "test-node-eips" {
  value = aws_eip.test_node_eip[*].public_ip
}
