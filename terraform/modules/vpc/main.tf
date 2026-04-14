##################
###     VPC    ###
##################

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "devsecops-vpc"
  }
}

######################
### public subnets ###
######################

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "devsecops-public-subnet-${count.index + 1}"
  }
}

#######################
### private subnets ###
#######################

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "devsecops-private-subnet-${count.index + 1}"
  }
}
#########################
### Internet Gateway ###
#########################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devsecops-igw"
  }
}

###################
### NAT Gateway ###
###################

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "devsecops-nat-gateway"
  }
}

##################################
### Elastic IP for NAT Gateway ###
##################################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "devsecops-nat-eip"
  }
}


##########################
### public Route Table ###
##########################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devsecops-public-rt"
  }
}

#######################################
### public Route table for IGW ########
#######################################
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#######################################
### public Route table associations ###
#######################################

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


###########################
### private Route Table ###
###########################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devsecops-private-rt"
  }
}
#######################################
### private Route table associations ##
#######################################

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

###########################################
### private Route table for NAT Gateway ###
###########################################

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
