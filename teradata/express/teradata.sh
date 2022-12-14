export VM_IMAGE_DIR="/home/${USER}/VantageExpress17.20_Sles12"
apt-install() {
    sudo apt update && sudo apt-get install virtualbox -y
}
download() {
    wget -O $VM_IMAGE_DIR/vbox.ova https://objectstorage.ap-singapore-1.oraclecloud.com/n/cn9yc2hk0gzg/b/installation-binary/o/teradata%2FVantageExpress_VirtualBoxAppliance_17.20_Sles12_20220819081111.ova
    wget -O $VM_IMAGE_DIR/disk1.vmdk https://objectstorage.ap-singapore-1.oraclecloud.com/n/cn9yc2hk0gzg/b/installation-binary/o/teradata%2FVantageExpress17.20_Sles12-disk1.vmdk
    wget -O $VM_IMAGE_DIR/disk2.vmdk https://objectstorage.ap-singapore-1.oraclecloud.com/n/cn9yc2hk0gzg/b/installation-binary/o/teradata%2FVantageExpress17.20_Sles12-disk2.vmdk
    wget -O $VM_IMAGE_DIR/disk3.vmdk https://objectstorage.ap-singapore-1.oraclecloud.com/n/cn9yc2hk0gzg/b/installation-binary/o/teradata%2FVantageExpress17.20_Sles12-disk3.vmdk
}
start-detach() {

    DEFAULT_VM_NAME="vantage-express"
    VM_NAME="${VM_NAME:-$DEFAULT_VM_NAME}"
    vboxmanage createvm --name "$VM_NAME" --register --ostype openSUSE_64
    vboxmanage modifyvm "$VM_NAME" --ioapic on --memory 6000 --vram 128 --nic1 nat --cpus 4
    vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
    vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$(find $VM_IMAGE_DIR -name '*disk1*')"
    vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium "$(find $VM_IMAGE_DIR -name '*disk2*')"
    vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 2 --device 0 --type hdd --medium "$(find $VM_IMAGE_DIR -name '*disk3*')"
    vboxmanage modifyvm "$VM_NAME" --natpf1 "tdssh,tcp,,4422,,22"
    vboxmanage modifyvm "$VM_NAME" --natpf1 "tddb,tcp,,1025,,1025"
    vboxmanage startvm "$VM_NAME" --type headless
    vboxmanage controlvm "$VM_NAME" keyboardputscancode 1c 1c
}
login-vm() {
    ssh -p 4422 root@localhost
}
$@
