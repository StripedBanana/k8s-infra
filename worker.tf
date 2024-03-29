resource "vsphere_virtual_machine" "vm-worker" {
  depends_on = [data.vsphere_network.network]

  for_each         = var.vm_worker_set
  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.vm_worker_cpus
  memory           = var.vm_worker_memory
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

  disk {
    label            = "disk1"
    size             = "50"
    eagerly_scrub    = false
    thin_provisioned = true
    unit_number      = 1
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  # Send cloud-init config with ssh conf
  extra_config = {
    "guestinfo.metadata" = base64encode(
      templatefile("${path.module}/files/metadata.yml.tftpl",
        { ip       = each.value,
          gateway  = var.dns_server,
          dns      = var.dns_server,
          hostname = each.key
        }
      )
    )
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata" = base64encode(
      templatefile("${path.module}/files/userdata.yml.tftpl",
        { ssh_key = tls_private_key.ssh_key.public_key_openssh }
      )
    )
    "guestinfo.userdata.encoding" = "base64"
  }
}
