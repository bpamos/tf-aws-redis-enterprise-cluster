#### Outputs

output "grafana_url" {
  value = format("http://%s:3000", var.aws_eips[0])
}