;;@@@@@@@@@@@@@@@@@@@@
;;repositories for future packages
;;@@@@@@@@@@@@@@@@@@@@
(require 'package) ;;will not work without these packages

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/")
	     t)

(package-initialize)

;;@@@@@@@@@@@@@@@@@@@@
;;makes sure that the package is installed - it ensures that you can dynamically load packages from the config file on any computer
;;@@@@@@@@@@@@@@@@@@@@
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;@@@@@@@@@@@@@@@@@@@@
;; set the cursor colour
;;@@@@@@@@@@@@@@@@@@@@
(set-default 'cursor-type 'hbar)
(set-cursor-color "#FF0")


;;@@@@@@@@@@@@@@@@@@@@
;;load commands from the org file
;;@@@@@@@@@@@@@@@@@@@@
(org-babel-load-file (expand-file-name "~/creamy_seas/syncFiles/emacs_config/config.org"))

;;@@@@@@@@@@@@@@@@@@@@
;;generated by emacs
;;@@@@@@@@@@@@@@@@@@@@
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (iedit exec-path-from-shell fill-column-indicator auto-complete-auctex preview-latex cdlatex pyenv-mode elpy jedi htmlize org-reveal flycheck counsel ox-reveal elfeed-web hydra elfeed-goodies elfeed-org try yasnippet-snippets company-irony captain expand-region mark-multiple linum-relative popup-kill-ring swiper epa-file symon dmenu diminish spaceline company dashboard rainbow-delimiters sudo-edit hungry-delete avy ido-vertical-mode beacon f org-bullets spacemacs-theme which-key use-package auctex yasnippet w3 undo-tree switch-window smex ranger powerline nlinum-relative multiple-cursors minimap autopair auto-complete alpha ace-jump-mode)))
 '(symon-mode nil)
 '(tramp-default-host "192.168.0.5" nil (tramp))
 '(tramp-default-method "ssh" nil (tramp))
 '(tramp-default-user "antonov" nil (tramp)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2d3743" :foreground "#e1e1e0" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 175 :width normal :foundry "nil" :family "Inconsolata"))))
 '(elfeed-search-date-face ((t :foreground "#11a" :weight bold)))
 '(elfeed-search-feed-face ((t :foreground "#444" :weight bold)))
 '(elfeed-search-title-face ((t :foreground "#3ef" :weight bold)))
 '(font-latex-bold-face ((t (:inherit bold))))
 '(font-latex-italic-face ((t (:inherit italic))))
 '(font-latex-math-face ((t (:foreground "#99c616"))))
 '(font-latex-sedate-face ((t (:foreground "burlywood")))))
