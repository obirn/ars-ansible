#!/bin/sh
ansible-playbook \
	--ask-become-pass \
	--ask-vault-pass \
	playbooks/full.yml
