# Resource: aws_instance (provides aws instances)
# Create your aws instances, 
# 1 memtier instance with a template file of variables for commands to run after instance creation.
# 3 Redis Enterprise marketplace instances (with re installed)
# Redis Enterprise Cluster Instances

# create Redis Enterprise cluster instance (requires ami)
resource "aws_instance" "re_cluster_instance" {
  count                       = var.data-node-count
  ami                         = data.aws_ami.re-ami.id
  associate_public_ip_address = true
  availability_zone           = element(var.subnet_azs, count.index)
  subnet_id                   = element([aws_subnet.re_subnet1.id,aws_subnet.re_subnet2.id,aws_subnet.re_subnet3.id], count.index)
  instance_type               = var.re_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [ aws_security_group.re_sg.id ]
  root_block_device             { volume_size = var.node-root-size }

  tags = {
    Name = format("%s-%s-node-%s", var.base_name, var.region,count.index+1),
    Owner = var.owner
  }

}



# resource "aws_instance" "re_cluster_instance" {
#   count                       = var.data-node-count
#   ami                         = data.aws_ami.re-ami.id
#   associate_public_ip_address = true
#   availability_zone           = element(var.subnet_azs, count.index)
#   subnet_id                   = element([aws_subnet.re_subnet1.id,aws_subnet.re_subnet2.id,aws_subnet.re_subnet3.id], count.index)
#   instance_type               = var.re_instance_type
#   key_name                    = var.ssh_key_name
#   vpc_security_group_ids      = [ aws_security_group.re_sg.id ]
#   root_block_device             { volume_size = var.node-root-size }

#   tags = {
#     Name = format("%s-%s-node-%s", var.base_name, var.region,count.index+1),
#     Owner = var.owner
#   }
# }