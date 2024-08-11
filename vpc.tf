#VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "3-Tier-VPC"
  }
}

# 2 Public Subnets for Web Tier
resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true 

  tags = {
    Name = "Public-Subnet-${var.availability_zones[count.index]}-${count.index}"
  }
}

# 2 Private Subnets for App Tier
resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private-Subnet-${var.availability_zones[count.index]}-${count.index}"
  }
}

# 2 Private Subnets for DB Tier
resource "aws_subnet" "db_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private-DB-Subnet-${var.availability_zones[count.index]}-${count.index}"
  }
}

