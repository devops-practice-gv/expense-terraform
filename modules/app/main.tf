
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.security_group.id]

  tags = {
    Name = var.component
  }
}

resource "null_resource" "ansible" {
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_pass
    host     = aws_instance.instance.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo pip3.11 install ansible",
      "ifconfig",
      "ansible-pull -i localhost, -U https://github.com/devops-practice-gv/expense-ansible expense.yml -e env=${var.env} -e role_name=${var.component} "
    ]
  }

}

resource "aws_route53_record" "record" {
  name    = "${var.component}-${var.env}"
  type    = "A"
  zone_id = var.zone_id
  records = [aws_instance.instance.private_ip]
  ttl     = 30
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}