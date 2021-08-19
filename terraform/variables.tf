variable "instance_name" {
  description = "The Name for the EC2 Instance."
  type        = string
  default     = "Nopnithi-Terratest-Demo"
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "The server port."
  type        = number
  default     = 8080
}
