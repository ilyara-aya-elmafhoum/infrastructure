terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "openstack" {
  cloud = var.openstack_cloud
}


# Security Group

resource "openstack_networking_secgroup_v2" "ai_sg" {
  name        = "ai-secgroup"
  description = "Règles pour la machine AI"
}

resource "openstack_networking_secgroup_rule_v2" "ai_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.ai_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "ai_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ai_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "ai_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ai_sg.id
}


# Variables de utilisateurs pour Cloud-init

locals {
  ai_cloudinit_vars = {
    sysadmin_public_key      = file(var.sysadmin_pub_key_path)
    devops_aya_public_key    = file(var.devops_aya_pub_key_path)
    terraform_bot_public_key = file(var.terraform_bot_pub_key_path)
    ihssane_public_key       = file(var.ihssane_pub_key_path)
    admin_cidr               = var.admin_cidr
  }
}


# Instance AI

resource "openstack_compute_instance_v2" "machine_ai" {
  name        = "machine-ai"
  flavor_name = var.vm_flavor
  image_name  = var.vm_image
  key_pair    = var.ssh_key_name

  network {
    name = "ext-net1"
  }

  security_groups = [
    openstack_networking_secgroup_v2.ai_sg.name
  ]

  user_data = templatefile("${path.module}/cloudinit.tpl", local.ai_cloudinit_vars)
}


# Floating IP

resource "openstack_networking_floatingip_v2" "ai_fip" {
  pool = var.floating_ip_pool
}

resource "openstack_networking_floatingip_associate_v2" "ai_assoc" {
  floating_ip = openstack_networking_floatingip_v2.ai_fip.address
  port_id     = openstack_compute_instance_v2.machine_ai.network.0.port
}
