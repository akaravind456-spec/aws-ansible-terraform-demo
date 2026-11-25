# AWS deployment with Terraform + Ansible

A small demo of a repeatable deployment: **Terraform** creates the AWS
infrastructure, **Ansible** configures the server and deploys the page.
Run it twice and you get the same result both times.

## Architecture

```
 Terraform                         Ansible
 ---------                         -------
 Security group (80 open,    -->   Install nginx
   22 only from my IP)             Deploy index.html
 EC2 instance (Amazon Linux 2023)  Start + enable service
                                   Health check (HTTP 200, retries)
```

## Why it is built this way

- **No hard-coded AMI.** The latest Amazon Linux 2023 image is looked up from
  AWS, so the code does not go stale.
- **SSH is limited to one IP**, not open to the internet.
- **Ansible is idempotent.** Re-running it changes nothing if nothing changed.
- **Health check with retries** fails the run if the site is not serving, so a
  bad deploy is caught instead of assumed to be fine.

## Run it

Requirements: Terraform 1.5+, Ansible, an AWS account with credentials
configured, and an existing EC2 key pair.

```bash
# 1. Create the infrastructure
cd terraform
terraform init
terraform apply -var="key_name=YOUR_KEY" -var="my_ip_cidr=YOUR_IP/32"

# 2. Put the public_ip output into the inventory
cd ../ansible
cp inventory.ini.example inventory.ini   # then edit the IP and key path

# 3. Configure and deploy
ansible-playbook -i inventory.ini playbook.yml

# 4. Open http://<public_ip> in a browser

# 5. Clean up (avoid charges)
cd ../terraform
terraform destroy -var="key_name=YOUR_KEY" -var="my_ip_cidr=YOUR_IP/32"
```

## Next steps I would add

- Remote Terraform state (S3 + locking)
- Ansible roles instead of one playbook
- A CI pipeline running `terraform validate` and `ansible-lint`
