######################
# Run some ansible
resource "null_resource" "ansible-run2" {
  #count = var.data-node-count
  provisioner "local-exec" {
    #command = "ansible-playbook ${path.module}/ansible/playbook.yaml --private-key ${var.ssh_key_path} -i /tmp/${format("%s-%s-cluster-vpc", var.base_name, var.region)}_node_${count.index}.ini --become -e 'ENABLE_VOLUMES=${var.enable-volumes}'"
    #command = "ansible-playbook ${path.module}/ansible/playbook.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_node_${count.index}.ini"
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook -i ${path.module}/inventories/test-inventory2.ini ${path.module}/redislabs-create-cluster.yaml --private-key ${var.ssh_key_path} -e @${path.module}/extra_vars/test-inventory2.yaml -e @${path.module}/group_vars/all/main.yaml" 
    }
    depends_on = [local_file.inventory, local_file.extra_vars]
}


    # command = <<EOT
    # ANSIBLE_HOST_KEY_CHECKING=\"False\" 
    # ansible-playbook -i ${path.module}/inventories/test-inventory2.ini 
    # ${path.module}/redislabs-create-cluster.yaml 
    # --private-key ${var.ssh_key_path} 
    # --extra-vars='{"ansible_user": ubuntu, 
    # "cluster_name": ${var.dns_fqdn} },
    # "username": ${var.re_cluster_username},
    # "password": ${var.re_cluster_password},
    # "email_from": admin@domain.tld,
    # "smtp_host": smtp.domain.tld'
    # -e @${path.module}/group_vars/all/main.yaml
    # EOT