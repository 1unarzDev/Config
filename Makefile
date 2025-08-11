pull:
	ansible-playbook -i .inventory playbooks/pull.yml --vault-password-file .vault --ask-become-pass

pull-no-secrets:
	ansible-playbook -i .inventory playbooks/pull.yml --ask-become-pass

MSG ?= Auto-update: $(shell date)
push:
	ansible-playbook -i .inventory playbooks/push.yml -e "commit_msg='$(MSG)'" --vault-password-file .vault --ask-become-pass
