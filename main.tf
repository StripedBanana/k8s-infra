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

# Init cloud init file from template
data "template_file" "userdata" {
  template = file("files/userdata.yml.tpl")

  vars = {
    ssh_key = tls_private_key.ssh_key.public_key_openssh
  }
}

data "template_file" "metadata" {
  template = file("files/metadata.yml.tpl")
}

resource "vsphere_virtual_machine" "vm-master" {
  depends_on = [data.vsphere_network.network, data.template_file.userdata]

  name             = "Master-K8S-0"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  firmware         = "efi"


  nested_hv_enabled = true

  # Requirement of kubespray
  enable_disk_uuid = true

  network_interface {
    network_id = data.vsphere_network.network.id
  }


  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    /* customize {
      linux_options {
        host_name = "master-k8s-0"
        domain    = "localhost"
      }

      network_interface {
        ipv4_address = "192.168.1.152"
        ipv4_netmask = 24
      }

      dns_server_list = ["192.168.1.1"]
      ipv4_gateway    = "192.168.1.1"
    } */
  }

  # Send cloud-init config with ssh conf
  extra_config = {
    "guestinfo.metadata"          = base64encode(data.template_file.metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.userdata.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }
}
