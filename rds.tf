resource "aws_db_instance" "test-database" {
  identifier            = "test-${terraform.workspace}"
  allocated_storage     = 10
  max_allocated_storage = 30
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  name                  = "testdb"
  username              = "admin"
  password              = "Admin4321"
  parameter_group_name  = "default.mysql5.7"
  db_subnet_group_name  = aws_db_subnet_group.test-rds-subnetdb.id
  #security_group_names = [aws_security_group.websg.name]
  vpc_security_group_ids     = [aws_security_group.rds-sg.id]
  backup_window              = "01:00-01:30"
  auto_minor_version_upgrade = false
  skip_final_snapshot = true
  final_snapshot_identifier = "test-${terraform.workspace}"
  backup_retention_period = 0
  apply_immediately = true

  #skip_final_snapshot  = true
}
#db private subnet group
resource "aws_db_subnet_group" "test-rds-subnetdb" {
  name       = "rds-testsubnet"
  subnet_ids = aws_subnet.rdsprivat.*.id

  tags = {
    Name = "My DB subnet group"
  }
}