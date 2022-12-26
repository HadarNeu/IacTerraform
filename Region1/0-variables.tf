variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "local_host_ip" {
  description = "the host of the admin- external ip"
  type = string
  default = "46.121.0.238/32"
}

variable "private_subnets" {
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnets" {
  default = ["10.0.64.0/19", "10.0.96.0/19"]
}
