#### Generate ansible inventory file & extra_vars file, run ansible playbook to create databases



##### Generate ansible inventory.ini for any number of nodes
resource "local_file" "dynamic_inventory_ini" {
    content  = templatefile("${path.module}/inventories/inventory.tpl", {
      re_master_node = var.re_databases_create ? var.re_master_node : ""
    })
    filename = "${path.module}/inventories/inventory.ini"
}



##### Generate extra_vars.yaml file
resource "local_file" "extra_vars" {
    content  = templatefile("${path.module}/extra_vars/databases.yaml.tpl", {
      ansible_user        = "ubuntu"
      re_cluster_username = var.re_cluster_username
      re_cluster_password = var.re_cluster_password
      re_databases_create  = var.re_databases_create
      re_databases_json_file  = var.re_databases_json_file

    })
    filename = "${path.module}/extra_vars/databases.yaml"
}

######################
# Run ansible-playbook to create cluster
resource "null_resource" "ansible-run" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook ${path.module}/create-databases.yaml --private-key ${var.ssh_key_path} -i ${path.module}/inventories/inventory.ini -e @${path.module}/extra_vars/databases.yaml" 
    }
    depends_on = [local_file.dynamic_inventory_ini, 
                  local_file.extra_vars]
}