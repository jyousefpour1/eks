#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "jy" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "jy" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.jy.id

}

resource "aws_internet_gateway" "jy" {
  vpc_id = aws_vpc.jy.id

  tags = {
    Name = "terraform-eks-jy"
  }
}

resource "aws_route_table" "jy" {
  vpc_id = aws_vpc.jy.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jy.id
  }
}

resource "aws_route_table_association" "jy" {
  count = 2

  subnet_id      = aws_subnet.jy.*.id[count.index]
  route_table_id = aws_route_table.jy.id
}
