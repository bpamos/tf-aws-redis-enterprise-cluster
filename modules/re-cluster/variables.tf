# ### OTHER
variable "region" {
    description = "AWS region"
}

variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}


variable "dns_fqdn" {
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

variable "node_1_public_dns" {
    description = "."
    default = ""
}

variable "node_2_public_dns" {
    description = "."
    default = ""
}

variable "node_3_public_dns" {
    description = "."
    default = ""
}

variable "re_cluster_username" {
    description = "redis enterprise cluster username"
    default     = "admin@admin.com"
}

variable "re_cluster_password" {
    description = "redis enterprise cluster password"
    default     = "admin"
}