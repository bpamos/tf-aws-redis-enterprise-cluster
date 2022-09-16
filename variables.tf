variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "aws_creds" {
    description = "Access key and Secret key for AWS [Access Keys, Secret Key]"
}

variable "ssh_key_name" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

variable "owner" {
    description = "owner tag name"
}

# VPC
variable "vpc_cidr" {
    description = "vpc-cidr"
}

# DNS
variable "dns_hosted_zone_id" {
    description = "DNS hosted zone Id"
}

variable "base_name" {
    description = "base name for resources"
    default = "redisuser1-tf"
}

variable "subnet_cidr_blocks" {
    type = list(any)
    description = "subnet_cidr_block"
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "subnet_azs" {
    type = list(any)
    description = "subnet availability zone"
    default = ["us-east-1a","us-east-1b","us-east-1c"]
}
# Test Instance Variables

variable "test-node-count" {
  description = "number of data nodes"
  default     = 1
}

variable "test_instance_type" {
    description = "instance type to use. Default: t3.micro"
    default = "t3.micro"
}


# Redis Enterprise Cluster Variables
# redis enterpise software instance ami
# you need to search aws marketplace, select the region, and grab ami id.
# https://aws.amazon.com/marketplace/server/configuration?productId=412acaa0-2074-4156-93a4-576366bbf396&ref_=psb_cfg_continue

variable "data-node-count" {
  description = "number of data nodes"
  default     = 3
}

variable "ena-support" {
  description = "choose AMIs that have ENA support enabled"
  default     = true
}

variable "re_instance_type" {
    description = "re instance type"
    default     = "t2.xlarge"
}

variable "node-root-size" {
  description = "The size of the root volume"
  default     = "50"
}

# EBS volume for persistent and ephemeral storage

### must import "local variable to use this"
# variable "enable-volumes" {
#   description = "Enable EBS Devices for Ephemeral and Persistent storage"
#   default     = true
# }
# variable "enable-volumes" {
#   description = "Enable EBS Devices for Ephemeral and Persistent storage"
#   default     = true
# }


variable "re-volume-size" {
  description = "The size of the ephemeral and persistent volumes to attach"
  default     = "150"
}

#### Security

variable "open-nets" {
  type        = list(any)
  description = "CIDRs that will have access to everything"
  default     = []
}

variable "allow-public-ssh" {
  description = "Allow SSH to be open to the public - disabled by default"
  default     = "0"
}

variable "internal-rules" {
  description = "Security rules to allow for connectivity within the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      comment   = "SSH from VPC"
    },
    {
      type      = "ingress"
      from_port = "1968"
      to_port   = "1968"
      protocol  = "tcp"
      comment   = "Proxy traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "3333"
      to_port   = "3341"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "3343"
      to_port   = "3344"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "36379"
      to_port   = "36380"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "8001"
      to_port   = "8001"
      protocol  = "tcp"
      comment   = "Traffic from application to RS Discovery Service"
    },
    {
      type      = "ingress"
      from_port = "8002"
      to_port   = "8002"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8004"
      to_port   = "8004"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8006"
      to_port   = "8006"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8443"
      to_port   = "8443"
      protocol  = "tcp"
      comment   = "Secure (HTTPS) access to the management web UI"
    },
    {
      type      = "ingress"
      from_port = "8444"
      to_port   = "8444"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "9080"
      to_port   = "9080"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "9081"
      to_port   = "9081"
      protocol  = "tcp"
      comment   = "For CRDB management (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "8070"
      to_port   = "8071"
      protocol  = "tcp"
      comment   = "Prometheus metrics exporter"
    },
    {
      type      = "ingress"
      from_port = "9443"
      to_port   = "9443"
      protocol  = "tcp"
      comment   = "REST API traffic, including cluster management and node bootstrap"
    },
    {
      type      = "ingress"
      from_port = "10000"
      to_port   = "19999"
      protocol  = "tcp"
      comment   = "Database traffic - if manually creating db ports pare down"
    },
    {
      type      = "ingress"
      from_port = "20000"
      to_port   = "29999"
      protocol  = "tcp"
      comment   = "Database shards traffic - if manually creating db ports pare down"
    },
    {
      type      = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type      = "ingress"
      from_port = "5353"
      to_port   = "5353"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type      = "ingress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type      = "egress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      comment   = "Let TCP out to the VPC"
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      comment   = "Let UDP out to the VPC"
    },
    #    {
    #      type      = "ingress"
    #      from_port = "8080"
    #      to_port   = "8080"
    #      protocol  = "tcp"
    #      comment   = "Allow for host check between nodes"
    #    },
  ]
}

variable "external-rules" {
  description = "Security rules to allow for connectivity external to the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    }
  ]
}

### OTHER

variable "dns_fdnq" {
    description = "."
    default = ""
}

variable "node_1_private_ip" {
    description = "."
    default = ""
}

variable "node_2_private_ip" {
    description = "."
    default = ""
}

variable "node_3_private_ip" {
    description = "."
    default = ""
}

variable "node_1_external_ip" {
    description = "."
    default = ""
}

variable "node_2_external_ip" {
    description = "."
    default = ""
}

variable "node_3_external_ip" {
    description = "."
    default = ""
}


##############################


# cluster commands

variable "re_cluster_username" {
    description = "redis enterprise cluster username"
    default     = "demo@redislabs.com"
}

variable "re_cluster_password" {
    description = "redis enterprise cluster password"
    default     = "123456"
}

# cluster db commands

variable "redis_db_name_1" {
    description = "redis enterprise db "
    default     = "myDB"
}

variable "redis_db_memory_size_1" {
    description = "redis enterprise db "
    default     = 100000000
}

variable "redis_db_replication_1" {
    description = "redis enterprise db "
    default     = "true"
}

variable "redis_db_sharding_1" {
    description = "redis enterprise db "
    default     = "false"
}

variable "redis_db_shard_count_1" {
    description = "redis enterprise db "
    default     = 1
}

variable "redis_db_proxy_policy_1" {
    description = "redis enterprise db "
    default     = "single"
}

variable "redis_db_shards_placement_1" {
    description = "redis enterprise db "
    default     = "dense"
}

variable "redis_db_data_persistence_1" {
    description = "redis enterprise db "
    default     = "aof"
}

variable "redis_db_aof_policy_1" {
    description = "redis enterprise db "
    default     = "appendfsync-always"
}

variable "redis_db_port" {
    description = "redis enterprise db "
    default     = 10000
}