variable "region" {
  type = string
}

variable "zone" {
    type = string
}

variable "project" {
    type = string
}

variable "subnet1_cidr" {
    type = string
    
}

variable "subnet2_cidr" {
    type = string
    
}

variable "secondary_ip_range_restricted_1" {
    type = string
}

variable "secondary_ip_range_restricted_2" {
    type = string
}

variable "machine_type" {
    type = string
}

variable "boot_disk_image" {
    type = string
    description = "(optional) describe your variable"
}