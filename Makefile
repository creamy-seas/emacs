EMACS_DIR="/Users/CCCP/.emacs.d"

build:
	for file in preliminary.el orgmode.el essential-packages.el ricing.el rustmode.el experimental-packages.el dockermode.el pythonmode.el essential-config.el emailmode.el elfeedmode.el latexmode.el cppmode.el jupytermode.el inkscapemode.el sshmode.el; do \
	    touch "$(EMACS_DIR)"/$$file ; \
	done
