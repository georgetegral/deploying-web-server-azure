variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity"
}

variable "environment" {
    description = "The environment which should be used for all resources in this example"
    default = "udacity"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "South Central US"
}

variable "username" {
    description = "username for the virtual machine"
}

variable "password" {
    description = "password for the virtual machine"
}