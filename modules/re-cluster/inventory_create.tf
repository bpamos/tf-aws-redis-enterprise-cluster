
# Generate inventory file

#### Sleeper, just to make sure nodes module is complete and everything is installed
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

#### SSH config
# data "template_file" "ssh_config" {
#   template = "${file("${path.module}/ssh.tpl")}"
#   vars = {
#     vpc_name = "ansible"
#   }
#   depends_on = [time_sleep.wait_30_seconds]
# }

# resource "null_resource" "ssh-setup" {
#   provisioner "local-exec" {
#     command = "echo \"${data.template_file.ssh_config.rendered}\" > /tmp/ansible_node.cfg"
#   }
#   depends_on = [data.template_file.ssh_config]
# }

locals {
  dynamic_inventory_ini = templatefile("${path.module}/inventories/test-inventory.tpl",
  {
    re-data-node-info = var.re-data-node-info
  })
}

# Template Write
resource "null_resource" "dynamic_inventory_ini" {
  provisioner "local-exec" {
    command = "echo \"${local.dynamic_inventory_ini}\" > ${path.module}/inventories/test-inventory.ini"
  }
  depends_on = [local.dynamic_inventory_ini]
}

##### extra_vars template and file
locals {
  extra_vars = templatefile("${path.module}/extra_vars/inventory.yaml.tpl",
  {
    ansible_user = "ubuntu"
    dns_fqdn= var.dns_fqdn
    re_cluster_username= var.re_cluster_username
    re_cluster_password= var.re_cluster_password
    re_email_from = "admin@domain.tld"
    re_smtp_host = "smtp.domain.tld"
  })
}

# Template Write
resource "null_resource" "extra_vars" {
  provisioner "local-exec" {
    command = "echo \"${local.extra_vars}\" > ${path.module}/extra_vars/test-inventory.yaml"
  }
  depends_on = [local.extra_vars]
}

##################

##### extra_vars files
# data "template_file" "extra_vars" {
#   template = "${file("${path.module}/extra_vars/inventory.yaml.tpl")}"
#   vars = {
#     ansible_user = "ubuntu"
#     dns_fqdn= var.dns_fqdn
#     re_cluster_username= var.re_cluster_username
#     re_cluster_password= var.re_cluster_password
#     re_email_from = "admin@domain.tld"
#     re_smtp_host = "smtp.domain.tld"
#   }
# }

# # Template Write
# resource "null_resource" "extra_vars" {
#   provisioner "local-exec" {
#     command = "echo \"${data.template_file.extra_vars.rendered}\" > ${path.module}/extra_vars/test-inventory.yaml"
#   }
#   depends_on = [data.template_file.extra_vars]
# }



######################
# Run some ansible
resource "null_resource" "ansible-run" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook ${path.module}/redislabs-create-cluster.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/test-inventory.ini -e @${path.module}/extra_vars/test-inventory.yaml -e @${path.module}/group_vars/all/main.yaml" 
    #command = "ansible-playbook ${path.module}/redislabs-create-cluster.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/test-inventory.ini -e @${path.module}/extra_vars/test-inventory.yaml -e @${path.module}/group_vars/all/main.yaml" 
    }
    depends_on = [null_resource.dynamic_inventory_ini, 
                  time_sleep.wait_30_seconds, 
                  null_resource.extra_vars]
}