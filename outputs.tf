output "web_alb_url" {
  description = "URL of the web tier ALB"
  value       = "http://${aws_lb.web_alb.dns_name}"
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value = aws_db_instance.app_db.endpoint
}

output "db_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.app_db.port
}
 
output "bastion_public_ip" {
  description = "Public IP address of the Bastion Host"
  value = aws_instance.bastion.public_ip
}