# Application Load Balancer (ALB) for the Web Tier
resource "aws_lb" "web_alb" {
  name               = "web-alb"  
  internal           = false      
  load_balancer_type = "application"  
  security_groups    = [aws_security_group.internet_lb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  
  tags = {
    Name = "Web-ALB"  
  }
}

# ALB Listener for HTTP Traffic
resource "aws_lb_listener" "http_web_alb" {
  load_balancer_arn = aws_lb.web_alb.arn  
  port              = 80  
  protocol          = "HTTP"  


  default_action {
    type = "forward"  
    target_group_arn = aws_lb_target_group.web_target_group.arn 

  }
}

# Auto Scaling Group (ASG) for Web Instances
resource "aws_autoscaling_group" "web_asg" {
  name                      = "Web-tier-ASG"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"  
  target_group_arns         = [aws_lb_target_group.web_target_group.arn]  
  vpc_zone_identifier       = [for subnet in aws_subnet.public_subnets : subnet.id]

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "webtier-ASG"
    propagate_at_launch = true
  }
}

# Launch Template for Web Instances
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-launch-template"  
  description   = "Launch template for Web Tier ASG"
  image_id      = var.ami_id 
  instance_type = var.instance_type

  user_data = filebase64("${path.module}/scripts/web_tier.sh")  

  monitoring {
    enabled = true
  }

  key_name = aws_key_pair.web_tier_key.key_name

  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]

  tags = {
    Name = "Web-Launch-Template"  
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"  # Path for health checks
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Web-Target-Group"
  }
}

