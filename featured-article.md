# Repeatable AWS deployments with Terraform and Ansible: a simple walkthrough

Manual deployments cause two problems: they are slow, and two servers that
should match slowly drift apart. I put together a small demo to show how I
avoid both.

## The setup

Two tools, two jobs:

- **Terraform** builds the infrastructure: a security group and an EC2 instance.
- **Ansible** configures the server: installs nginx, deploys the page, starts
  the service and checks it works.

## Choices that matter

1. **No hard-coded AMI.** Terraform looks up the latest Amazon Linux 2023 image,
   so the code does not rot.
2. **SSH from one IP only.** The web port is public; the admin port is not.
3. **Idempotent playbook.** Run it ten times and the server ends in the same
   state. That is what makes releases boring.
4. **A health check that can fail.** The playbook requests the page and retries.
   If the site is not returning HTTP 200, the run fails instead of reporting
   success on a broken server.

## What I would add next

Remote state with locking, Ansible roles, and a CI step running `terraform
validate` and `ansible-lint` on every change.

Code and README: [paste your GitHub repo link here]

#AWS #DevOps #Terraform #Ansible
