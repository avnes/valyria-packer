#!/bin/bash

mkdir -p ~/artifacts
mkdir -p sshkeys
ssh-keygen -q -t rsa -N '' -C 'valyria-linux-key' -f sshkeys/id_rsa
cp sshkeys/id_rsa ~/.ssh/id_valyria-linux-key
cp sshkeys/id_rsa.pub ~/.ssh/id_valyria-linux-key.pub
SSH_RSA_TOKEN=$(cat sshkeys/id_rsa.pub)
sed -i "s#SSH-RSA-TOKEN#$SSH_RSA_TOKEN#g" http/fedora34-kickstart.cfg
/usr/bin/packer init -upgrade
/usr/bin/packer build fedora34.pkr.hcl
sed -i "s#$SSH_RSA_TOKEN#SSH-RSA-TOKEN#g" http/fedora34-kickstart.cfg
cp -R artifacts/* ~/artifacts
