resource "aws_subnet" "privat" {
  count             = var.counts
  vpc_id            = aws_vpc.test.*.id[0]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.azs))
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  #map_public_ip_on_launch = true
  tags = {
    Name = "private-subnet - ${count.index + 1}"
  }
}
resource "aws_nat_gateway" "natgw" {
  count         = var.counts
  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags = {
    Name      = terraform.workspace
    Createdby = "terraform"
  }
}
resource "aws_eip" "nat" {
  vpc   = true
  count = var.counts
}

resource "aws_route_table" "privatert" {
  count = var.counts

  vpc_id = aws_vpc.test.*.id[0]
  tags = {
    "Name"      = "private-rt"
    "createdby" = "terraform"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.*.id[count.index]
  }
}
resource "aws_route_table_association" "private_sub_associate" {
  count          = var.counts
  subnet_id      = aws_subnet.privat.*.id[count.index]
  route_table_id = aws_route_table.privatert.*.id[count.index]
}