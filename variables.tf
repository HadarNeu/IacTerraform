// Configuring the provider information
provider "aws" {
    region = "us-west-2"
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-0d593311db5abb72b"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "host_ip" {
  description = "The ip of the host running the tf file"
  type        = string
  default     = "46.121.1.19/32"
}

variable "key_name" {
  description = "The name of ssh key pair"
  type        = string
  default     = "hadar_key"

}
