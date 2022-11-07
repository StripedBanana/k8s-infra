data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "cluster-01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Provision VMs in vSphere
data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Create key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "null_resource" "test_ssh" {

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = "192.168.1.152"
  }

  provisioner "remote-exec" {
    inline = [
      "df -H",
      "pwd",
      "ls /home"
    ]
  }

}
