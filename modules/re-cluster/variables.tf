#### OTHER
variable "region" {
    description = "AWS region"
}

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}

####### Create Cluster Variables
####### Node and DNS outputs used to Create Cluster
variable "dns_fqdn" {
    description = "."
    default = ""
}

variable "re-node-internal-ips" {
    type = list
    description = "."
    default = []
}

variable "re-node-eip-ips" {
    type = list
    description = "."
    default = []
}

variable "re-data-node-eip-public-dns" {
    type = list
    description = "."
    default = []
}

variable "re-data-node-info" {
    type = list
    description = "."
    default = []
}

############# cluster commands
variable "re_cluster_username" {
    description = "redis enterprise cluster username"
    default     = "admin@admin.com"
}

variable "re_cluster_password" {
    description = "redis enterprise cluster password"
    default     = "admin"
}

