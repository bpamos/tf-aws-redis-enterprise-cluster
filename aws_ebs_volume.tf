# # AWS EC2 instances are ephemeral, but your presistent database storage should not be.
# # For each node in the cluste configure both persistent and ephemeral storage.
# # TODO: create directories for both persistent and ephemeral storage in each node.


# # Attach Persistent Volumes
# # Instance 1
# resource "aws_ebs_volume" "persistent_rs_cluster_instance_1" {
#   availability_zone = var.subnet_az
#   size              = var.rs-volume-size

#   tags = {
#     Name = format("%s-%s-ec2-1-persistent", var.base_name, var.region),
#     Owner = var.owner
#   }
# }

# resource "aws_volume_attachment" "persistent_rs_cluster_instance_1" {
#   device_name = "/dev/sdj"
#   volume_id   = aws_ebs_volume.persistent_rs_cluster_instance_1.id
#   instance_id = aws_instance.rs_cluster_instance_1.id
# }


# # Attach Ephemeral Volumes
# # Instance 1
# resource "aws_ebs_volume" "ephemeral_rs_cluster_instance_1" {
#   availability_zone = var.subnet_az
#   size              = var.rs-volume-size

#   tags = {
#     Name = format("%s-%s-ec2-1-ephemeral", var.base_name, var.region),
#     Owner = var.owner
#   }
# }

# resource "aws_volume_attachment" "ephemeral_rs_cluster_instance_1" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.ephemeral_rs_cluster_instance_1.id
#   instance_id = aws_instance.rs_cluster_instance_1.id
# }
