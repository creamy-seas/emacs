init:
	cp "./support_files/init-setup.el" "init.el"
check:
	@./support_files/check_requirements.sh "./support_files/requirements.txt" "./support_files/ttf_requirements.txt"
install_fira:
	@./support_files/install_fira_code.sh
