#cloud-config
package_update: true
package_upgrade: true
packages:
  - unzip
  - git
  - curl
  - wget
  - software-properties-common
  - gnupg2
  - lsb-release
  - python3-pip
  - ufw
  - unattended-upgrades
  - ansible

users:
  # Sysadmin
  - name: sysadmin
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${sysadmin_public_key}

  # DevOps Aya
  - name: devops-aya
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${devops_aya_public_key}

  # Terraform bot
  - name: terraform-bot
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${terraform_bot_public_key}


runcmd:
  # Firewall
  - ufw --force reset
  - ufw default deny incoming
  - ufw default allow outgoing
  - ufw allow from ${admin_cidr} to any port 22 proto tcp
  - ufw allow 80/tcp
  - ufw allow 443/tcp
  - ufw allow from ${admin_cidr} to any port 3000 proto tcp
  - ufw --force enable

  # Activer mises à jour automatiques
  - dpkg-reconfigure -f noninteractive unattended-upgrades

  # Installer Terraform 1.13.2
  - sleep 80
  - wget https://releases.hashicorp.com/terraform/1.13.2/terraform_1.13.2_linux_amd64.zip -O /tmp/terraform.zip
  - unzip /tmp/terraform.zip -d /tmp
  - sudo mv /tmp/terraform /usr/local/bin/terraform
  - sudo chmod +x /usr/local/bin/terraform
  - /usr/local/bin/terraform -version

  # Installer Ansible
  - sudo apt-add-repository --yes --update ppa:ansible/ansible
  - sudo apt-get install -y ansible
  - ansible --version
