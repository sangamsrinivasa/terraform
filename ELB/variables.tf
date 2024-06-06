####################
# Variables for ELB
####################

variable "appsrv_port" {
  description = "Port application is running on or serving request forex: 8080 or 443"
  type = number
  port = 8080
}


variable "elb_port" [
  description = "Load Balancer port to server end clients"
  type = number
  port = 8080
}
