variable "vm_name" {
  description = "Name of the virtual machine"
}
variable "image_id" {
  description = "Name of the image to use for the VM"
  default     = "033e0a54-423a-4835-afe6-5ae28e82f215" # e.g., ubuntu-noble-x86_64
}
variable "flavor_name" {
  description = "Flavor ID for the VM"
  default     = "e1.1core-2ram"
}
variable "key_pair" {
  description = "Name of the key pair for SSH access"
}
variable "network_id" {
  description = "ID of the network to attach the VM"
}
variable "floating_ip_pool" {
  description = "Floating IP pool name"
}

