# tf-aws-redis-enterprise-cluster
Create a Redis Enterprise Cluster from scratch on AWS using Terraform.

## Terraform Modules to provision the following:
* New VPC 
* Redis Enterprise nodes and install Redis Enterprise software (ubuntu 18.04)
* Test node with Redis and Memtier installed
* DNS (NS and A records for Redis Enterprise nodes)
* Create and Join Redis Enterprise cluster 

### Prerequisites
* aws-cli (aws access key and secret key)
* terraform installed on local machine
* ansible installed on local machine
* VS Code

#### Prerequisites (detailed instructions)
1.  Install `aws-cli` on your local machine and run `aws configure` ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)) to set your access and secret key.
    - If using an aws-cli profile other than `default`, `main.tf` may need to edited under the `provider "aws"` block to reflect the correct `aws-cli` profile.
2.  Download the `terraform` binary for your operating system ([link](https://www.terraform.io/downloads.html)), and make sure the binary is in your `PATH` environment variable.
    - MacOSX users:
        - (if you see an error saying something about security settings follow these instructions), ([link](https://github.com/hashicorp/terraform/issues/23033))
        - Just control click the terraform unix executable and click open. 
    - you can also follow these instructions to install terraform ([link](https://learn.hashicorp.com/tutorials/terraform/install-cli))
 3.  Install `ansible` via `pip3 install ansible` to your local machine   
* Terraform local-exec provisioner invokes a local executable, so ansible must be installed on your local machine and the path needs to be updated.
* example steps:
    ```
    # create virtual environment
    python3 -m venv ./venv
    # Check if you have pip
    python3 -m pip -V
    # Install ansible and check if it is in path
    python3 -m pip install --user ansible
    # check if ansible is installed:
    ansible --version
    # If it tells you the path needs to be updated, update it
    echo $PATH
    export PATH=$PATH:/path/to/directory
    ```
    * you can check if its in the path of your directory by typing "ansible-playbook" and seeing if the command exists


#### Next


Run terraform init, plan, apply

for more information on install ansible to your local machine:
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html