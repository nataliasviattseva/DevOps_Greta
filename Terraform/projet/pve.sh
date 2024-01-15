cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/releases/23.10/release/ubuntu-23.10-server-cloud>
sudo virt-customize -a ubuntu-23.10-server-cloudimg-amd64.img --install qemu-guest-ag>
sudo virt-customize -a ubuntu-23.10-server-cloudimg-amd64.img --root-password passwor>
sudo qm create 9999 --name "ubuntu2310.easyformer.fr" --memory 2048 --cores 2 --net0 >
sudo qm importdisk 9999 ubuntu-23.10-server-cloudimg-amd64.img local
sudo qm set 9999 --tags "template,ubuntu2310"
sudo qm set 9999 --scsihw virtio-scsi-pci --scsi0 local:9999/vm-9999-disk-0.raw
sudo qm set 9999 --boot c --bootdisk scsi0
sudo qm set 9999 --ide2 local:cloudinit
sudo qm set 9999 --serial0 socket --vga serial0
sudo qm set 9999 --agent enabled=1
sudo qm set 9999 --ipconfig0 ip=dhcp
sudo qm template 9999


