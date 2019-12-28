;; This file replaces itself with the actual configuration at first run.
(setq user-emacs-file "~/creamy_seas/sync_files/emacs_config/config.org")
;; We can't tangle without org!
(require 'org)
;; Open the configuration
(find-file user-emacs-file)
;; tangle it
(org-babel-tangle)
;; load it
(load-file "~/creamy_seas/sync_files/emacs_config/config.el"))
;; finally byte-compile it
(byte-compile-file "~/creamy_seas/sync_files/emacs_config/config.elc")
