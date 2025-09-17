variable "openstack_cloud" {
  description = "Nom du cloud dans clouds.yaml"
  type        = string
}

variable "ssh_key_name" {
  description = "Nom de la clé SSH importée dans OpenStack"
  type        = string
}



variable "sysadmin_pub_key_path" {
  description = "Chemin vers la clé publique de l'utilisateur sysadmin"
  type        = string
}

variable "devops_aya_pub_key_path" {
  description = "Chemin vers la clé publique de l'utilisateur devops-aya"
  type        = string
}

variable "terraform_bot_pub_key_path" {
  description = "Chemin vers la clé publique du bot Terraform"
  type        = string
}

variable "vm_flavor" {
  description = "Flavor de la VM"
  type        = string
}

variable "vm_image" {
  description = "Nom de l'image pour la VM"
  type        = string
}

variable "floating_ip_pool" {
  description = "Pool d'IP flottantes"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR autorisé pour SSH et Semaphore"
  type        = string
}
