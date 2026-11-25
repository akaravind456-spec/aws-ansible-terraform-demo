output "public_ip" {
  description = "Public IP of the web server (use it in ansible/inventory.ini)"
  value       = aws_instance.web.public_ip
}
