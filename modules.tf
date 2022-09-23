########## Create an RE cluster on AWS from scratch #####
#### Modules to create the following:
#### Brand new VPC 
#### RE nodes and install RE software (ubuntu)
#### Test node with Redis and Memtier
#### DNS (NS and A records for RE nodes)
#### Create and Join RE cluster 


########### VPC Module
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "vpc" {
    source             = "./modules/vpc"
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region
    base_name          = var.base_name
    vpc_cidr           = var.vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs         = var.subnet_azs
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
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
#### Create RE and Test nodes
#### Ansible playbooks configure and install RE software on nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes" {
    source             = "./modules/nodes"
    owner              = var.owner
    region             = var.region
    vpc_cidr           = var.vpc_cidr
    subnet_azs         = var.subnet_azs
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    re_download_url    = var.re_download_url
    data-node-count    = var.data-node-count
    re_instance_type   = var.re_instance_type
    re-volume-size     = var.re-volume-size
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ## from vpc module outputs 
    ##(these do not need to be varibles in the variables.tf outside the modules folders
    ## since they are refrenced from the other module, but they need to be variables 
    ## in the variables.tf inside the nodes module folder )
    vpc_name           = module.vpc.vpc-name
    vpc_subnets_ids    = module.vpc.subnet-ids
    vpc_id             = module.vpc.vpc-id
}

#### Node Outputs to use in future modules
output "re-data-node-eips" {
  value = module.nodes.re-data-node-eips
}

output "re-data-node-internal-ips" {
  value = module.nodes.re-data-node-internal-ips
}

output "re-data-node-eip-public-dns" {
  value = module.nodes.re-data-node-eip-public-dns
}

# output "test-node-eips" {
#   value = module.nodes.test-node-eips
# }

########### DNS Module
#### Create DNS (NS record, A records for each RE node and its eip)
#### Currently using existing dns hosted zone
module "dns" {
    source             = "./modules/dns"
    dns_hosted_zone_id = var.dns_hosted_zone_id
    data-node-count    = var.data-node-count
    vpc_name           = module.vpc.vpc-name
    re-data-node-eips  = module.nodes.re-data-node-eips
}

#### dns FQDN output used in future modules
output "dns-ns-record-name" {
  value = module.dns.dns-ns-record-name
}

############## RE Cluster
#### Ansible Playbook runs locally to create the cluster
module "create-cluster" {
  source               = "./modules/re-cluster"
  ssh_key_path         = var.ssh_key_path
  region               = var.region
  vpc_name             = module.vpc.vpc-name
  re-node-internal-ips = module.nodes.re-data-node-internal-ips
  re-node-eip-ips      = module.nodes.re-data-node-eips
  re-data-node-eip-public-dns   = module.nodes.re-data-node-eip-public-dns
  dns_fqdn             = module.dns.dns-ns-record-name
  re_cluster_username  = var.re_cluster_username
  re_cluster_password  = var.re_cluster_password
  
  depends_on           = [module.vpc, module.nodes, module.dns]
}