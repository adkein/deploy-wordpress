## What is this?

This is some automation for deploying a self-hosted wordpress site. The site is served from a (presumably)
remote server on a LEMP stack, with all pieces dockerized. You control provision and deploy the website
on your local machine via Ansible playbooks.

I put this together because I noticed I kept doing the same tiem-consuming steps repeatedly. The last script
that runs on the remote server could be put into its own Ansible playbook, but so far that part has not been
particularly time-consuming and, when it is, it requires troubleshooting it at the command line anyway, so I
haven't put that into a playbook yet.

The steps I followed are outlined in [this doc](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose).

## Installation

I assume you have a remote server already deployed running Ubuntu. I have tested this with Ubuntu 20.04.

`cd` into this repo's root directory and create an inventory file at ./hosts

Create a credential file at ./website/.env. Copy the following contents to it and add your own values for the variables:

```
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
```

Modify website/nginx-conf/nginx.conf and website/docker-compose.yaml, replacing DOMAIN_NAME with your website's domain name.

Then run the following commands locally:

```
source ./deps.sh
source ./venv/bin/activate
ansible-playbook ./playbooks/provision_user.yml -u root
ansible-playbook ./playbooks/install_dependencies.yml -u alice
```

Now run deploy-website.sh on the remote machine.
