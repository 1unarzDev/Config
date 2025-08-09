pull:
	ansible-playbook -i inventory playbooks/pull.yml --vault-password-file .vault --ask-become-pass

pull-no-secrets:
	ansible-playbook -i inventory playbooks/pull.yml --ask-become-pass

push:
	ansible-playbook -i inventory playbooks/push.yml --vault-password-file .vault --ask-become-pass