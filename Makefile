# Must have trailing slash. Will change in future
# Must be in quotes
# TODO: make more generic
ELFEED_ORG_FILE="/Users/CCCP/creamy_seas/sync_files/elfeed/elfeed.org"
ELFEED_DB="/Users/CCCP/creamy_seas/sync_files/elfeed/elfeeddb"

# TODO: Email is not setup
MU4E_DIR_LOAD_PATH="/usr/local/share/emacs/site-lisp/mu/mu4e"

init:
	sed -i.bak 's|\((.*setq config/elfeed-org-file-location\)\(.*\)|\1 $(ELFEED_ORG_FILE))|' elfeedmode.org
	sed -i.bak 's|\((.*setq config/elfeed-db\)\(.*\)|\1 $(ELFEED_DB))|' elfeedmode.org
	cp "./support_files/init-setup.el" "init.el"
