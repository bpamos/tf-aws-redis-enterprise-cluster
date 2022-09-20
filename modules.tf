

########### VPC Module
module "vpc" {
    source = "./modules/vpc"
    aws_creds = var.aws_creds
    owner = var.owner
    region = var.region
    base_name = var.base_name
    vpc_cidr = var.vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs = var.subnet_azs
}


output "subnet-ids" {
  value = module.vpc.subnet-ids
}

output "vpc-id" {
  value = module.vpc.vpc-id
}

output "vpc_name" {
  description = "get the VPC Name tag"
  value = module.vpc.vpc-name
}

########### Node Module
module "nodes" {
    source = "./modules/nodes"
    #aws_creds = var.aws_creds
    owner = var.owner
    region = var.region
    #base_name = var.base_name
    vpc_cidr = var.vpc_cidr
    #subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs = var.subnet_azs
    # Node required
    ssh_key_name = var.ssh_key_name
    ssh_key_path = var.ssh_key_path
    #dns_hosted_zone_id = var.dns_hosted_zone_id
    #test_instance_type = var.test_instance_type
    #test-node-count = var.test-node-count
    data-node-count = var.data-node-count
    re_instance_type = var.re_instance_type
    #enable-volumes = var.enable-volumes
    re-volume-size = var.re-volume-size
    allow-public-ssh = var.allow-public-ssh
    open-nets = var.open-nets
    # from vpc module outputs (these do not need to be varibles in the variables.tf outside the modules folders
    # since they are refrenced from the other module, but they need to be variables 
    # in the variables.tf inside the nodes module folder )
    vpc_name = module.vpc.vpc-name
    vpc_subnets_ids = module.vpc.subnet-ids
    vpc_id = module.vpc.vpc-id
}


output "re-data-node-eips" {
  value = module.nodes.re-data-node-eips
}

output "re-data-node-internal-ips" {
  value = module.nodes.re-data-node-internal-ips
}

output "re-data-node-public-dns" {
  value = module.nodes.re-data-node-public-dns
}

output "test-node-eips" {
  value = module.nodes.test-node-eips
}

########### DNS Module
module "dns" {
    source = "./modules/dns"
    #region = var.region
    #base_name = var.base_name
    dns_hosted_zone_id = var.dns_hosted_zone_id
    data-node-count = var.data-node-count
    vpc_name = module.vpc.vpc-name
    re-data-node-eips = module.nodes.re-data-node-eips
}

output "dns-ns-record-name" {
  value = module.dns.dns-ns-record-name
}

############## RE Cluster
##Module to access VM, then run ansilbe to create the cluster
module "create-cluster" {
  source = "./modules/re-cluster"
  ssh_key_path = var.ssh_key_path
  region = var.region
  dns_fqdn             = module.dns.dns-ns-record-name
  node_1_private_ip    = module.nodes.re-data-node-internal-ips[0]
  node_1_external_ip   = module.nodes.re-data-node-eips[0]
  node_1_public_dns    = module.nodes.re-data-node-public-dns[0]
  node_2_private_ip    = module.nodes.re-data-node-internal-ips[1]
  node_2_external_ip   = module.nodes.re-data-node-eips[1]
  node_2_public_dns    = module.nodes.re-data-node-public-dns[1]
  node_3_private_ip    = module.nodes.re-data-node-internal-ips[2]
  node_3_external_ip   = module.nodes.re-data-node-eips[2]
  node_3_public_dns    = module.nodes.re-data-node-public-dns[2]
  re_cluster_username             = var.re_cluster_username
  re_cluster_password             = var.re_cluster_password
  
  depends_on = [module.vpc, module.nodes, module.dns]
}