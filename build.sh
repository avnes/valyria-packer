#!/bin/bash

FEDORA_VERSION=34

mkdir -p ~/artifacts
mkdir -p sshkeys

# Remove local artifacts directory if it exists
if [[ -d "artifacts" ]]; then
    rm -rf artifacts
fi

ssh-keygen -q -t rsa -N '' -C 'valyria-linux-key' -f sshkeys/id_rsa
cp sshkeys/id_rsa ~/.ssh/id_valyria-linux-key
cp sshkeys/id_rsa.pub ~/.ssh/id_valyria-linux-key.pub
SSH_RSA_TOKEN=$(cat sshkeys/id_rsa.pub)
sed -i "s#SSH-RSA-TOKEN#$SSH_RSA_TOKEN#g" http/fedora${FEDORA_VERSION}-kickstart.cfg
/usr/bin/packer init -upgrade fedora${FEDORA_VERSION}.pkr.hcl
/usr/bin/packer build fedora${FEDORA_VERSION}.pkr.hcl
sed -i "s#$SSH_RSA_TOKEN#SSH-RSA-TOKEN#g" http/fedora${FEDORA_VERSION}-kickstart.cfg
cp -R artifacts/* ~/artifacts
