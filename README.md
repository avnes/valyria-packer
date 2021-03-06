# :warning: This repository has been archived, and is no longer maintained :warning:

# valyria-packer

Used to create kvm/qemu/libvirt templates that can be automated with Vagrant. These will eventually be used to automate the infrastructure for my playground Kubernetes cluster at home running <https://k0sproject.io/>

## Credits

Please note that this repository is heavily based on <https://github.com/goffinet/packer-kvm/>, and the Fedora 34 template I was using initially has been submitted back to this upstream project.

## Security

This repository contains some dummy passwords for user and root account. This is intentional. I will have other automation to replace these passwords when hardening the infrastructure.

## Requirements

### Install virtualization software

Please note that these instructions are written for Fedora.

```bash
sudo dnf install libvirt cockpit cockpit-machines
sudo systemctl enable cockpit.socket --now
sudo systemctl enable libvirtd --now
sudo firewall-cmd --zone=public --add-service=cockpit --permanent
sudo firewall-cmd --reload
```

### Install Packer

```bash
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install -y packer
```

## Build template

Tip: Create a sha512 encrypted root password to put into http/fedora34-kickstart.cfg:

```bash
python -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'
```

```bash
cd valyria-packer
./build.sh
```
