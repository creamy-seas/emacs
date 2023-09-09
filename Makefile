init:
	emacs --batch --load=my-scripts/setup/tangle.el --eval="(tangle-config-files \"$(shell pwd)/\")"
