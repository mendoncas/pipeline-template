resource "local_file" "inventory_file" {
  content = templatefile("./inventory.template",
    {
      ec2_public_ip = [module.ec2_instance_1.public_ip, module.ec2_instance_2.public_ip],
    }
  )
  filename = "./inventory"
}
#resource "local_file" "lb_public_ip" {
#  content = module.vpc.nat_public_ips
#  filename = "./public_ips"
#}