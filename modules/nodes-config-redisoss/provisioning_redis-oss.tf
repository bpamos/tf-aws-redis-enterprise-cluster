#### Generating Ansible config, inventory, playbook 
#### and configuring test nodes and installing Redis and Memtier


# Define a null_resource block for the retry logic
resource "null_resource" "retry" {
  count = 3

  # Retry logic to run remote-exec provisioner
  provisioner "local-exec" {
    command = "echo Retrying remote-exec provisioner attempt ${count.index + 1}"
    interpreter = ["/bin/bash", "-c"]
  }

  # Dependencies
  depends_on = [
    null_resource.remote_config_test
  ]
}

# Define a null_resource block for the remote-exec provisioning
resource "null_resource" "remote_config_test" {
  count = var.test-node-count

  # Provisioner block for remote-exec
  provisioner "remote-exec" {
    # Command to run on the remote node
    inline = ["sudo apt update > /dev/null"]

    # SSH connection details
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_key_path)
      host        = element(var.aws_eips, count.index)
    }
  }

  # Dependencies
  depends_on = [
    local_file.inventory_setup_test, 
    local_file.ssh-setup-test,
    time_sleep.wait_30_seconds_test]
}

#### Sleeper, after instance, eip assoc, local file inventories & cfg created
#### otherwise it can run to fast, not find the inventory file and fail or hang
resource "time_sleep" "wait_30_seconds_test" {
  create_duration = "30s"
  depends_on = [local_file.inventory_setup_test, 
                local_file.ssh-setup-test]
}

#### Generate Ansible Inventory for each node
resource "local_file" "inventory_setup_test" {
    count    = var.test-node-count
    content  = templatefile("${path.module}/ansible/inventories/inventory_test.tpl", {
        host_ip  = element(var.aws_eips, count.index)
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_test_node_${count.index}.ini"
}

#### Generate ansible.cfg file
resource "local_file" "ssh-setup-test" {
    content  = templatefile("${path.module}/ansible/config/ssh.tpl", {
        vpc_name = var.vpc_name
    })
    filename = "/tmp/${var.vpc_name}_test_node.cfg"
}

######################
# Run ansible playbook to install redis and memtier
resource "null_resource" "ansible_test_run" {
  count = var.test-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbooks/playbook_test_node.yaml --private-key ${var.ssh_key_path} -i /tmp/${var.vpc_name}_test_node_${count.index}.ini"
  }
  depends_on = [null_resource.remote_config_test, time_sleep.wait_30_seconds_test]
}