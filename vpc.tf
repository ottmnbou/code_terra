### Créer un VPC 
 resource "aws_vpc" "vpc_efrei" {
   cidr_block = "172.16.0.0/16"
   tags = {
        Name = "vpc_efrei"
    }
}

### Création de sous réseaux pour notre VPC
### Sous réseaux privé
resource "aws_subnet" "subnet_private" {
   vpc_id = aws_vpc.vpc_efrei.id
   cidr_block = "172.16.1.0/24"
   availability_zone = "ca-central-1a"
   tags = {
        Name = "subnet_private"
    }
}

### Création de sous réseaux pour notre VPC
### Sous réseaux public
resource "aws_subnet" "subnet_public" {
   vpc_id = aws_vpc.vpc_efrei.id
   cidr_block = "172.16.0.0/24"
   availability_zone = "ca-central-1b"
   tags = {
       Name = "subnet_public"
    }
}

### Créer une passerelle internet
resource "aws_internet_gateway" "igw-main" {
   vpc_id = aws_vpc.vpc_efrei.id
   tags = {"Name" = "igw-main" }
}

### Créer une nouvelle table de routage
resource "aws_route_table" "route-main" {
   vpc_id = aws_vpc.vpc_efrei.id
   route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw-main.id   
}

   tags = { 
      Name = "table_pub"
}
}

### Associer le sous réseau public à la nouvelle table de routage
resource "aws_route_table_association" "table-public" {
    subnet_id = aws_subnet.subnet_public.id
    route_table_id = aws_route_table.route-main.id
}

### Créer une interface réseau
resource "aws_network_interface" "ipaddr" {
   subnet_id = aws_subnet.subnet_public.id
   private_ips = ["172.16.0.100"]
}