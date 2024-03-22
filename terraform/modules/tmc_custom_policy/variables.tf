variable "cluster_group" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "template_name" {
  type = string
}

variable "audit" {
  type = bool
  default = false
}

variable "parameters" {
  type = any
  validation {
    condition = (can(jsonencode(var.parameters)))
    error_message = "unable to parse as json"
  }
  default = null
}

variable "target_kubernetes_resources" {
  type = list(object({
    api_groups = list(string)
    kinds = list(string)
  }))
  default = []
}

variable "match_expressions" {
  type = list(object({
    values = optional(list(string),[])
    key = string
    operator = string
  }))
  default = []
}