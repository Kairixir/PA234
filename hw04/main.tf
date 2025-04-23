# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {

}

resource "openstack_networking_port_v2" "vm_port" {
  network_id         = var.network_id
  security_group_ids = [openstack_networking_secgroup_v2.secgroup_1.id]
}

resource "openstack_compute_instance_v2" "vm" {
  name        = var.vm_name
  image_id    = var.image_id
  flavor_name = var.flavor_name

  key_pair = var.key_pair

  security_groups = [openstack_networking_secgroup_v2.secgroup_1.name]

  user_data = <<-EOF
	#!/bin/bash
	apt-get update -y
	apt-get install apache2 -y
	# Create the index.html file with Name and UCO
	cat <<EOT > /var/www/html/index.html
	Name: Sevcik Ondrej, UCO: 485230
	EOT
	systemctl restart apache2
  EOF

  network {
    port = openstack_networking_port_v2.vm_port.id
  }

}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = var.floating_ip_pool
}

resource "openstack_networking_floatingip_associate_v2" "fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  port_id     = openstack_networking_port_v2.vm_port.id
}


resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name = "secgroup_1"

}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}


