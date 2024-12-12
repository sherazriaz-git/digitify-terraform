locals {
  name = "${var.project_name}-${var.env}"

  vpc = {
    enable_vpc_flow_logs = true
    vpc_cidr             = "10.0.0.0/16"
    enable_nat_gateway   = false
    azs                  = slice(data.aws_availability_zones.available.names, 0, 3)
  }

  eks = {

    version = "1.31"


  }
}