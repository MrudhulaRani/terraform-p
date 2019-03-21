output "vpc_cidr" {
  value = "${aws_vpc.vpc_tf.cidr_block}"
}
output "sn_cidr" {
  value = "${aws_subnet.sn-tf.cidr_block}"
}
output "public_ip" {
  value = "${aws_instance.vm-tf.public_ip}"
}