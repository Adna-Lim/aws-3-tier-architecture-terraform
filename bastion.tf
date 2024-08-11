# Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id = aws_vpc.main.id 

  ingress {
    description = "SSH access from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelisted_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami           = var.ami_id 
  instance_type = var.instance_type 
  key_name      = aws_key_pair.web_tier_key.key_name # Replace with your SSH key pair name as needed
  subnet_id     = aws_subnet.public_subnets[0].id  
  security_groups = [aws_security_group.bastion_sg.id]  
  associate_public_ip_address = true
  tags = {    Name = "Bastion-Host"
  }
}