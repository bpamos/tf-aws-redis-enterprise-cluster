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
    - *you can also follow these instructions to install terraform* ([link](https://learn.hashicorp.com/tutorials/terraform/install-cli))
 3.  Install `ansible` via `pip3 install ansible` to your local machine   
    - A terraform local-exec provisioner is used to invoke a local executable and run the ansible playbooks, so ansible must be installed on your local machine and the path needs to be updated.
    - example steps:
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
    ### you can check if its in the path of your directory by typing "ansible-playbook" and seeing if the command exists
    ```
    
    - for more information on install ansible to your local machine: ([link]https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))

## Getting Started:
Now that you have terraform and ansbile installed you can get started provisioning your RE cluster on AWS using terraform modules.

Since creating a Redis Enterprise cluster from scratch takes many components (VPC, DNS, Nodes, and creating the cluster via REST API) it is best to break these up into invidivual `terraform modules`. That way if a user already has a pre-existing VPC, they can utilize that VPC instead of creating a brand new VPC.

There are two important files to understand. `modules.tf` and `terraform.tfvars.example`.
* `modules.tf`: Contains a VPC module (creates new VPC), Node module (creates and provisions ubuntu 18.04 vms with RE software installed or test vms with Redis and Memtier installed), DNS module (creates R53 DNS with NS record and A records), and a `create-cluster` module (uses ansible to create and join the RE cluster via REST API)

1. Open VS code and a new VS code terminal

Copy the variables template. or rename it 'terraform.tfvars'
```bash
  cp terraform.tfvars.example terraform.tfvars
```
Update terraform.tfvars with your [secrets](#secrets)

* Open a terminal in VS Code:
```bash
  terraform init
  terraform plan
  terraform apply
```


## Cleanup

Remove the resources that were created.

```bash
  terraform destroy
```