
output "re-data-node-eips" {
  value = aws_eip.re_cluster_instance_eip[*].public_ip
}

output "re-data-node-internal-ips" {
  value = aws_instance.re_cluster_instance[*].private_ip
}

output "re-data-node-public-dns" {
  value = aws_instance.re_cluster_instance[*].public_dns
}

output "re-data-node-info" {
  value = formatlist("%s internal_ip=%s external_ip=%s",aws_instance.re_cluster_instance[*].public_dns, aws_instance.re_cluster_instance[*].private_ip, aws_eip.re_cluster_instance_eip[*].public_ip)
}