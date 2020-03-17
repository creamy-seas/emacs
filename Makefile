EMACS_CONFIG_DIR="/Users/CCCP/creamy_seas/sync_files/emacs_con/"
MU4E_DIR="/usr/local/share/emacs/site-lisp/mu/mu4e"


init:
	# Use sed to edit the file and slot in the user's emacs directory
	sed -i.bak 's|\((.*setq my/config-folder-location\)\(.*\)|\1 $(EMACS_CONFIG_DIR))|' base.org
	# Edit the init.el file to sub


	# Generate
build:
	for file in base.el orgmode.el ricing.el rustmode.el experimental-packages.el dockermode.el pythonmode.el essential-config.el emailmode.el elfeedmode.el latexmode.el cppmode.el jupytermode.el inkscapemode.el sshmode.el gitmode.el compact-languages.el post-load.el; do \
	    touch ~/.emacs.d/"$(EMACS_DIR)"/$$file ; \
	done
