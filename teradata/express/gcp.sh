vm_name=${name:-teradata-vantage-express}
export zone=${zone:-asia-east2-c}
create-vm() {
  gcloud compute instances create ${vm_name} --zone=${zone} --machine-type=n2-custom-4-8192 --enable-nested-virtualization \
    --create-disk=boot=yes,device-name=ve-disk,image-project=ubuntu-os-cloud,image-family=ubuntu-2004-lts,size=70,type=pd-standard
  curl https://raw.githubusercontent.com/davidkhala/gcp-collections/main/compute/cli/gcloud.sh | bash -s wait4ssh ${vm_name}
}
backup-vm() {
  gcloud compute machine-images create $1 --source-instance=${vm_name}
}
ssh-vm() {
  gcloud compute ssh ${vm_name} --zone=${zone}
}
setup-vm() {
  gcloud compute ssh ${vm_name} --zone=${zone} --command="wget https://raw.githubusercontent.com/davidkhala/databases/main/teradata/express/teradata.sh;chmod +x ./teradata.sh; ./teradata.sh setup"
  curl https://raw.githubusercontent.com/davidkhala/gcp-collections/main/compute/cli/gcloud.sh | bash -s get-ip ${vm_name}
}
delete-vm() {
  gcloud compute instances delete ${vm_name} --zone=${zone} --quiet
}

$@
