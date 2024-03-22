variable "template-file" {
  type = string
}

variable "data-inventory" {
  type = list(object({
    kind = string
    version = string
    group = string
  }))
  default = []
}