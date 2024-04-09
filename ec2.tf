# Web Server
resource "aws_instance" "lms-web-server" {
    ami = "ami-0fe2bbc538d630d05"
    instance_type = "t2.micro"
    host_resource_group_arn = "arn:aws:iam::447154356908:user/lms-user"
    tenancy = "host"
    subnet_id = aws_subnet.lms-web-sn.id
    key_name = "lms-tf"
    vpc_security_group_ids = [aws_security_group.lms-web-sg.id]
    tags = {
        Name = "lms-web-server"
    }
}

# API Server
resource "aws_instance" "lms-api-server" {
    ami = "ami-0fe2bbc538d630d05"
    instance_type = "t2.micro"
    host_resource_group_arn = "arn:aws:iam::447154356908:user/lms-user"
    tenancy = "host"
    subnet_id = aws_subnet.lms-api-sn.id
    key_name = "lms-tf"
    vpc_security_group_ids = [aws_security_group.lms-api-sg.id]
    tags = {
        Name = "lms-api-server"
    }
}

# DB server
resource "aws_instance" "lms-db-server" {
    ami = "ami-0fe2bbc538d630d05"
    instance_type = "t2.micro"
    host_resource_group_arn = "arn:aws:iam::447154356908:user/lms-user"
    tenancy = "host"
    subnet_id = aws_subnet.lms-db-sn.id
    key_name = "lms-tf"
    vpc_security_group_ids = [aws_security_group.lms-db-sg.id]
    tags = {
        Name = "lms-db-server"
    }
}