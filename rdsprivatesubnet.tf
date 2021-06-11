resource "aws_subnet" "rdsprivat" {
  count             = var.counts
  vpc_id            = aws_vpc.test.*.id[0]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 13)
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  #map_public_ip_on_launch = true
  tags = {
    Name = "rdsprivate-subnet - ${count.index + 1}"
  }
}
resource "aws_route_table_association" "rdsprivate_sub_associate" {
  count          = var.counts
  subnet_id      = aws_subnet.rdsprivat.*.id[count.index]
  route_table_id = aws_route_table.privatert.*.id[count.index]
}