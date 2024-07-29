module "app" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-live"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  subnet_id              = local.public_subnet_id
  tags = merge(
    var.common_tags,
    {
      Component = "app"
    },
    {
      Name = "${local.ec2_name}-app"
    }
  )
}

resource "null_resource" "docker" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.app.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.app.public_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

 provisioner "file" {
    source      = "Dockerfile"
    destination = "/tmp/Dockerfile"
  }

provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh app ${var.environment}"
    ]
  }
}