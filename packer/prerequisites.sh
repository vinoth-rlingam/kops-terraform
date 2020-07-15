#Installing kops
echo "Installing kops...."
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

#Installing kubectl
echo "Installing kubectl...."
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#Installing aws client
echo "Installing aws cli...."
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
export PATH=~/.local/bin:$PATH
source ~/.bash_profile
pip3 --version
pip3 install awscli --upgrade --user

# Installing Terraform
echo "Installing Terraform..."
sudo mkdir terraform && cd terraform
sudo wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
sudo unzip terraform_0.12.28_linux_amd64.zip
sudo mv /home/ec2-user/terraform/terraform /usr/local/bin

#Installing jq
echo "Installing jq..."
sudo wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
sudo chmod +x ./jq
sudo cp jq /usr/bin
