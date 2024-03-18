#### Required Variables

variable "region" {
    description = "AWS region"
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

#### VPC
variable "vpc_cidr" {
    description = "vpc-cidr"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "vpc_name" {
  description = "The VPC Project Name tag"
}

variable "vpc_subnets_ids" {
  type        = list(any)
  description = "The list of subnets available to the VPC"
}

variable "subnet_azs" {
    type = list(any)
    description = "subnet availability zone"
    default = [""]
}

variable "ena-support" {
  description = "choose AMIs that have ENA support enabled"
  default     = true
}

variable "node-root-size" {
  description = "The size of the root volume"
  default     = "50"
}

#### Security

variable "security_group_id" {
  description = "security group id"
  default     = ""
}


#############
variable "create_ebs_volumes" {
  description = "Whether to create EBS volume or not"
  type        = bool
  default     = false
}


variable "node-count" {
  description = "number of nodes"
  default     = 1
}

 
variable "node-prefix" {
  description = "node prefix"
  default     = ""
}

variable "ec2_instance_type" {
    description = "re instance type"
    default     = "t2.xlarge"
}

##### EBS volume for persistent and ephemeral storage
variable "ebs-volume-size" {
  description = "The size of the ephemeral and persistent volumes to attach"
  default     = "150"
}