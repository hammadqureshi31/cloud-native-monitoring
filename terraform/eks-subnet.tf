resource "aws_subnet" "eks_control_plane" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = "eu-north-1b"
  cidr_block        = "10.0.12.0/24"

  tags = {
    Name = "cloud-native-monitoring-eks-control-plane-eu-north-1b"
  }
}

resource "aws_route_table" "eks_control_plane" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "cloud-native-monitoring-eks-control-plane-eu-north-1b"
  }
}

resource "aws_route_table_association" "eks_control_plane" {
  subnet_id      = aws_subnet.eks_control_plane.id
  route_table_id = aws_route_table.eks_control_plane.id
}
