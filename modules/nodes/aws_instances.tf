#### Create EC2 Nodes for RE and Test

# create nodes for your Redis Enterprise cluster
resource "aws_instance" "instance" {
  count                       = var.node-count
  ami                         = data.aws_ami.ami.id
  associate_public_ip_address = true
  availability_zone           = element(var.subnet_azs, count.index)
  subnet_id                   = element(var.vpc_subnets_ids, count.index)
  instance_type               = var.ec2_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [ var.security_group_id ]
  root_block_device             { volume_size = var.node-root-size }

  tags = {
    Name = format("%s-%s-node-%s", var.vpc_name, var.node-prefix, count.index+1),
    Owner = var.owner
  }

}