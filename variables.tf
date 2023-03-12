# Provider
variable "vsphere_user" {
    description = "value"
    type = string
    default = null
}

variable "vsphere_password" {
    description = "value"
    type = string
    default = null
}

variable "vsphere_server" {
    description = "value"
    type = string
    default = null
}

variable "template_name" {
    description = "value"
    type = string
    default = null
}

# Network
variable "dns_server" {
    description = "value"
    type = string
    default = "192.168.1.1"
}

variable "network_name" {
    description = "value"
    type = string
    default = null
}

# Master
variable "vm_master_name" {
    description = "value"
    type = string
    default = null
}

variable "vm_master_cpus" {
    description = "number"
    type = string
    default = null
}

variable "vm_master_memory" {
    description = "number"
    type = string
    default = null
}

variable "vm_master_set" {
    description = "map"
    type = map
    default = null
}

# Worker
variable "vm_worker_name" {
    description = "value"
    type = string
    default = null
}

variable "vm_worker_cpus" {
    description = "number"
    type = string
    default = null
}

variable "vm_worker_memory" {
    description = "number"
    type = string
    default = null
}

variable "vm_worker_set" {
    description = "map"
    type = map
    default = null
}