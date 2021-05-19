locals {
  key_name = "test"
  key_path = "test.pem"
}

resource "aws_instance" "frontend" {
  # aws_spot_instabce_request for spot instance
  ami = "${var.AMI}"
  instance_type = "${var.INSTANCE_TYPE}"
  key_name = local.key_name
  # spot_type = "one-time"  aws_spot_instance_request
  tags = {
    "Name" = "${var.COMPONENT}-Server"
  }

connection {
  host = aws_instance.frontend.public_ip
  type = "ssh"
  user = "root"
  private_key = file("${local.key_path}")
  #private_key = file("${path.module}")
  #password = "${var.PASSWORD}"
}

provisioner "remote-exec" {
  inline = [ "set-hostname ${var.COMPONENT}" ]
}

provisioner "local-exec" {
  command = "ansible-playbook -i ${aws_instance.frontend.public_ip}, --private-key test.pem ${var.COMPONENT}.yml"
}
}

resource "aws_route53_record" "frontend" {
  zone_id = "${var.R53_ZONE_ID}"
  name = "${var.COMPONENT}.${var.DOMAIN}"
  type = "A"
  ttl = "300"
  records = [ aws_instance.frontend.public_ip ]
}

output "Frontend_PIP" {
  value = aws_instance.frontend.public_ip
}