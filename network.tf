# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "main-igw"
  }
}

# Elastic IP (for a single NAT Gateway)
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP"
  }
}

# NAT Gateway 
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id  # For high availability, consider creating a NAT Gateway in each availability zone

  tags = {
    Name = "NAT-Gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" { 
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id 
  }

  tags = {
    Name = "Public-RT"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public_rt_assoc" { 
  count      = length(aws_subnet.public_subnets) 
  subnet_id  = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# App Tier Route Tables
resource "aws_route_table" "app_private_rt" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "App-Private-RT-${count.index + 1}"
  }
}

# App Tier Route Table Association
resource "aws_route_table_association" "app_private_rt_assoc" {
  count      = length(aws_subnet.private_subnets)  
  subnet_id  = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.app_private_rt[count.index].id
}


# DB Tier Route Tables
resource "aws_route_table" "db_private_rt" {
  count  = length(aws_subnet.db_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "DB-Private-RT-${count.index + 1}"
  }
}

# DB Tier Route Table Association
resource "aws_route_table_association" "db_private_rt_assoc" {
  count      = length(aws_subnet.db_subnets)
  subnet_id  = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.db_private_rt[count.index].id
}