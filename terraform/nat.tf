resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "cloud-native-monitoring-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name = "cloud-native-monitoring-nat-gateway"
  }

  depends_on = [module.vpc]
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = module.vpc.private_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

}
