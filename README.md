# tf-aws-redis-enterprise-cluster
Create a Redis Enterprise Cluster from scratch on AWS using Terraform.
Redis Enterprise Cluster of 3+ nodes accessible via FQDN, username, and password.
Cluster creation options to create either Redis on RAM, Redis on Flash, and or Rack Zone Aware cluster.

Create an optional test node or nodes with Redis and Memtier installed.

 Optional: Configure Prometheus and Grafana on the Test node for advanced monitoring at the Redis Enterprise cluster, node, and database levels.

* Example of deployment: (user can choose any number of RE nodes and any number of tester nodes to deploy)
![Alt text](image/RE-TF-Deploy.jpg?raw=true "Title")

## Terraform Modules to provision the following:
* New VPC 
* Any number of Redis Enterprise nodes and install Redis Enterprise software (ubuntu 18.04)
* Test node with Redis and Memtier installed
* Prometheus and Grafana node configured for advanced monitoring
* DNS (NS and A records for Redis Enterprise nodes)
* Create and Join Redis Enterprise cluster
    * cluster creation options: redis on ram, redis on flash, and or rack zone awareness

### !!!! Requirements !!!
* Redis Enterprise Software (**Ubuntu 18.04**)
* R53 DNS_hosted_zone_id *(if you do not have one already, go get a domain name on Route53)*
* aws access key and secret key
* an **AWS generated** SSH key for the region you are creating the cluster
    - *you must chmod 400 the key before use*

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
 3.  Install `ansible` via `pip3 install ansible` to your local machine.
     - A terraform local-exec provisioner is used to invoke a local executable and run the ansible playbooks, so ansible must be installed on your local machine and the path needs to be updated.
     - example steps:

    ```
    # create virtual environment
    python3 -m venv ./venv
    source ./venv/bin/activate
    # Check if you have pip
    python3 -m pip -V
    # Install ansible and check if it is in path
    python3 -m pip install --user ansible
    # check if ansible is installed:
    ansible --version
    # If it tells you the path needs to be updated, update it
    echo $PATH
    export PATH=$PATH:/path/to/directory
    # example: export PATH=$PATH:/Users/username/Library/Python/3.8/bin
    # (*make sure you choose the correct python version you are using*)
    # you can check if its in the path of your directory by typing "ansible-playbook" and seeing if the command exists
    ```

* (*for more information on how to install ansible to your local machine:*) ([link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html))

## Getting Started:
Now that you have terraform and ansible installed you can get started provisioning your RE cluster on AWS using terraform modules.

Since creating a Redis Enterprise cluster from scratch takes many components (VPC, DNS, Nodes, and creating the cluster via REST API) it is best to break these up into invidivual `terraform modules`. That way if a user already has a pre-existing VPC, they can utilize their existing VPC instead of creating a brand new one.

There are two important files to understand. `modules.tf` and `terraform.tfvars.example`.
* `modules.tf` contains the following: 
    - `vpc module` (creates new VPC)
    - `node module` (creates and provisions ubuntu 18.04 vms with RE software installed)
    - `tester-nodes` (creates test nodes with Redis and Memtier installed)
        - *If you do not want to provision tester nodes, comment this module out*
    - `prometheus-node` (configures the test node with prometheus and grafana for advanced monitoring on the Redis Enterprise Cluster)
        - *If you do not want to provision the prometheus and grafana node, comment this module out*
    - `dns module` (creates R53 DNS with NS record and A records), 
    - `create-cluster module` (uses ansible to create and join the RE cluster via REST API)
    * *the individual modules can contains inputs from previously generated from run modules.*
    - example:
    ```
    # either use the variables filled in from `.tfvars` as seen below
    module "vpc" {
    source             = "./modules/vpc"
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region
    base_name          = var.base_name
    vpc_cidr           = var.vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs         = var.subnet_azs
    }

    # or enter in your own values:
    module "vpc" {
    source             = "./modules/vpc"
    aws_creds          = ["accessxxxx","secretxxxxxx"]
    owner              = "redisuser"
    region             = "us-west-2"
    base_name          = "redis-user-tf"
    vpc_cidr           = "10.0.0.0/16"
    subnet_cidr_blocks = ["10.0.0.0/24","10.0.16.0/24","10.0.32.0/24"]
    subnet_azs         = ["us-west-2a","us-west-2b","us-west-2c"]
    }
    ```
* `terraform.tfvars.example`:
    - An example of a terraform variable managment file. The variables in this file are utilized as inputs into the module file. You can choose to use these or hardcode your own inputs in the modules file.
    - to use this file you need to change it from `terraform.tfvars.example` to simply `terraform.tfvars` then enter in your own inputs.

### Instructions for Use:
1. Open repo in VS code
2. Copy the variables template. or rename it `terraform.tfvars`
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```
3. Update `terraform.tfvars` variable inputs with your own inputs
    - Some require user input, some will will use a default value if none is given
4. Now you are ready to go!
    * Open a terminal in VS Code:
    ```bash
    # create virtual environment
    python3 -m venv ./venv
    source ./venv/bin/activate
    # ensure ansible is in path
    ansible --version
    # run terraform commands
    terraform init
    terraform plan
    terraform apply
    # Enter a value: yes
    # can take around 10 minutes to provision cluster
    ```
5. After a successful run there should be outputs showing the FQDN of your RE cluster and the username and password. (*you may need to scroll up a little*)
 - example output:
 ```
 Outputs:
dns-ns-record-name = "https://redis-tf-us-west-2-cluster.mydomain.com"
grafana_password = "secret"
grafana_url = "http://100.20.72.136:3000"
grafana_username = "admin"
re-cluster-password = "admin"
re-cluster-url = "https://redis-tf-us-west-2-cluster.mydomain.com:8443"
re-cluster-username = "admin@admin.com"

 ```

## Cleanup

Remove the resources that were created.

```bash
  terraform destroy
  # Enter a value: yes
```

## Additional Helpful Repos
Utilized a lot of information from the following repos to create this:

Terraform and Ansible repo for installing RE on ubuntu 18.04 nodes:
* https://github.com/Redislabs-Solution-Architects/tfmodule-aws-redis-enterprise

Ansible Redis PS Repo:
* https://github.com/Redislabs-Solution-Architects/ansible-redis