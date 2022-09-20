#source ./source.sh

ansible-playbook -i $inventory_file redislabs-create-cluster.yaml -e @$extra_vars -e @$group_vars 

ansible-playbook -i ./modules/ps-re-cluster/inventories/test-inventory.ini ./modules/ps-re-cluster/redislabs-create-cluster.yaml --private-key ~/desktop/keys/bamos-west2-ssh-aws.pem -e @./modules/ps-re-cluster/extra_vars/test-inventory.yaml -e @./modules/ps-re-cluster/group_vars/all/main.yaml 


ansible-playbook -i ./inventories/test-inventory.ini redislabs-create-cluster.yaml --private-key ~/desktop/keys/bamos-west2-ssh-aws.pem -e @./extra_vars/test-inventory.yaml -e @./group_vars/all/main.yaml 

