variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "username" {
    description = "username for the virtual machine"
}

variable "password" {
    description = "password for the virtual machine"
}