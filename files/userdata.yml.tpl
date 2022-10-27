#cloud-config
users:
  - name: adminuser
    ssh-authorized-keys:
      - ${ssh_key}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
network:
  config: disabled
write_files:
  - content: ${ssh_key}
    owner: adminuser:adminuser
    path: /home/adminuser/.ssh/authorized_keys
    permissions: '0600'