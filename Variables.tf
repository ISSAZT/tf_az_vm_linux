variable "resource_group_name" {
  type    = string
  default = "Staging-FC"
}
variable "location" {
  type    = string
  default = "France Central"
}
variable "virtual_network_name" {
  type    = string
  default = "Staging-FC"
}
variable "nic_name" {
  type        = string
  description = "this is the name of the Network Interface"
}
variable "linux_VM_name" {
  type        = string
  description = "this is the name of the linux VM "
}
variable "public_ip_name" {
  type        = string
  description = "This is the name of the public ip"
}
variable "admin_username" {
  type        = string
  description = "This is the virtual machine username"
}
variable "ssh_public_key_path" {
  type        = string
  description = "This is the public key path "
}