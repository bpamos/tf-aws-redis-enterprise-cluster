############################
# instead of running this inside aws_instance, run it outside with null resource
# ensure we can get to the node first
resource "null_resource" "remote-config" {
  count = var.data-node-count
  provisioner "remote-exec" {
        inline = ["sudo apt update > /dev/null"]

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file(var.ssh_key_path)
            host = element(aws_eip.re_cluster_instance_eip.*.public_ip, count.index)
        }
    }
  depends_on = [aws_instance.re_cluster_instance, aws_eip_association.re-eip-assoc, local_file.inventory_setup, local_file.ssh_setup]
}

#########
#### Generate Ansible Inventory for each node
resource "local_file" "inventory_setup" {
    count    = var.data-node-count
    content  = templatefile("${path.module}/inventory.tpl", {
        host_ip  = element(aws_eip.re_cluster_instance_eip.*.public_ip, count.index)
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_node_${count.index}.ini"
    depends_on = [aws_instance.re_cluster_instance, aws_eip_association.re-eip-assoc, aws_volume_attachment.ephemeral_re_cluster_instance]
}

#### Generate ansible.cfg file
resource "local_file" "ssh_setup" {
    content  = templatefile("${path.module}/ssh.tpl", {
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_node.cfg"
    depends_on = [aws_instance.re_cluster_instance, aws_eip_association.re-eip-assoc, aws_volume_attachment.ephemeral_re_cluster_instance]
}

######################
# Run some ansible
resource "null_resource" "ansible-run" {
  count = var.data-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbook.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_node_${count.index}.ini"
    }
  depends_on = [null_resource.remote-config]
}


