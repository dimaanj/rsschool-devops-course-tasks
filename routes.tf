resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat.primary_network_interface_id
  }
  tags = {
    Name = "private-rt-a"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat.primary_network_interface_id
  }
  tags = {
    Name = "private-rt-b"
  }
}

# Public subnet associations
resource "aws_route_table_association" "public" {
  for_each = {
    "a" = aws_subnet.public_a.id
    "b" = aws_subnet.public_b.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Private subnet associations
resource "aws_route_table_association" "private" {
  for_each = {
    "a" = { subnet = aws_subnet.private_a.id, rt = aws_route_table.private_a.id }
    "b" = { subnet = aws_subnet.private_b.id, rt = aws_route_table.private_b.id }
  }
  subnet_id      = each.value.subnet
  route_table_id = each.value.rt
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_instance" "nat" {
  ami           = "ami-0c94855ba95c71c99" // Amazon Linux 2 AMI (HVM), SSD Volume Type, us-east-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_a.id
  associate_public_ip_address = true
  source_dest_check = false
  vpc_security_group_ids = [aws_security_group.bastion_sg.id] // Allow SSH for management
  tags = {
    Name = "NAT Instance"
  }
}

resource "aws_eip_association" "nat" {
  instance_id   = aws_instance.nat.id
  allocation_id = aws_eip.nat.id
} 