
# Generate inventory file

# resource "local_file" "inventory" {
#     filename = "${path.module}/inventories/test-inventory.ini"
#     content = <<EOF
#     ${var.node_1_public_dns} internal_ip=${var.node_1_private_ip} external_ip=${var.node_1_external_ip}
#     ${var.node_2_public_dns} internal_ip=${var.node_2_private_ip} external_ip=${var.node_2_external_ip}
#     ${var.node_3_public_dns} internal_ip=${var.node_3_private_ip} external_ip=${var.node_3_external_ip}
# EOF
# }
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}


resource "local_file" "inventory" {
  filename = "${path.module}/inventories/test-inventory.ini"
  content = <<-EOT
    %{ for ip in var.re-data-node-info ~}
    ${ip}
    %{ endfor ~}
  EOT
}

# Generate extra vars yaml file
resource "local_file" "extra_vars" {
    filename = "${path.module}/extra_vars/test-inventory.yaml"
    content = <<EOF
    ansible_user: ubuntu
    cluster_name: ${var.dns_fqdn}
    username: ${var.re_cluster_username}
    password: ${var.re_cluster_password}
    email_from: admin@domain.tld
    smtp_host: smtp.domain.tld
EOF
}

# data "template_file" "ssh_config" {
#   template = "${file("${path.module}/extra_vars/inventory.tpl")}"
#   vars = {
#     dns_fqdn= var.dns_fqdn
#     re_cluster_username= var.re_cluster_username
#     re_cluster_password= var.re_cluster_password
#   }
#   #depends_on = []
# }

# # Template Write
# resource "null_resource" "extra_vars" {
#   provisioner "local-exec" {
#     command = "echo \"${data.template_file.ssh_config.rendered}\" > ${path.module}/extra_vars/test-inventory.yaml"
#   }
#   depends_on = [data.template_file.ssh_config]
# }