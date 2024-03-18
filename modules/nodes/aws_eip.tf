#### Create & associate EIP with RE and Test Nodes

#### RE Nodes EIP
resource "aws_eip" "instance_eip" {
  count = var.node-count
  network_border_group = var.region
  domain     = "vpc"

  tags = {
      Name = format("%s-%s-eip-%s", var.vpc_name, var.node-prefix, count.index+1),
      Owner = var.owner
  }

}

#### RE Node Elastic IP association
resource "aws_eip_association" "eip-assoc" {
  count = var.node-count
  instance_id   = element(aws_instance.instance.*.id, count.index)
  allocation_id = element(aws_eip.instance_eip.*.id, count.index)
  depends_on    = [aws_instance.instance, aws_eip.instance_eip]
}
