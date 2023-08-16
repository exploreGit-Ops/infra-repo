variable "cluster_name" {
  type = string
}


variable "region" {
  type = string
}

variable "eks_credential" {
  type = string
}

variable "cluster_group" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "np_subnet_ids" {
  type = list(string)
}
