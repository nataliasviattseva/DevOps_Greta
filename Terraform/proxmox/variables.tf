variable "api_token" {
  description = "Token to connect Proxmox API"
  type        = string
  default     = "root@pam!terraform=f9261031-9d88-419c-8f73-58b44eeeeabc"
}

variable "target_node" {
  description = "Proxmox node"
  type        = string
  default     = "pve"
}

variable "onboot" {
  description = "Auto start VM when node is started"
  type        = bool
  default     = true
}

variable "target_node_domain" {
  description = "Proxmox node domain"
  type        = string
  default     = ""
}

variable "vm_hostname" {
  description = "VM hostname"
  type        = string
  default     = "test"
}

variable "domain" {
  description = "VM domain"
  type        = string
  default     = "ns.local"
}

variable "vm_tags" {
  description = "VM tags"
  type        = list(string)
  default     = ["ubuntu2204"]
}

variable "template_tag" {
  description = "Template tag"
  type        = string
  default     = "ubuntu2204"
}

variable "sockets" {
  description = "Number of sockets"
  type        = number
  default     = 1
}

variable "cores" {
  description = "Number of cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Number of memory in MB"
  type        = number
  default     = 2048
}

variable "vm_user" {
  description = "User"
  type        = string
  sensitive   = true
  default     = "sysadmin"
}

variable "disk" {
  description = "Disk (size in GB)"
  type = object({
    storage = string
    size    = number
  })
  default = {
    storage = "local"
    size    = 10
  }
}

variable "additional_disks" {
  description = "Additional disks"
  type        = list(object({
    storage = string
    size    = number
  }))
  default = []
}
