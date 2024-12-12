data "aws_availability_zones" "available" {}



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = "${local.name}-vpc"
  cidr = local.vpc.vpc_cidr

  azs              = local.vpc.azs
  private_subnets  = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 4, k)]
  public_subnets   = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 8, k + 48)]
  database_subnets = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 8, k + 52)]

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []


  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = local.vpc.enable_vpc_flow_logs
  create_flow_log_cloudwatch_log_group = local.vpc.enable_vpc_flow_logs
  create_flow_log_cloudwatch_iam_role  = local.vpc.enable_vpc_flow_logs
  flow_log_max_aggregation_interval    = 60

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}