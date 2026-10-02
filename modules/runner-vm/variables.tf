variable "key_vault_id" {
  type        = string
  default     = ""
}

variable "resource_group_name" {
  type        = string
  default     = ""
}

variable "location" {
  type        = string
  default     = ""
}

variable "interface_id" {
    type        = string
    default     = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "current_subscription_id" {
  type        = string
  default     = ""
}