variable "environment_name" {
  type        = string
  description = "Workshop environment name"
  default     = "debug"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.25"
}

variable "karpenter_version" {
  type        = string
  description = "Karpenter version"
  default     = "v0.25.0"
}

variable "ami_release_version" {
  # https://github.com/awslabs/amazon-eks-ami/releases
  description = "Default EKS AMI release version for node groups"
  type        = string
  default     = "1.25.6-20230217"
  # default     = "1.24.9-20230203"
  # default     = "1.23.9-20221027"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "AWS tags that will be applied to all resources"
  default     = {}
}
