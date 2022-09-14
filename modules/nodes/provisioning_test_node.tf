############################
# instead of running this inside aws_instance, run it outside with null resource
# ensure we can get to the node first
resource "null_resource" "remote-config-test" {
  count = var.test-node-count
  provisioner "remote-exec" {
        inline = ["sudo apt update > /dev/null"]

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file(var.ssh_key_path)
            host = element(aws_eip.test_node_eip.*.public_ip, count.index)
        }
    }
  depends_on = [aws_instance.test_node, 
                aws_eip_association.test_eip_assoc, 
                null_resource.inventory_setup_test, 
                null_resource.ssh-setup-test]
}
  # depends_on = [aws_instance.re_cluster_instance, 
  #               aws_eip_association.re-eip-assoc, 
  #               null_resource.inventory-setup, 
  #               null_resource.ssh-setup, 
  #               aws_instance.test_node, 
  #               aws_eip_association.test_eip_assoc, 
  #               null_resource.inventory_setup_test, 
  #               null_resource.ssh-setup-test,
  #               null_resource.ansible-run]


#######################
# Template Data
data "template_file" "ansible_test_inventory" {
  count    = var.test-node-count
  template = "${file("${path.module}/inventory.tpl")}"
  vars = {
    host_ip  = element(aws_eip.test_node_eip.*.public_ip, count.index)
    vpc_name = format("%s-%s-cluster-vpc", var.base_name, var.region)
    ncount   = count.index
  }
  depends_on = [aws_instance.test_node, aws_eip_association.test_eip_assoc]
}

data "template_file" "ssh_config_test" {
  template = "${file("${path.module}/ssh.tpl")}"
  vars = {
    vpc_name = format("%s-%s-cluster-vpc", var.base_name, var.region)
  }
  depends_on = [aws_instance.test_node, aws_eip_association.test_eip_assoc]
}

###############################################################################
# Template Write
resource "null_resource" "inventory_setup_test" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "echo \"${element(data.template_file.ansible_test_inventory.*.rendered, count.index)}\" > /tmp/${format("%s-%s-cluster-vpc", var.base_name, var.region)}_test_node_${count.index}.ini"
  }
  depends_on = [data.template_file.ansible_test_inventory]
}

resource "null_resource" "ssh-setup-test" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ssh_config_test.rendered}\" > /tmp/${format("%s-%s-cluster-vpc", var.base_name, var.region)}_test_node.cfg"
  }
  depends_on = [data.template_file.ssh_config_test]
}

######################
# Run some ansible
resource "null_resource" "ansible_test_run" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/testnode.yaml --private-key ${var.ssh_key_path} -i /tmp/${format("%s-%s-cluster-vpc", var.base_name, var.region)}_test_node_${count.index}.ini --become -e 'ENABLE_VOLUMES=${var.enable-volumes}'"
    #command = "ansible-playbook -i $inventory_file ${path.module}/ansible/testnode.yaml --private-key ${var.ssh_key_path} -e @$extra_vars -e @$group_vars"
  }
  depends_on = [null_resource.remote-config-test]
}



