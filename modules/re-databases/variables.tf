#### Required Variables
variable "ssh_key_path" {
    description = "name of ssh key to be added to instance"
}


variable "re_master_node" {
    description = "."
    default = ""
}

############# Create RE Cluster Variables

#### Cluster Inputs
#### RE Cluster Username
variable "re_cluster_username" {
    description = "redis enterprise cluster username"
    default     = "admin@admin.com"
}

#### RE Cluster Password
variable "re_cluster_password" {
    description = "redis enterprise cluster password"
    default     = "admin"
}

############# Create RE Databases

#### Create databases flag
variable "re_databases_create" {
  description = "Create databases"
  default     = false
}

variable "re_databases_json_file" {
    description = "Array of database objects to create using the RE REST API. Required if re_create_databases is set. "
    default = "./re_databases.json"
}