#### Create & attach EBS volumes for RE nodes

# Attach Ephemeral Volumes
resource "aws_ebs_volume" "ephemeral_re_cluster" {
  count = var.create_ebs_volumes ? var.node-count : 0
  availability_zone = element(var.subnet_azs, count.index)
  size              = var.ebs-volume-size

  tags = {
    Name = format("%s-%s-ec2-%s-ephemeral", var.vpc_name, var.node-prefix, count.index+1),
    Owner = var.owner
  }
}

resource "aws_volume_attachment" "ephemeral_re_cluster" {
  count = var.create_ebs_volumes ? var.node-count : 0
  device_name = "/dev/sdh"
  volume_id   = element(aws_ebs_volume.ephemeral_re_cluster.*.id, count.index)
  instance_id = element(aws_instance.instance.*.id, count.index)
}

# Attach Persistent Volumes
resource "aws_ebs_volume" "persistent_re_cluster" {
  count = var.create_ebs_volumes ? var.node-count : 0
  availability_zone = element(var.subnet_azs, count.index)
  size              = var.ebs-volume-size

  tags = {
    Name = format("%s-%s-ec2-%s-persistent", var.vpc_name, var.node-prefix, count.index+1),
    Owner = var.owner
  }
}

resource "aws_volume_attachment" "persistent_re_cluster" {
  count = var.create_ebs_volumes ? var.node-count : 0
  device_name = "/dev/sdj"
  volume_id   = element(aws_ebs_volume.persistent_re_cluster.*.id, count.index)
  instance_id = element(aws_instance.instance.*.id, count.index)
}