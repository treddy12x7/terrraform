
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.azs.names)
  vpc_id                  = aws_vpc.test.*.id[0]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet - ${count.index + 1}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.*.id[0]

  tags = {
    Name      = terraform.workspace
    Createdby = "terraform"
  }
}
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.test.*.id[0]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = terraform.workspace
    Createdby = "terraform"
  }
}
resource "aws_route_table_association" "public_sub_associate" {
  count          = length(data.aws_availability_zones.azs.names)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.publicrt.id
}