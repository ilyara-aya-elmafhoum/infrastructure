variable "openstack_cloud" {
  description = "Nom du cloud dans clouds.yaml"
  type        = string
}

variable "ssh_key_name" {
  description = "Nom de la key pair SSH utilisée pour les VM"
  type        = string
}

variable "devops_aya_pub_key_path" {
  description = "Chemin de la clé publique SSH pour devops"
  type        = string
}

variable "sysadmin_pub_key_path" {
  description = "Chemin de la clé publique SSH pour sysadmin"
  type        = string
}

variable "terraform_bot_pub_key_path" {
  description = "Chemin de la clé publique SSH pour le bot terraform"
  type        = string
}

variable "ihssane_pub_key_path" {
  description = "Chemin de la clé publique SSH pour Ihssane"
  type        = string
}

variable "vm_flavor" {
  description = "Flavor de la VM"
  type        = string
}

variable "vm_image" {
  description = "Nom de l'image à utiliser pour les VMs"
  type        = string
}

variable "floating_ip_pool" {
  description = "Pool d'IP flottantes"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR des IP autorisées à se connecter en SSH"
  type        = string
}
