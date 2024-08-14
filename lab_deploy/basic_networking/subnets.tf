#
# Public subnets
#

resource "aws_subnet" "public_subnet_az1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet_az1_cidr_block
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.name_keyword}-public-az1"
        "wg:purpose:serviceid" = "public"
    }
}

resource "aws_subnet" "public_subnet_az2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet_az2_cidr_block
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.name_keyword}-public-az2"
        "wg:purpose:serviceid" = "public"
    }
}


#
# Middleware subnets
#

resource "aws_subnet" "middleware_subnet_az1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.middleware_subnet_az1_cidr_block
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.name_keyword}-middleware-az1"
        "wg:purpose:serviceid" = "middleware"
    }
}
resource "aws_subnet" "middleware_subnet_az2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.middleware_subnet_az2_cidr_block
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.name_keyword}-middleware-az2"
        "wg:purpose:serviceid" = "middleware"
    }
}


#
# Db subnets
#

resource "aws_subnet" "db_subnet_az1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.db_subnet_az1_cidr_block
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.name_keyword}-db-az1"
        "wg:purpose:serviceid" = "db"
    }
}

resource "aws_subnet" "db_subnet_az2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.db_subnet_az2_cidr_block
    availability_zone = "${var.region}b"
    tags = {
        Name = "${var.name_keyword}-db-az2"
        "wg:purpose:serviceid" = "db"
    }
}

#
# cicd subnet1 (only one availability zone)
#

resource "aws_subnet" "cicd_subnet_az1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.cicd_subnet_az1_cidr_block
    availability_zone = "${var.region}a"
    tags = {
        Name = "${var.name_keyword}-cicd-az1"
        "wg:purpose:serviceid" = "cicd"
    }
}
