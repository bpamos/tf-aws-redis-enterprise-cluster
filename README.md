# tf-aws-redis-enterprise-cluster
Create a Redis Enterprise Cluster using Terraform




local-exec is where you execute commands from your local machine.
This means you need to have ansible installed on your local machine and the path needs to be updated.

Steps:

create virtual environment
* python3 -m venv ./venv

Check if you have pip

* python3 -m pip -V

Install ansible and check if it is in path

* python3 -m pip install --user ansible

check ansible version:

* ansible --version
If it tells you the path needs to be updated, update it

* echo $PATH

* export PATH=$PATH:/path/to/directory

* you can check if its in the path of your directory by typing "ansible-playbook" and seeing if the command exists

Run terraform init, plan, apply

for more information on install ansible to your local machine:
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html