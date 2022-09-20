
######################
# Run some ansible
resource "null_resource" "ansible-run2" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook -i ${path.module}/inventories/test-inventory.ini ${path.module}/redislabs-create-cluster.yaml --private-key ${var.ssh_key_path} -e @${path.module}/extra_vars/test-inventory.yaml -e @${path.module}/group_vars/all/main.yaml" 
    }
    depends_on = [local_file.inventory, time_sleep.wait_30_seconds, local_file.extra_vars]
}

#local_file.extra_vars