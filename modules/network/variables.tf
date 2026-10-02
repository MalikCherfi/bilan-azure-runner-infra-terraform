variable "resource_group_name" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "IP ou CIDR autorisé à se connecter en SSH, ex: 203.0.113.10/32"
  default     = "86.201.70.133/32"
}
