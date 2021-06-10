variable "prefix" {
  description = "The prefix which should be used for all resources in this example."
  default = "udacity"
}

variable "environment" {
  description = "The environment which should be used for all resources in this example."
  default = "dev"
}

variable "vm_num"{
  description = "The number of virtual machines to be deployed in this example."
  default = "2"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "South Central US"
}

variable "username" {
  description = "username for the virtual machine."
  default = "udacityuser"
}

variable "password" {
  description = "password for the virtual machine."
  default = "Udacity1Pass2@"
}

variable "image"{
  description = "The Packer Image location in Azure"
  default = "/subscriptions/76ecc65a-b866-4328-925f-0cafa9642559/resourceGroups/udacity-rg/providers/Microsoft.Compute/images/PackerImage"
}