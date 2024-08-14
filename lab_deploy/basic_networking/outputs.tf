output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_az1_id" {
  description = "The public_subnet_az1 ID"
  value       = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  description = "The public_subnet_az2 ID"
  value       = aws_subnet.public_subnet_az2.id
}

output "middleware_subnet_az1_id" {
  description = "The middleware_subnet_az1 ID"
  value       = aws_subnet.middleware_subnet_az1.id
}

output "middleware_subnet_az2_id" {
  description = "The middleware_subnet_az2 ID"
  value       = aws_subnet.middleware_subnet_az2.id
}

output "db_subnet_az1_id" {
  description = "The db_subnet_az1 ID"
  value       = aws_subnet.db_subnet_az1
}

output "db_subnet_az2_id" {
  description = "The db_subnet_az2 ID"
  value       = aws_subnet.db_subnet_az2
}

output "cicd_subnet_az1_id" {
  description = "The cicd_subnet_az1 ID"
  value       = aws_subnet.cicd_subnet_az1.id
}
