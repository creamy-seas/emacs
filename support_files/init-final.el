(load (concat user-emacs-directory "baseplatform.el"))
(load (concat user-emacs-directory "essential-config.el"))
(load (concat user-emacs-directory "ricing.el"))
(load (concat user-emacs-directory "experimental-packages.el"))
(load (concat user-emacs-directory "pythonmode.el"))
(load (concat user-emacs-directory "orgmode.el"))
(load (concat user-emacs-directory "rustmode.el"))
(load (concat user-emacs-directory "dockermode.el"))
(if (string-equal system-type "darwin")
    (progn
      (load (concat user-emacs-directory "emailmode.el"))
      (message "Loading from mac")))
(load (concat user-emacs-directory "cppmode.el"))
(load (concat user-emacs-directory "elfeedmode.el"))
(load (concat user-emacs-directory "jupytermode.el"))
(load (concat user-emacs-directory "inkscapemode.el"))
(load (concat user-emacs-directory "sshmode.el"))
(load (concat user-emacs-directory "gitmode.el"))
(load (concat user-emacs-directory "compact-languages.el"))
(load (concat user-emacs-directory "latexmode.el"))
(load (concat user-emacs-directory "post-load.el"))
