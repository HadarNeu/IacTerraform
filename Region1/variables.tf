variable "region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "eks-cluster"
}

variable "local_host_ip" {
  description = "the host of the admin- external ip"
  type = string
  default = "46.121.0.238/32"
}

variable "map_accounts" {
  description = "Additional AWS account id's to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "854639092412",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

variable "private_subnets" {
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnets" {
  default = ["10.0.64.0/19", "10.0.96.0/19"]
}
