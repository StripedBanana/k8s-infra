output "ssh_key" {
    description = "Clé SSH configuré sur les VMs avec cloud-init"
    value = nonsensitive(tls_private_key.ssh_key.private_key_openssh)
}