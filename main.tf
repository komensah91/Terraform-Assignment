
resource "aws_vpc" "Tenacity" {
    cidr_block = var.vpc_cidr
    instance_tenancy = var.instance_tenancy
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support
tags = {
    Name = "Tenacity_VPC"
}
}   

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.Tenacity.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zone[count.index]

    tags = {
        Name = "Prod-pub-sub-${count.index + 1}"
    }
}


resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.Tenacity.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = var.availability_zone[count.index]

    tags = {
        Name = "Prod-priv-sub-${count.index + 1}"
    }
}



resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.Tenacity.id
    route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.Tenacity-igw.id    
    }

    tags = {
    Name = "public-route-table"
    }
}


resource "aws_internet_gateway" "Tenacity-igw" {
    vpc_id = aws_vpc.Tenacity.id

    tags = {
    Name = "Tenacity-igw"
    }
}
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.Tenacity.id

    tags = {
    Name = "private-route-table"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    count = length(var.private_subnet_cidr)
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
    count = length(var.private_subnet_cidr)
    subnet_id      = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Tenacity-igw.id
}

resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_subnet[0].id
}

resource "aws_route" "private_nat_gateway" {
    route_table_id = aws_route_table.private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
}