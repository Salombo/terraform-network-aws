variable "main_network" {
    type = string
    default = "192.168.0.0/24"
}

variable "networks" {
  type = list(object({
    name                = string
    net_bits            = number
    availability_zone   = string
    public               = string
  }))
  description = "Liste des noms de réseau et les bits à ajouter au main net"
  
  default = [
      {name = "first", net_bits = "4", availability_zone = "us-east-1a", public = "yes"},
      {name = "second", net_bits = "8", availability_zone = "us-east-1b", public = "no"},
      {name = "third", net_bits = "2", availability_zone = "us-east-1a", public = "no"}
  ]
}