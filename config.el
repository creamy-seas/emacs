;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(load-file (concat doom-user-dir "essential-config.el"))
(load-file (concat doom-user-dir "text-manipulation.el"))
(load-file (concat doom-user-dir "navigation.el"))
(load-file (concat doom-user-dir "ricing.el"))
(load-file (concat doom-user-dir "orgmode.el"))
(load-file (concat doom-user-dir "org-config.el"))
(load-file (concat doom-user-dir "gitmode.el"))
(load-file (concat doom-user-dir "inkscapemode.el"))
(load-file (concat doom-user-dir "emailmode.el"))

;;(load-file (concat doom-user-dir "js.el"))
;;(load-file (concat doom-user-dir "compact-languages.el"))
;; (load-file (concat doom-user-dir "latexmode.el"))
