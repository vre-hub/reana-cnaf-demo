variable "reana_release_name" {
  description = "The reana helm release name"
  type        = string
  default     = "reana-demo"
}

variable "reana-ns" {
  description = "The name of the namespace for rucio"
  type        = string
  default     = "reana"
}