resource "aws_key_pair" "web_tier_key" {
  key_name   = "web-tier-key"
  public_key = file(var.web_public_key_path)
}

resource "aws_key_pair" "app_tier_key" {
  key_name   = "app-tier-key"
  public_key = file(var.app_public_key_path)
}


