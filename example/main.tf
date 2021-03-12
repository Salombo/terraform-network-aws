provider "aws" {
    region = "us-east-1"
}

module "subnet_addrs" {
  source = "./.."

  main_network = "10.0.0.0/16"
  networks = [
    {
      name     = "public-a"
      net_bits = 8
      availability_zone = "us-east-1a"
      public = "yes"
    },
    {
      name     = "private-a"
      net_bits = 8
      availability_zone = "us-east-1a"
      public = "no"
    },
    {
      name     = "public-b"
      net_bits = 8
      availability_zone = "us-east-1b"
      public = "yes"
    },
    {
      name     = "private-b"
      net_bits = 8
      availability_zone = "us-east-1b"
      public = "no"
    }
  ]
}

output "INPUT_VARS"{
  value       = module.subnet_addrs.networks
}

output "GLOBAL_NETWORK"{
  value       = module.subnet_addrs.base_cidr_block
}

output "NETWORK_ADDRESSES"{
  value       = module.subnet_addrs.network_cidr_blocks
}



//{name = "first", net_bits = "4", availability_zone = "us-east-1a", public = "yes"},