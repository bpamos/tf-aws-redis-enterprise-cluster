# Memtier Instance - Variable Configuration

# import user data
# template file can pass user data into instance.
# here we provide various variables pulled from created resources and variables.tf 
# to use inside the "install_memtier_bnechmark.yml" file
data "template_file" "user_data" {
  template = file("${path.module}/create_cluster.yml")

  # variables used inside yml
  vars = {
    aws_creds_access_key = var.aws_creds[0]
    aws_creds_secret_key = var.aws_creds[1]
    dns_fdnq             = var.dns_fdnq
    node_1_private_ip    = var.node_1_private_ip
    node_1_external_ip   = var.node_1_external_ip
    node_2_private_ip    = var.node_2_private_ip
    node_2_external_ip   = var.node_2_external_ip
    node_3_private_ip    = var.node_3_private_ip
    node_3_external_ip   = var.node_3_external_ip
    username             = var.re_cluster_username
    password             = var.re_cluster_password
    redis_db_name_1             = var.redis_db_name_1
    redis_db_memory_size_1      = var.redis_db_memory_size_1
    redis_db_replication_1      = var.redis_db_replication_1
    redis_db_sharding_1         = var.redis_db_sharding_1
    redis_db_shard_count_1      = var.redis_db_shard_count_1
    redis_db_proxy_policy_1     = var.redis_db_proxy_policy_1
    redis_db_shards_placement_1 = var.redis_db_shards_placement_1
    redis_db_data_persistence_1 = var.redis_db_data_persistence_1
    redis_db_aof_policy_1       = var.redis_db_aof_policy_1
    redis_db_port               = var.redis_db_port
  }
}



# create test node to run memtier benchmarks against cluster and create cluster via REST API.
resource "aws_instance" "test_node" {
  count                       = var.test-node-count
  ami                         = data.aws_ami.re-ami.id
  associate_public_ip_address = true
  availability_zone           = element(var.subnet_azs, count.index)
  subnet_id                   = element(var.vpc_subnets_ids, count.index)
  instance_type               = var.test_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [ aws_security_group.re_sg.id ]
  source_dest_check           = false

  user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = format("%s-test-node-%s", var.vpc_name,count.index+1),
    Owner = var.owner
  }

}

