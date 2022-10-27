Tentative de template avec l'image AlmaLinux 9 Generic Cloud (format qcow2) :
* Conversion de l'image au format vmdk: `qemu-img.exe convert -O vmdk ".\AlmaLinux-9-GenericCloud-9.0-20220831.x86_64.qcow2" ".\AlmaLinux-9-GenericCloud-9.0-20220831.x86_64.vmdk"`
* Upload sur le datastore
* Création d'une VM sans disque vierge mais avec le vmdk upload
* Conversion en modèle
* Utilisation dans Terraform avec la fonction de clonage du provider vsphere
    * La section de conf customize ne passe pas car les invités vmware ne sont pas installés sur l'image
    * Impossible de les installer sans faire une 1ere conf cloud init puisque le login par mdp est désactivé par défaut
    * La 1ere tentative de conf avec userdata et metadata (user, ssh et ip) n'a rien donné.

Template avec l'image AlmaLinux 9 DVD (format iso)
* Upload sur le datastore
* Création d'une VM avec un disque vierge + l'ISO séléctionné dans le lecteur attaché
* Allumage + installation OS sur le disque (voir screenshot)
    * Compte root et almalinux (admin) configurés
    * Installation mode serveur (non graphique) avec client nfs et agents hyperviseur cochés
    * !!! upgrade cloud-init (support de la datasource GuestInfo VMware natif en 21.3, 21.1 sur AlmaLinux 9.0 par défaut). dnf install avec le paquet de https://centos.pkgs.org/9-stream/centos-appstream-aarch64/cloud-init-22.1-6.el9.noarch.rpm.html
    * !!! pas suffisant. Visiblement la section de conf "customize" écrase tout le reste, puisque lorsqu'on l'enlève, les guestinfo.* sont bien prises en compte. Pas forcément un problème puisque toute la conf peut être faite avec cloud-init via guestinfo.*, et donc on peut se passer de "customize", **et donc même peut être des vmware tools !**
* Conversion en modèle