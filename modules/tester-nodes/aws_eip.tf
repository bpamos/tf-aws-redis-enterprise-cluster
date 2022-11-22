#### Create & associate EIP with Test Nodes

#####################
#### Test Nodes EIP
resource "aws_eip" "test_node_eip" {
  count = var.test-node-count
  network_border_group = var.region
  vpc      = true

  tags = {
      Name = format("%s-test-eip-%s", var.vpc_name, count.index+1),
      Owner = var.owner
  }

}

#### Test Node Elastic IP association
resource "aws_eip_association" "test_eip_assoc" {
  count = var.test-node-count
  instance_id   = element(aws_instance.test_node.*.id, count.index)
  allocation_id = element(aws_eip.test_node_eip.*.id, count.index)
  depends_on    = [aws_instance.test_node, aws_eip.test_node_eip]
}
