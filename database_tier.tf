# Define the RDS instance with Multi-AZ
resource "aws_db_instance" "app_db" {
  identifier            = "app-db-instance"
  instance_class        = "db.t3.micro"
  engine                = "mysql"
  username              = var.db_username 
  password              = var.db_password // for production purposes, use secrets manager etc instead
  db_name               = "appdb"
  allocated_storage     = 20
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  backup_retention_period = 7
  maintenance_window    = "Sun:03:00-Sun:04:00"
  multi_az              = true
  publicly_accessible   = false

  # Only suitable for non-critical environments where data is temporary and not necessary for recovery
  skip_final_snapshot   = true

  tags = {
    Name = "App-DB"
  }
}


# Define the DB subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.db_subnets : subnet.id]

  tags = {
    Name = "Main DB Subnet Group"
  }
}

