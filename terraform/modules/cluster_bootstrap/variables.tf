variable "kubeconfig" {
  type = string
}


variable "azure_client_id" {
  type = string
  sensitive = true
}

variable "azure_client_secret" {
  type = string
  sensitive = true
}