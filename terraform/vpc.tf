module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "cloud-native-monitoring-vpc"
  cidr = "10.0.0.0/16"

  azs = ["eu-north-1a"]

  public_subnets = [
    "10.0.1.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24"
  ]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
}
