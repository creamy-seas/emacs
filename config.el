;;(use-package epa
;;     :ensure t
;;     :init
;;     (custom-set-variables '(epg-gpg-program "/usr/local/bin/gpg"))
;;     (epa-file-enable))

;;  (use-package captain
;;    :ensure t
;;    :init
;;    (global-captain-mode t)
;;    (add-hook 'org-mode-h captain-predicate 'captain-sentence-start-function)
;;
;;    (add-hook 'prog-mode-hook (lambda ()
;;				(setq captain-predicate (lambda () nth 8 (syntax-ppss (point))))))
;;
;;    (add-hook 'text-mode-hook
;;	      (lambda ()
;;		(setq captain-predicate (lambda () t))))
;;    (add-hook 'org-mode-hook
;;	      (lambda ()
;;		(setq captain-predicate (lambda () (not (org-in-src-block-p))))))
;;    )

(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(defun ilya_fire-up-from-emacs(relative-path)
  "Create a string that appends onto the systems .emacs.d directory. EMACS_HOME must be specified in .profile"
  (setq path (exec-path-from-shell-copy-env "EMACS_HOME"))
  (concat path "/" relative-path)
  )

(setq kill-buffer-query-functions nil)

(add-to-list 'org-structure-template-alist
	     '("sh" "#+BEGIN_SRC sh\n?\n#+END_SRC"))

(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(global-set-key (kbd "<s-return>") 'ansi-term)

(use-package sudo-edit
  :ensure t
  :bind ("s-e" . sudo-edit))

(use-package dmenu
  :ensure t
  :bind
  ("s-SPC" . 'dmenu))

(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; call function now
(set-exec-path-from-shell-PATH)

(setq exec-path (append exec-path '("/usr/local/bin")))

(global-set-key (kbd "C-(") 'mc/mark-next-lines)
(global-set-key (kbd "C-)") 'mc/mark-previous-lines)

(use-package symon
  :ensure t
  :bind
  ("s-h" . symon-mode))

(when window-system (global-prettify-symbols-mode t))

;;tie backend of autocompletion to company-irony
(use-package company-irony
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-irony))

;;setup company-irony with c++ connection
(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

;;finally ensure that c++-mode-hook is activated when company mode is on
(with-eval-after-load 'company
  (add-hook 'c++-mode-hook 'company-mode))

(use-package latex
  :ensure auctex
  :init
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)  ;;access imported packages
  (setq TeX-save-query nil)  ;;don't prompt file save
  (setq-default TeX-show-compilation t)
  (setq TeX-interactive-mode t)
  (setq Tex-master nil)  ;;specify master file for each project
  :config
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook
            (lambda () (TeX-fold-mode 1)))
  (add-hook 'LaTeX-mode-hook
            (lambda () (set (make-variable-buffer-local 'TeX-electric-math)
                       (cons "$" "$"))))
  :hook
  (LaTeX-mode-hook . LaTeX-math-mode);; type ` to get suggestions
  (LaTeX-mode-hook . font-lock-mode);; font highlighting
  )

(defun ilya_gen-key ()
      "Command binded to C-c C-m will make the pdf with latexmk"
      (interactive)
      (minibuffer-message (concat "ᛋᛋ Generating \"" (TeX-master-file) "\" ᛋᛋ"))
      (let (
            ;;a) variable definition
            (process-name (format "%s" (ilya_generate-process-name "genPDF")))
            ;;	    (command-script (ilya_expand-latex-command (ilya_fire-up-from-emacs "ilya_scripts/pdf_engine.sh %s"))))
            (command-script (ilya_expand-latex-command "~/creamy_seas/syncFiles/emacs_config/ilya_scripts/pdf_engine.sh %s")))

        ;;b) launch the compilation buffer
        (ilya_set-compilation-buffer-state (ilya_get-master-file-name) "genPDF")
;;        (split-window-below)
        (ignore-errors
        (TeX-run-TeX process-name command-script (TeX-master-file))))
  )

    (add-hook 'LaTeX-mode-hook (lambda ()
                                 (local-set-key (kbd "C-c C-m") (function ilya_gen-key))))

(defun ilya_jew-key()
    (interactive)
    (minibuffer-message (concat "卍 Exterminating \"" (ilya_get-master-file-name) "\" 卍"))
   (let (
         (process-name (format "%s" (ilya_generate-process-name "genPDF")))
         ;;         (command-script (ilya_expand-latex-command (ilya_fire-up-from-emacs "ilya_scripts/jew_engine.sh %s"))))
         (command-script (ilya_expand-latex-command "~/creamy_seas/syncFiles/emacs_config/ilya_scripts/jew_engine.sh %s")))

     ;;1) delete the "genPDF" process for the current master file
     (ignore-errors
       (set-process-query-on-exit-flag (get-process process-name) nil)
       (delete-process (get-process process-name)))

     ;;2) delete the buffer the process was in (reset the buffer name)
     (ilya_set-compilation-buffer-state (ilya_get-master-file-name) "genPDF")
     (ignore-errors (kill-buffer ilya_compilation-name))

     ;;3) move the files in to the output directory
     (ilya_set-compilation-buffer-state (ilya_get-master-file-name) "jewGas")
     (ignore-errors 
       (TeX-run-TeX "jew_process" command-script (TeX-master-file))
       )

     ;;4) close this buffer window
     (sleep-for 1)
     (kill-buffer (get-buffer "卍 Exterminating 卍"))
     (delete-window (get-buffer-window "卍 Exterminating 卍"))
;;     (switch-to-buffer (get-buffer "卍 Exterminating 卍"))
;;     (delete-window 1)
  ;;   (kill-buffer-and-window)
     (minibuffer-message "===> 卍 Extermination complete 卍 - heil!")))

  (add-hook 'LaTeX-mode-hook (lambda ()
                               (define-key LaTeX-mode-map (kbd "C-c C-j") nil)
                               (local-set-key (kbd "C-c C-j") (function ilya_jew-key))
                               (global-set-key (kbd "C-c C-j") (function ilya_jew-key))))

  ;;actually, global is overkill, since local will take precendence. and define-key... should be replaced with local-set-key too

(setq TeX-view-program-list
      '(("SkimViewer" "~/creamy_seas/syncFiles/emacs_config/ilya_scripts/search_engine.sh %s %n %o %b")))

(setq TeX-view-program-selection '((output-pdf "SkimViewer")))
(server-start)

(defun ilya_set-compilation-buffer-state (master-file process)
   "Set variables that the compulation buffer (latex) will then use to set the name"
   (setq ilya_compilation-master-file master-file)
   (setq ilya_compilation-process process))

 (defun ilya_get-master-file-name ()
   "Get the name of the master latex file in the current project"
   (interactive)
   (TeX-command-expand "%s" 'TeX-master-file TeX-expand-list))

 (defun ilya_generate-process-name (process_name)
   "Generates a string of the form [processName_masterFile] to uniqely identify a process"
   (concat process_name "_" (ilya_get-master-file-name)))

 (defun ilya_expand-latex-command (command-script)
   "Expands the latex command by evaluating the % variables in accordance with the system's master file"
   (TeX-command-expand command-script 'TeX-master-file TeX-expand-list)
   )

 (defun ilya_LaTeX-compilation-buffer-size ()
   "Resize the latex compilation buffer when it launches because it is seriosuly bloat"

   (progn
     (setq compilation-window-name "NA")

     ;;1) pdf generation case
     (if (string-equal ilya_compilation-process "genPDF")
         (progn
           (setq ilya_compilation-name
                 (concat "ᛋᛋ Compiling [" ilya_compilation-master-file "] ᛋᛋ"))
           (ignore-errors (rename-buffer ilya_compilation-name))
           (setq compilation-window-name (get-buffer-window ilya_compilation-name))))
;;           (delete-window (get-buffer-window ilya_compilation-name))))
     ;;2) file clearing case
     (if (string-equal ilya_compilation-process "jewGas")
         (progn
           (setq ilya_compilation-name "卍 Exterminating 卍")
           (ignore-errors (rename-buffer ilya_compilation-name))
           (setq compilation-window-name (get-buffer-window ilya_compilation-name))))

     ;;3) resize the window
     (window-resize-no-error compilation-window-name (- 5 (window-height compilation-window-name "floor")))
     )
   )

 (add-hook 'comint-mode-hook (function ilya_LaTeX-compilation-buffer-size))

(use-package reftex
  :ensure t
  :init
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)
  )

(use-package cdlatex
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex))

(font-lock-add-keywords 'latex-mode
                        (list
                         (list
                          "\\(«\\(.+?\\|\n\\)\\)\\(+?\\)\\(»\\)"
                          '(1 'font-latex-string-face t)
                          '(2 'font-latex-string-face t)
                          '(3 'font-latex-string-face t))))

(use-package fill-column-indicator
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'fci-mode)
  (setq fci-rule-color "#248")
  (setq fci-rule-width 1))

(defun setBufferToSize ()
  (interactive)
  (setq windowWidth (window-width))
  (set-fill-column (- windowWidth 10)))

(global-set-key (kbd "C-c l") 'setBufferToSize)

;;(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(setq org-agenda-files
      (append
       (file-expand-wildcards "*.org")))

(unless (package-installed-p 'org-bullets)
  (package-refresh-contents)
  (package-install 'org-bullets))
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(setq org-src-window-setup 'current-window)

(add-to-list 'org-structure-template-alist
	     '("el" "#+BEGIN_SRC emacs-lisp \n ? \n #+END_SRC"))

(add-hook 'org-mode-hook 'org-indent-mode)

(use-package ox-twbs
  :ensure t
)

;;(use-package ox-reveal
;;  :ensure t)
;;(use-package htmlize
;;  :ensure t)
;;(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")

(use-package pyenv-mode
  :ensure t
  :config
  (pyvenv-activate "~/creamy_seas/syncFiles/python_vi/emacs_vi/"))

(use-package elpy
  :ensure t
  :config
  (elpy-enable))

;;(add-hook 'python-mode-hook 'auto-complete-mode)
;;(add-hook 'python-mode-hook 'jedi:ac-setup)

;;(setq python-shell-interpreter "python3"
;;      python-shell-interpreter-args "-i")
;;(setq python-shell-interpreter "ipython"
;;      python-shell-interpreter-args "-i --simple-prompt")
(setq python-shell-interpreter "jupyter"
      pyhon-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

;;(defun ilya-python-hooks()
;;  (interactive)
;;  (setq tab-width 4
;;        python-indent-offset 4))
;;(add-hook 'python-mode-hook 'ilya-python-hooks)

(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/creamy_seas/syncFiles/emacs_config/elfeed.org")))

(use-package elfeed
  :ensure t
  :init
  (global-set-key (kbd "C-c f") 'elfeed)
  (setq-default elfeed-search-filter "@2-year-ago +unread")
  (setq elfeed-db-directory "~/creamy_seas/syncFiles/emacs_config/elfeeddb")
  :bind     ;;once the package is loaded, bing some commands
  (:map elfeed-search-mode-map
        ("*" . bjm/elfeed-star)
        ("8" . bjm/elfeed-unstar)
        ("q" . bjm/elfeed-save-db-and-bury)
        ("h" . make-hydra-elfeed)
        ("H" . make-hydra-elfeed))
  )

(use-package hydra
  :ensure t)

(defhydra hydra-elfeed (global-map "<f5>")
  ""
  ("l" (elfeed-search-set-filter "@1-year-ago +boomer") "luke boomer")
  ("s" (elfeed-search-set-filter "@1-year-ago +strat") "stratechery")
  ("i" (elfeed-search-set-filter "@1-year-ago +starred") "shiny star")
  ("*" bjm/elfeed-star "star it" :color pink)
  ("8" bjm/elfeed-unstar "unstar it" :color pink)
  ("a" (elfeed-search-set-filter "@1-year-ago") "all")
  ("q" bjm/elfeed-save-db-and-bury "quit" :color blue)
  )

;;functiont that is associated with "H" keybinding in elfeed mode
(defun make-hydra-elfeed ()
  ""
  (interactive)
  (hydra-elfeed/body))

(defun bjm/elfeed-star ()
  "Apply starred to all selected entries."
  (interactive)
  (let* ((entries (elfeed-search-selected))
         (tag (intern "starred")))

    (cl-loop for entry in entries do (elfeed-tag entry tag))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

(defun bjm/elfeed-unstar ()
  "Remove starred tag from all selected entries."
  (interactive)
  (let* ((entries (elfeed-search-selected))
         (tag (intern "starred")))

    (cl-loop for entry in entries do (elfeed-untag entry tag))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

;;functions to support syncing .elfeed between machines
;;makes sure elfeed reads index from disk before launching
(defun bjm/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-search-update--force))

;;write to disk when quiting
(defun bjm/elfeed-save-db-and-bury ()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (quit-window))

(defun bjm/elfeed-show-all ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-all"))

(use-package elfeed-goodies
  :ensure t
  :config
  (elfeed-goodies/setup))

(custom-set-faces
 '(elfeed-search-date-face
   ((t :foreground "#11a"
       :weight bold
       ))))

(custom-set-faces
 '(elfeed-search-feed-face
   ((t :foreground "#444"
       :weight bold
       ))))

(custom-set-faces
 '(elfeed-search-title-face
   ((t :foreground "#3ef"
       :weight bold
       ))))

(defface elfeed-search-starred-title-face
  '((t :foreground "#f77"
       :weight extra-bold
       :underline t))
  "marks a starred Elfeed entry")

(push '(starred elfeed-search-starred-title-face) elfeed-search-face-alist)

(use-package tramp
  :ensure t
  :config
  (custom-set-variables
   '(tramp-default-method "ssh")
   '(tramp-default-user "antonov")
   '(tramp-default-host "192.168.0.5")))
;;  (add-to-list 'tramp-default-user-alist
;;               '("ssh" "192\\.168\\.0\\.5#6767" "antonov")))
  ;;  (custom-set-variables
  ;;  '(tramp-default-method "ssh")
;;  '(tramp-default-user "antonov")
   ;;  '(tramp-default-host "134.219.128.96")))
;;   (add-to-list 'tramp-default-proxies-alist
;;	       '("134\\.219\\.128\\.96" "root" ;;"/ssh:antonov@134.219.128.96:"))
;;when using /sudo:134.219.128.96 we first login to the proxy via my antonov@134.219.128.96 account, and then | as sudo to the root@134.219.128.96
;;([host] [username] [proxy])

(use-package hydra
  :ensure t
  :init
  (defhydra hydra-zoom (global-map "<f9>")
    "zoom"
    ("g" text-scale-increase "in")
    ("l" text-scale-decrease "out")))

(use-package yasnippet
    :ensure t

    :init
    (add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)
    (add-hook 'LaTeX-mode-hook 'yas-minor-mode)
    (global-set-key (kbd "C-c C-n") 'yas-new-snippet)
    (yas-global-mode)
    :config
;;    (add-to-list 'yas-snippet-dirs (ilya_fire-up-from-emacs "snippets/snippet-mode")) ;; adds our locally created snippets
    (add-to-list 'yas-snippet-dirs "~/creamy_seas/syncFiles/emacs_config/snippets/snippet-mode")
    (use-package yasnippet-snippets
      :ensure t)
    (yas-reload-all))

(use-package company
  :ensure t
  :config
  (add-hook 'org-mode-hook 'company-mode)
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'text-mode-hook 'company-mode)

;;  (add-hook 'after-init-hook 'global-company-mode)
;;  (setq company-global-modes '(not LaTeX-mode))
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 4))

(with-eval-after-load 'company;;remap navigation only if company mode is loaded
  ;;cancel some keys, and activate others
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  )

(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list))) ;;mapc is a for loop, running 'function to the supplied (list)
(global-set-key (kbd "C-x a b") 'kill-all-buffers)

(global-set-key (kbd "C-x b") 'ibuffer)

(setq ido-enable-flex-matching nil)
(setq ido-create-new-biffer 'always)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

(defun kill-curr-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-curr-buffer)

(use-package mark-multiple
  :ensure t
  :bind ("C-c q" . 'mark-next-line-this))

(use-package expand-region
  :ensure t
  :bind ("C-q" . er/expand-region))

(defun kill-whole-word ()
  (interactive)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c w w") 'kill-whole-word)

(use-package hungry-delete
  :ensure t
  :config (global-hungry-delete-mode))

(defun copy-whole-line ()
  (interactive)
  (save-excursion ;;save the cursor position
    (kill-new            ;;kill the following
     (buffer-substring ;;from begginin of line to end of line
      (point-at-bol)
      (point-at-eol)))))
(global-set-key (kbd "C-c w l") 'copy-whole-line)

(use-package popup-kill-ring
  :ensure t
  :bind ("M-y" . popup-kill-ring))

(use-package iedit
  :ensure t)

(setq inhibit-startup-screen t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 20)))
  (setq dashboard-banner-logo-title "Привет от Леонта!"))

(add-hook 'prog-mode-hook (
                           lambda ()
                             (define-key prog-mode-map (kbd "M-m") 'toggle-frame-fullscreen)))

(add-hook 'text-mode-hook (
                           lambda ()
                             (define-key prog-mode-map (kbd "M-m") 'toggle-frame-fullscreen)))

(use-package flyspell
  :ensure t
  :bind(("<f12>" . flyspell-auto-correct-previous-word)))

(global-visual-line-mode t)

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind
  ("M-x" . smex ))

(defalias 'yes-or-no-p 'y-or-n-p)

;;(windmove-default-keybindings)

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 7)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty) 
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))
;;(global-set-key (kbd "C-M-z") 'switch-window)

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package avy
  :ensure t
  :init
  (global-set-key (kbd "M-s") 'avy-goto-word-or-subword-1)
  (setq avy-background t))
;;(global-set-key (kbd "M-s") 'ace-jump-mode)

(use-package swiper
  :ensure t
  :config
  (global-set-key (kbd "C-s") 'swiper))

(global-subword-mode 1)

;;  (display-time-mode 1)

(column-number-mode 1)
(global-hl-line-mode 1)

(use-package linum-relative
  :ensure t
  :init
  (setq linum-relative-backend 'display-line-numbers-mode))

(linum-relative-global-mode)

(defun config-visit()                       ;;no arguments
  (interactive)                                 ;;function type
  (find-file "~/creamy_seas/syncFiles/emacs_config/config.org"))
(global-set-key (kbd "C-c e") 'config-visit) ;;call the function defined above

(defun reload-config()
  (interactive)
  (org-babel-load-file (expand-file-name "~/creamy_seas/syncFiles/emacs_config/config.org")))
(global-set-key (kbd "C-c r") 'reload-config)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode 1))
(global-set-key (kbd "M-/") 'undo-tree-visualize)

(setq make-backup-files nil)

(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(global-set-key (kbd "C-c m")  'rename-file-and-buffer)

(setq frame-title-format "nsdap")
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(if (file-exists-p "~/macbook_localiser")
    (progn
      (use-package powerline			
        :ensure t
        :init
        (powerline-center-theme)
        (setq ns-use-srgb-colorspace nil))
      (setq powerline-default-separator 'wave))
  (progn
    (use-package spaceline
      :ensure t
      :config
      (require 'spaceline-config)
      (setq powerline-default-separator (quote arrow))
      (setq ns-use-srgb-colorspace nil)
      (spaceline-spacemacs-theme))))

(if (file-exists-p "~/macbook_localiser")
    (load-theme 'misterioso)
  (use-package spacemacs-theme
    :defer t
    :ensure t
    :config (load-theme 'spacemacs-dark)))

(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")
(set-cursor-color "yellow")

(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

(use-package rainbow-mode
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-mode))

(setq electric-pair-pairs '(
                            (?\( . ?\))
                            (?\" . ?\")
                            ))
(add-hook
 'LaTex-mode-hook
 (lambda ()
   (setq-local electric-pair-inhibit-predicate
               `(lambda (c)
                  (if (char-equal c ?{) t (,electric-pair-inhibit-predicate c))))))

(add-hook 'org-mode-hook 'electric-pair-mode)
(add-hook 'emacs-lisp-mode-hook 'electric-pair-mode)

(show-paren-mode)

(use-package rainbow-delimiters
  :ensure t
  :init
  (rainbow-delimiters-mode 1)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'org-mode-hook #'rainbow-delimiters-mode)
  )

(use-package diminish
      :ensure t
      :init
      (diminish 'hungry-delete-mode)
      (diminish 'beacon-mode)		
      (diminish 'which-key-mode)
      (diminish 'undo-tree-mode)
;;      (diminish 'rainbow-mode)
      (diminish 'subword-mode)
      (diminish 'visual-line-mode)
      (diminish 'org-indent-mode)
      (diminish 'prettify-symbols-mode)
;;      (diminish 'yas-minor-mode)
      (diminish 'hl-line-mode)
      (diminish 'column-number-mode)
      (diminish 'line-number-mode)
      (diminish 'linum-relative-mode)
  )
