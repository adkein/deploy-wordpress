## Installation

Create an inventory file at ./hosts

Create a credential file at ./website/.env. Copy the following contents to it and add your own values for the variables:

```
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
```

Modify website/nginx-conf/nginx.conf and website/docker-compose.yaml, replacing DOMAIN_NAME with your website's domain name.

Then run the following commands:

```
. ./deps.sh
. ./venv/bin/activate
ansible-playbook ./playbooks/provision_user.yml -u root
ansible-playbook ./playbooks/install_dependencies.yml -u alice
```

Now run deploy-website.sh on the remote machine.
