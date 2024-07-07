


resource "aws_instance" "ec2-instance" {
    ami = var.ami-id
    instance_type = var.type
    vpc_security_group_ids = [aws_security_group.asia_sg.id]
    subnet_id = var.subnet_id
    availability_zone = var.az
 
    associate_public_ip_address = true

}
