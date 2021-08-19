output "web_url" {
  value = "http://${aws_instance.example.public_ip}:${var.server_port}"
}
output "web_body" {
  value = var.instance_name
}