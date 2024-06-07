########## Create an RE cluster on AWS from scratch #####
#### Modules to create the following:
#### Brand new VPC 
#### RE nodes and install RE software (ubuntu)
#### Test node with Redis and Memtier
#### Prometheus Node for advanced monitoring of Redis Enterprise Cluster
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

########### Security Group Module
#### create a security group
module "security-group" {
    source             = "./modules/security-group"

    owner              = var.owner
    vpc_cidr           = var.vpc_cidr
    allow-public-ssh   = var.allow-public-ssh
    open-nets          = var.open-nets
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_id             = module.vpc.vpc-id

    depends_on = [
      module.vpc
    ]
}

output "aws_security_group_id" {
  description = "aws security group"
  value = module.security-group.aws_security_group_id
}

####################################
########### Node Redis Enterprise Module
#### Create the nodes that will be used for Redis Enterprise
#### Just create the nodes and associated infra.
#### configure them and install RE in the config module.
module "nodes-re" {
    source             = "./modules/nodes"

    owner              = var.owner
    region             = var.region
    vpc_cidr           = var.vpc_cidr
    subnet_azs         = var.subnet_azs
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    node-count         = var.data-node-count
    ec2_instance_type  = var.re_instance_type
    node-prefix        = var.node-prefix-re
    ebs-volume-size    = var.re-volume-size
    create_ebs_volumes = var.create_ebs_volumes_re
    ### vars pulled from previous modules
    security_group_id  = module.security-group.aws_security_group_id
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_subnets_ids    = module.vpc.subnet-ids
    vpc_id             = module.vpc.vpc-id

    depends_on = [
      module.vpc,
      module.security-group
    ]
}

#### Node Outputs to use in future modules
output "re-data-node-eips" {
  value = module.nodes-re.node-eips
}

output "re-data-node-internal-ips" {
  value = module.nodes-re.node-internal-ips
}

output "re-data-node-eip-public-dns" {
  value = module.nodes-re.node-eip-public-dns
}

#####################################

#### Configure Redis Enterprise nodes
#### Ansible playbooks configure and install RE software on nodes
module "nodes-config-re" {
    source             = "./modules/nodes-config-re"

    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    re_download_url    = var.re_download_url
    data-node-count    = var.data-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_id             = module.vpc.vpc-id
    aws_eips           = module.nodes-re.node-eips

    depends_on = [
      module.nodes-re
    ]
}

########### DNS Module
#### Create DNS (NS record, A records for each RE node and its eip)
#### Currently using existing dns hosted zone
module "dns" {
    source             = "./modules/dns"

    dns_hosted_zone_id = var.dns_hosted_zone_id
    data-node-count    = var.data-node-count
    ### vars pulled from previous modules
    vpc_name           = module.vpc.vpc-name
    re-data-node-eips  = module.nodes-re.node-eips
}

#### dns FQDN output used in future modules
output "dns-ns-record-name" {
  value = module.dns.dns-ns-record-name
}

############## RE Cluster
#### Ansible Playbook runs locally to create the cluster A
module "create-cluster" {
  source               = "./modules/re-cluster"

  ssh_key_path         = var.ssh_key_path
  region               = var.region
  re_cluster_username  = var.re_cluster_username
  re_cluster_password  = var.re_cluster_password
  flash_enabled        = var.flash_enabled
  rack_awareness       = var.rack_awareness
  update_envoy_concurrency = var.update_envoy_concurrency
  envoy_concurrency_setting = var.envoy_concurrency_setting

  ### vars pulled from previous modules
  vpc_name             = module.vpc.vpc-name
  re-node-internal-ips = module.nodes-re.node-internal-ips
  re-node-eip-ips      = module.nodes-re.node-eips
  re-data-node-eip-public-dns   = module.nodes-re.node-eip-public-dns
  dns_fqdn             = module.dns.dns-ns-record-name
  
  depends_on           = [
    module.vpc, 
    module.nodes-re, 
    module.nodes-config-re, 
    module.dns]
}

#### Cluster Outputs
output "re-cluster-url" {
  value = module.create-cluster.re-cluster-url
}

output "re-cluster-username" {
  value = module.create-cluster.re-cluster-username
}

output "re-cluster-password" {
  value = module.create-cluster.re-cluster-password
}

############## RE Databases
#### Ansible Playbook runs locally to create the databases if set
module "create-databases" {
  source               = "./modules/re-databases"

  ssh_key_path         = var.ssh_key_path
  re_master_node   =  module.nodes-re.node-eip-public-dns[0]
  re_cluster_username  = var.re_cluster_username
  re_cluster_password  = var.re_cluster_password
  re_databases_create  = var.re_databases_create
  re_databases_json_file  = abspath(var.re_databases_json_file)
  
  depends_on           = [
    module.create-cluster
    ]
}



####################################
########### Node Module
#### Create Test nodes
#### Create the test nodes and their associated infra
#### configure them and install RE in the config module.
module "nodes-tester" {
    source             = "./modules/nodes"

    owner              = var.owner
    region             = var.region
    vpc_cidr           = var.vpc_cidr
    subnet_azs         = var.subnet_azs
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    node-count         = var.test-node-count
    node-prefix        = var.node-prefix-tester
    ec2_instance_type  = var.test_instance_type
    #ebs-volume-size    = var.re-volume-size
    create_ebs_volumes = var.create_ebs_volumes_tester
    ### vars pulled from previous modules
    security_group_id  = module.security-group.aws_security_group_id
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_subnets_ids    = module.vpc.subnet-ids
    vpc_id             = module.vpc.vpc-id

    depends_on = [
      module.vpc,
      module.security-group
    ]
}

#### Node Outputs to use in future modules
output "test-node-eips" {
  value = module.nodes-tester.node-eips
}

output "test-node-internal-ips" {
  value = module.nodes-tester.node-internal-ips
}

output "test-node-eip-public-dns" {
  value = module.nodes-tester.node-eip-public-dns
}


#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "nodes-config-redisoss" {
    source             = "./modules/nodes-config-redisoss"

    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_id             = module.vpc.vpc-id
    aws_eips           = module.nodes-tester.node-eips

    depends_on = [
      module.nodes-tester
    ]
}


######## Prometheus and Grafana Module
### configure prometheus and grafana on TEST node
######## IF YOU DONT WANT A GRAFANA ON THE NODE, Comment out this module and its outputs
module "prometheus-node" {
    source             = "./modules/prometheus-node"
    
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    test-node-count    = var.test-node-count
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_id             = module.vpc.vpc-id
    aws_eips           = module.nodes-tester.node-eips
    
    prometheus_instance_type = var.test_instance_type
    dns_fqdn           = module.dns.dns-ns-record-name


    depends_on = [module.vpc, 
                  module.nodes-tester,
                  module.nodes-config-redisoss,
                  module.dns, 
                  module.create-cluster]
}

#### dns FQDN output used in future modules
output "grafana_url" {
  value = module.prometheus-node.grafana_url
}

output "grafana_username" {
  value = "admin"
}

output "grafana_password" {
  value = "secret"
}
