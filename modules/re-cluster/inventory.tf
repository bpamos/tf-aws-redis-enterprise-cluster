
# Generate inventory file

resource "local_file" "inventory" {
    filename = "${path.module}/inventories/test-inventory2.ini"
    content = <<EOF
    ${var.node_1_public_dns} internal_ip=${var.node_1_private_ip} external_ip=${var.node_1_external_ip}
    ${var.node_2_public_dns} internal_ip=${var.node_2_private_ip} external_ip=${var.node_2_external_ip}
    ${var.node_3_public_dns} internal_ip=${var.node_3_private_ip} external_ip=${var.node_3_external_ip}
EOF
}

resource "local_file" "extra_vars" {
    filename = "${path.module}/extra_vars/test-inventory2.yaml"
    content = <<EOF
    ansible_user: ubuntu
    cluster_name: ${var.dns_fqdn}
    username: ${var.re_cluster_username}
    password: ${var.re_cluster_password}
    email_from: admin@domain.tld
    smtp_host: smtp.domain.tld
EOF
}