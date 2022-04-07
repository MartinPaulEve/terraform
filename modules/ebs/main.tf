variable "device_name" {default=["/dev/sdd"]}
variable "ec2_ebs_volume_count" {default=1}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = var.instances[0][0].availability_zone
  size = 2
  tags = {
    Name = "myebs1"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdd"
  volume_id = aws_ebs_volume.ebs_volume.id
  instance_id = var.instances[0][0].id
}
