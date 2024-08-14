#!/bin/bash

echo "*** Install Docker"
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "*** Add docker repository to Apt sources:"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

echo "*** Test Docker"
sudo docker run hello-world

echo "*** Install Ansible"
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "*** Setup semaphore"
mkdir /home/ubuntu/semaphore /home/ubuntu/semaphore/semaphore-mysql /home/ubuntu/semaphore/semaphore-playbook

git clone https://github.com/altairlage/ansible-semaphore-lab.git /home/ubuntu/ansible-semaphore-lab
cp /home/ubuntu/ansible-semaphore-lab/lab_deploy/ansible_lab/semaphore_install/docker-compose.yml /home/ubuntu/semaphore
cp /home/ubuntu/ansible-semaphore-lab/lab_deploy/ansible_lab/playbooks/* /home/ubuntu/semaphore/semaphore-playbook
docker-compose -f /home/ubuntu/semaphore/docker-compose.yml up --detach