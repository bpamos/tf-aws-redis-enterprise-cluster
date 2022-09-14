

# DNS
variable "dns_hosted_zone_id" {
    description = "DNS hosted zone Id"
}

variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "base_name" {
    description = "base name for resources"
    default = "redisuser1-tf"
}

variable "data-node-count" {
  description = "number of data nodes"
  default     = 3
}

variable "re-data-node-eips" {
  type        = list(any)
  description = "List of Elastic IP address to add as A records"
  default     = []
}