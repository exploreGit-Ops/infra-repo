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

variable "k8s_version" {
  type = string
}

variable "cp_role_arn" {
  type = string
  default = "arn:aws:iam::687456942232:role/control-plane.17276895336783884699.eks.tmc.cloud.vmware.com"
}
variable "security_groups" {
  type = list(string)
  default = []
}

variable "worker_role_arn" {
  type = string
  default = "arn:aws:iam::687456942232:role/worker.17276895336783884699.eks.tmc.cloud.vmware.com"
}