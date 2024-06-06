
output "alb_dns_name" {
  value = aws_elb.retail_elb.dns_name
  description = "DNS name of Load balancer"
}




