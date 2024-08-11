variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_subnet_cidr_blocks" {
  description = "CIDR blocks for database subnets"
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "db_username" {
  description = "RDS username"
  type = string
}

variable "db_password" {
  description = "RDS password"
  type = string
}

variable "ami_id" {
  description = "AMI for launch template"
  default = "ami-0ae8f15ae66fe8cda"
}

variable "instance_type" {
  description = "Tnstance type for the EC2 instances"
  default     = "t2.micro"  
}

variable "whitelisted_ips" {
  description = "Whitelisted IP addresses for SSH access"
  type = list(string)
  default = []
}

variable "web_public_key_path" {
  description = "Web tier public key file path"
  type = string
}

variable "app_public_key_path" {
  description = "App tier public key file path"
  type = string
}