init:
	cp "./support_files/init-setup.el" "init.el"
check:
	@./support_files/check_requirements.sh "./support_files/requirements.txt"
