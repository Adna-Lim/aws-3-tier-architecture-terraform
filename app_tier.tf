# Application Load Balancer (ALB) for the App Tier
resource "aws_lb" "app_alb" {
  name               = "app-alb"                        
  internal           = true                             
  load_balancer_type = "application"                   
  security_groups    = [aws_security_group.internal_lb_sg.id]  
  subnets            = [for subnet in aws_subnet.private_subnets : subnet.id]  
                                   

  tags = {
    Name = "App-ALB"                                  
  }
}

# ALB Listener for HTTP Traffic
resource "aws_lb_listener" "http_app_alb" {
  load_balancer_arn = aws_lb.app_alb.arn                 
  port              = 80                              
  protocol          = "HTTP"                        

  default_action {
    type = "forward"                                  
    target_group_arn = aws_lb_target_group.app_target_group.arn 
  }
}

# Auto Scaling Group (ASG) for App Instances
resource "aws_autoscaling_group" "app_asg" {
  name                      = "App-tier-ASG"  
  desired_capacity          = 2            
  max_size                  = 3                        
  min_size                  = 2                         
  health_check_grace_period = 300                     
  health_check_type         = "ELB"                                            
  target_group_arns         = [aws_lb_target_group.app_target_group.arn]  
  vpc_zone_identifier       = [for subnet in aws_subnet.private_subnets : subnet.id]  

  launch_template {
    id      = aws_launch_template.app_launch_template.id   
    version = "$Latest"                                   
  }

  tag {
    key                 = "Name"
    value               = "app-tier-ASG"                    
    propagate_at_launch = true                             
  }
}

# Launch Template for App Instances
resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "app-launch-template"                 
  description   = "Launch template for App Tier ASG"      
  image_id      = var.ami_id                
  instance_type = var.instance_type                              

  user_data = filebase64("${path.module}/scripts/app_tier.sh")  

   monitoring {
    enabled = true
  }

  key_name = aws_key_pair.app_tier_key.key_name

  vpc_security_group_ids = [aws_security_group.private_instance_sg.id] 

  tags = {
    Name = "App-Launch-Template"                          
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "app_target_group" {
  name     = "app-target-group"                         
  port     = 80                                        
  protocol = "HTTP"                                     
  vpc_id   = aws_vpc.main.id                      

  health_check {
    path                = "/health"                    
    interval            = 30                            
    timeout             = 5                             
    healthy_threshold   = 2                             
    unhealthy_threshold = 2                             
  }

  tags = {
    Name = "App-Target-Group"                          
  }
}
