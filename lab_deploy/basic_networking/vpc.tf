#
# Vpc common resources
#

resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr_block
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.name_keyword}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.name_keyword}-igw"
    }
}

resource "aws_eip" "nat_eip_az1" {
    tags = {
        Name = "${var.name_keyword}-natgateway-az1-eip"
    }
}

resource "aws_nat_gateway" "nat_az1" {
    allocation_id       = aws_eip.nat_eip_az1.id
    subnet_id           = aws_subnet.public_subnet_az1.id
    connectivity_type   = "public"

    depends_on          = [aws_internet_gateway.igw]

    tags = {
        Name = "${var.name_keyword}-natgateway-az1"
    }
}

resource "aws_eip" "nat_eip_az2" {
    tags = {
        Name = "${var.name_keyword}-natgateway-az2-eip"
    }
}

resource "aws_nat_gateway" "nat_az2" {
    allocation_id       = aws_eip.nat_eip_az2.id
    subnet_id           = aws_subnet.public_subnet_az2.id
    connectivity_type   = "public"

    depends_on          = [aws_internet_gateway.igw]

    tags = {
        Name = "${var.name_keyword}-natgateway-az2"
    }

}

#
# Route tables
#
resource "aws_route_table" "vpc_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.name_keyword}-rt"
    }
}

resource "aws_route_table" "public_az1_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.name_keyword}-public-az1-rt"
    }
}

resource "aws_route_table" "public_az2_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.name_keyword}-public-az2-rt"
    }
}

resource "aws_route_table" "middleware_subnet_az1_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_az1.id
    }

    tags = {
        Name = "${var.name_keyword}-middleware-az1-rt"
    }
}

resource "aws_route_table" "middleware_subnet_az2_rt" {
    vpc_id = aws_vpc.vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_az2.id
    }
    
    tags = {
        Name = "${var.name_keyword}-middleware-az2-rt"
    }
}

resource "aws_route_table" "db_subnet_az1_rt" {
    vpc_id = aws_vpc.vpc.id
    
    tags = {
        Name = "${var.name_keyword}-db-az1-rt"
    }
}

resource "aws_route_table" "db_subnet_az2_rt" {
    vpc_id = aws_vpc.vpc.id
    
    tags = {
        Name = "${var.name_keyword}-db-az2-rt"
    }
}

resource "aws_route_table" "cicd_subnet_rt" {
    vpc_id = aws_vpc.vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_az1.id
    }
    
    tags = {
        Name = "${var.name_keyword}-cicd-rt"
    }
}

#
# Associations
#
resource "aws_main_route_table_association" "main_vpc_assoc" {
    vpc_id          = aws_vpc.vpc.id
    route_table_id  = aws_route_table.vpc_rt.id
}

resource "aws_route_table_association" "public_az1_rt_assoc" {
    route_table_id  = aws_route_table.public_az1_rt.id
    subnet_id       = aws_subnet.public_subnet_az1.id
}

resource "aws_route_table_association" "public_az2_rt_assoc" {
    route_table_id  = aws_route_table.public_az2_rt.id
    subnet_id       = aws_subnet.public_subnet_az2.id
}

resource "aws_route_table_association" "middleware_az1_rt_assoc" {
    route_table_id  = aws_route_table.middleware_subnet_az1_rt.id
    subnet_id       = aws_subnet.middleware_subnet_az1.id
}

resource "aws_route_table_association" "middleware_az2_rt_assoc" {
    route_table_id = aws_route_table.middleware_subnet_az2_rt.id
    subnet_id      = aws_subnet.middleware_subnet_az2.id
}

resource "aws_route_table_association" "db_az1_rt_assoc" {
    route_table_id = aws_route_table.db_subnet_az1_rt.id
    subnet_id      = aws_subnet.db_subnet_az1.id
}

resource "aws_route_table_association" "db_az2_rt_assoc" {
    route_table_id = aws_route_table.db_subnet_az2_rt.id
    subnet_id      = aws_subnet.db_subnet_az2.id
}

resource "aws_route_table_association" "cicd_az1_rt_assoc" {
    route_table_id = aws_route_table.cicd_subnet_rt.id
    subnet_id      = aws_subnet.cicd_subnet_az1.id
}


#
# Other resources
#

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
    name              = "${var.name_keyword}-vpc-flow-logs"
    # retention_in_days = 1
    skip_destroy      = false
    depends_on        = [aws_vpc.vpc]
}

resource "aws_iam_role" "vpc_flow_logs" {
    name = "${var.name_keyword}-${var.region}-vpc-flow-logs"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "vpc-flow-logs.amazonaws.com"
                }
            },
        ]
    })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
    name = "${var.name_keyword}-${var.region}-vpc-flow-logs"
    role = aws_iam_role.vpc_flow_logs.id
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:DescribeLogGroups",
                    "logs:DescribeLogStreams",
                    "logs:PutLogEvents"
                ]
                Effect   = "Allow"
                Resource = "*"
            },
        ]
    })
}

resource "aws_flow_log" "vpc_flow_logs" {
    iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
    log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
    traffic_type    = "ALL"
    vpc_id          = aws_vpc.vpc.id
}

# resource "aws_vpc_dhcp_options" "dns_resolver" {
#     domain_name_servers = ["AmazonProvidedDNS"]
#     netbios_node_type   = 2
#     tags = {
#         Name = "${var.name_keyword}-core"
#     }
# }

# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
#     vpc_id          = aws_vpc.vpc.id
#     dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
# }
