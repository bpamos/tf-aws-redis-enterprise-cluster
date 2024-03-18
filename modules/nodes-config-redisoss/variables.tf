#### Required Variables

variable "ssh_key_name" {
    description = "name of ssh key to be added to instance"
}

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "vpc_name" {
  description = "The VPC Project Name tag"
}


#### Test Instance Variables

#### instance type to use for test node with redis and memtier installed on it
variable "test-node-count" {
  description = "number of data nodes"
  default     = 1
}

variable "test_instance_type" {
    description = "instance type to use. Default: t3.micro"
    default = "t3.micro"
}

variable "aws_eips" {
  description = "list of eips"
  default     = []
}