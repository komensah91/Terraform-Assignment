variable "vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "instance_tenancy" {
    default = "default"
}
variable "region" {
    default =  "us-west-1" 
}
variable "enable_dns_hostnames" {
    default = "true"
}
variable "enable_dns_support" {
    default = "true"
}
variable "public_subnet_cidr" {
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "availability_zone" {
    default = ["us-west-1a","us-west-1c"]
}
variable "private_subnet_cidr" {
    default = ["10.0.3.0/24","10.0.4.0/24"]
}