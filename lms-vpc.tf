# lms-vpc creation
resource "aws_vpc" "lms-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "lms-vpc"
    }
}

# lms web subnet creation
resource "aws_subnet" "lms-web-sn" {
    vpc_id = aws_vpc.lms-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "lms-web-sn"
    }
}

# lms api subnet creation
resource "aws_subnet" "lms-api-sn" {
    vpc_id = aws_vpc.lms-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "lms-api-sn"
    }
}

# lms db subnet creation
resource "aws_subnet" "lms-db-sn" {
    vpc_id = aws_vpc.lms-vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "lms-db-sn"
    }
}

# lms internet gateway
resource "aws_internet_gateway" "lms-ig" {
    vpc_id = aws_vpc.lms-vpc.id
    tags = {
        Name = "lms-ig"
    }
}

# lms public route table
resource "aws_route_table" "lms-pub-rtb" {
    vpc_id = aws_vpc.lms-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lms-ig.id
    }
    tags = {
        Name = "lms-pub-rtb"
    }
}

# lms private route table
resource "aws_route_table" "lms-pri-rtb" {
    vpc_id = aws_vpc.lms-vpc.id
    tags = {
        Name = "lms-pri-rtb"
    }
}

# Subnet and route table association (web,api and db)
resource "aws_route_table_association" "lms-web-rtb-asc" {
    subnet_id = aws_subnet.lms-web-sn.id
    route_table_id = aws_route_table.lms-pub-rtb.id
}

resource "aws_route_table_association" "lms-api-rtb-asc" {
    subnet_id = aws_subnet.lms-api-sn.id
    route_table_id = aws_route_table.lms-pub-rtb.id
}

resource "aws_route_table_association" "lms-db-rtb-asc" {
    subnet_id = aws_subnet.lms-db-sn.id
    route_table_id = aws_route_table.lms-pri-rtb.id
}

# lms web nacl 
resource "aws_network_acl" "lms-web-nacl" {
    vpc_id = aws_vpc.lms-vpc.id
    egress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    tags = {
        Name = "lms-web-nacl"
    }
}

# lms api nacl 
resource "aws_network_acl" "lms-api-nacl" {
    vpc_id = aws_vpc.lms-vpc.id
    egress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    tags = {
        Name = "lms-api-nacl"
    }
}

# lms db nacl 
resource "aws_network_acl" "lms-db-nacl" {
    vpc_id = aws_vpc.lms-vpc.id
    egress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    tags = {
        Name = "lms-db-nacl"
    }
}

# Web Nacl association to Web subnet
resource "aws_network_acl_association" "lms-web-nacl-asc" {
    network_acl_id = aws_network_acl.lms-web-nacl.id
    subnet_id = aws_subnet.lms-web-sn.id
}

# api Nacl association to api subnet
resource "aws_network_acl_association" "lms-api-nacl-asc" {
    network_acl_id = aws_network_acl.lms-api-nacl.id
    subnet_id = aws_subnet.lms-api-sn.id
}

# db Nacl association to db subnet
resource "aws_network_acl_association" "lms-db-nacl-asc" {
    network_acl_id = aws_network_acl.lms-db-nacl.id
    subnet_id = aws_subnet.lms-db-sn.id
}

# web security group
resource "aws_security_group" "lms-web-sg" {
    name = "lms-web-sg"
    description = "allow SSH & HTTP traffic"
    vpc_id = aws_vpc.lms-vpc.id
    tags = {
        Name = "lms-web-sg"
    }
}

# web sg ingress rules
resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ingress-ssh" {
    security_group_id = aws_security_group.lms-web-sg.id
    from_port = 22
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ingress-http" {
    security_group_id = aws_security_group.lms-web-sg.id
    from_port = 80
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 80
}

# web sg egress rules
resource "aws_vpc_security_group_egress_rule" "lms-web-sg-egress" {
    security_group_id = aws_security_group.lms-web-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

# api security group
resource "aws_security_group" "lms-api-sg" {
    name = "lms-api-sg"
    description = "allow SSH & Nodejs traffic"
    vpc_id = aws_vpc.lms-vpc.id
    tags = {
        Name = "lms-api-sg"
    }
}

# api sg ingress rules
resource "aws_vpc_security_group_ingress_rule" "lms-api-sg-ingress-ssh" {
    security_group_id = aws_security_group.lms-api-sg.id
    from_port = 22
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-api-sg-ingress-nodejs" {
    security_group_id = aws_security_group.lms-api-sg.id
    from_port = 80
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 80
}

# api sg egress rules
resource "aws_vpc_security_group_egress_rule" "lms-api-sg-egress" {
    security_group_id = aws_security_group.lms-api-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

# db security group
resource "aws_security_group" "lms-db-sg" {
    name = "lms-db-sg"
    description = "allow SSH & Postgres traffic"
    vpc_id = aws_vpc.lms-vpc.id
    tags = {
        Name = "lms-db-sg"
    }
}

# db sg ingress rules
resource "aws_vpc_security_group_ingress_rule" "lms-db-sg-ingress-ssh" {
    security_group_id = aws_security_group.lms-db-sg.id
    from_port = 22
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-db-sg-ingress-http" {
    security_group_id = aws_security_group.lms-db-sg.id
    from_port = 80
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 80
}

# web sg egress rules
resource "aws_vpc_security_group_egress_rule" "lms-db-sg-egress" {
    security_group_id = aws_security_group.lms-db-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}