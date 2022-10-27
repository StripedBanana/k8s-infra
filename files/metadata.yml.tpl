network:
  version: 2
  ethernets:
    ens192:
      dhcp4: false
      addresses:
        - 192.168.1.152/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 192.168.1.1
local-hostname: master-k8s-0
instance-id: master-k8s-0