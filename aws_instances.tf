# Resource: aws_instance (provides aws instances)
# Create your aws instances, 
# 1 memtier instance with a template file of variables for commands to run after instance creation.
# 3 Redis Enterprise marketplace instances (with RS installed)
# Redis Enterprise Cluster Instances

# create Redis Enterprise cluster instance (requires ami)
resource "aws_instance" "rs_cluster_instance_1" {
  count                       = var.data-node-count
  ami                         = data.aws_ami.re-ami.id
  associate_public_ip_address = true
  #subnet_id                   = aws_subnet.re_subnet.id
  availability_zone      = element(var.subnet_azs, count.index)
  subnet_id              = element([aws_subnet.re_subnet1.id,aws_subnet.re_subnet2.id,aws_subnet.re_subnet3.id], count.index)
  instance_type               = var.rs_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [ aws_security_group.re_sg.id ]

  tags = {
    Name = format("%s-%s-node-%s", var.base_name, var.region,count.index),
    Owner = var.owner
  }
}

# Elastic IP association

# associate aws eips created in "aws_eip.tf" to each instance
# resource "aws_eip_association" "rs-eip-assoc-1" {
#   instance_id   = aws_instance.rs_cluster_instance_1.id
#   allocation_id = aws_eip.rs_cluster_instance_1.id
#   depends_on    = [aws_instance.rs_cluster_instance_1]
# }
