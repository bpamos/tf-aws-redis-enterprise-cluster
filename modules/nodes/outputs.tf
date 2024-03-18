#### Outputs

output "node-eips" {
  value = aws_eip.instance_eip[*].public_ip
}

output "node-internal-ips" {
  value = aws_instance.instance[*].private_ip
}

output "node-eip-public-dns" {
  value = aws_eip.instance_eip[*].public_dns #ec2 public dns after EIP association
}