data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "RHEL-9-DevOps-Practice"
  owners           = ["972946952941"]
}

data "aws_security_group" "security_group" {
  name = "allow-all"
}