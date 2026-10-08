# ars-ansible

Ansible playbooks that deploy the web and mail infrastructure for the `epitaf.local` domain (ARS project, EPITA) on a Debian/Ubuntu server (`infra_01`).

## Roles

| Role | Description |
|------|-------------|
| `nginx` | TLS reverse proxy, custom error pages, static "Top Gun" site |
| `apache` | WordPress, Roundcube, ModSecurity, Kerberos authentication (AD) |
| `postfix` | SMTP send/receive, users and aliases resolved via LDAP |
| `dovecot` | IMAP, LDAP authentication, Maildir storage |
| `openldap` | Local LDAP proxy to Active Directory (`dc01.epitaf.local`) |
| `roundcube` | Webmail |
| `ssh` | `sshd` hardening, Google Authenticator 2FA, user accounts |
| `fail2ban` | Jails for SSH, nginx and port scan detection |

`ssh` and `fail2ban` are disabled by default in `playbooks/full.yml`.

## Layout

```
ansible.cfg            # default inventory, remote_user
inventory.yml          # remote target (through an SSH jump host)
inventory-apache.yml   # local run
playbooks/
  full.yml             # deploys every role
  apache.yml           # deploys apache only
  group_vars/
    all.yml            # shared variables (domain, base DN)
    vault.yml          # secrets encrypted with ansible-vault
  roles/
scripts/               # error page generation, TLS tests
```

## Usage

Requirements: Ansible ≥ 2.12, SSH access to the target, the vault password.

```sh
./ansible.sh
# equivalent to:
ansible-playbook --ask-become-pass --ask-vault-pass playbooks/full.yml
```

Single role:

```sh
ansible-playbook --ask-become-pass --ask-vault-pass playbooks/apache.yml
```

## Secrets

Credentials (LDAP bind, Roundcube database…) live in `playbooks/group_vars/vault.yml`, encrypted with `ansible-vault`:

```sh
ansible-vault edit playbooks/group_vars/vault.yml
```

TLS private keys (`*.key`, `*.pem`, `*.pfx`, `*.p12`) are not versioned and must be present on the target or in the roles' `files/ssl/` directories.
