variable "cluster_name" {
  type    = string
  default = "workhorse"
}


variable "app_subnets" {
  type        = list
  description = "Subnet IDs intended to hold K8S nodes and pods."
}


variable "safelist" {
  type        = list
  description = "IP addresses allowed to contact K8S API Server."
  default     = []
}
