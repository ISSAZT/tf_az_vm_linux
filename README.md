 # Project Name

 Linux VM deployment on Azure using Terraform configuration

 ## Prerequisities
 - Azure account
 - Terraform
 - azure cli

 ## Log in to azure

 Authenticate with your Azure account by running the following command:
        
    az login
## Generate SSH Keys

Create a public/private key pair

     ssh-keygen -t rsa -b 4096 (Private key file Path)
 # Provisioning a virtual machine with terraform

  Initialize terraform

     terraform init

  Validate the config files 

     terraform validate
 
 Start the infrastructure plan

     terraform plan
 Deploying the VM on azure

     terraform apply -auto-approve
# Connect to the virtual machine

 Securely acces the virtual machine over ssh using the following command :

     ssh -i id_rsa adminuser@public_ip_address
# Delete the Linux VM (Ubuntu)

Permanently remove the virtual machine and its associated resources using Terraform

      terraform destroy
 
