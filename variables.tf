variable "enabled" {
  description = "Enable or not costly resources"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name for all the resources as identifier"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet" {
  description = "ID of the public subnet to place the NAT instance"
  type        = string
}

variable "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of the private subnets. The NAT instance accepts connections from this subnets"
  type        = list
}

variable "private_route_table_ids" {
  description = "List of ID of the route tables for the private subnets. You can set this to assign the each default route to the NAT instance"
  type        = list
  default     = []
}

variable "extra_user_data" {
  description = "Extra script to run in the NAT instance"
  type        = string
  default     = ""
}

variable "image_id" {
  description = "AMI of the NAT instance. Default to the latest Amazon Linux 2"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "Candidates of spot instance type for the NAT instance. This is used in the mixed instances policy"
  type        = list
  default     = ["t3.nano", "t3a.nano"]
}

variable "use_spot_instance" {
  description = "Whether to use spot or on-demand EC2 instance"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Name of the key pair for the NAT instance. You can set this to assign the key pair to the NAT instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to resources created with this module"
  type        = map
  default     = {}
}

locals {
  // Generate common tags by merging variables and default Name
  common_tags = merge(
    var.tags, {
      Name = "nat-instance-${var.name}"
  })

  // Generate asg tags by merging variables in object format
  asg_tags = concat([
    for key, value in var.tags : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
    ], [
    {
      key                 = "Name"
      value               = "nat-instance-${var.name}"
      propagate_at_launch = true
    }
    ]
  )
}
