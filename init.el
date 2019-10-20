(require 'package)
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package bind-key
  :ensure t)

(defun tangle-init ()
  "If the current buffer is 'config.org' the code-blocks are
tangled, and the tangled file is compiled."
  (let ((config-file "/Users/CCCP/creamy_seas/sync_files/emacs_config/config.org")
        (el-file (concat user-emacs-directory "init.el")))
    (when (equal (buffer-file-name) config-file)
      (let ((prog-mode-hook nil))		;; Avoid running hooks when tangling.
        (org-babel-tangle)
        (delete-file el-file)
        (rename-file (replace-regexp-in-string "\.org" "\.el" config-file)
                     el-file)
        (byte-compile-file el-file)))))

(add-hook 'after-save-hook 'tangle-init)

(setq require-final-newline    t)
(setq next-line-add-newlines nil)

(add-hook 'prog-mode-hook (
                           lambda ()
                             (define-key prog-mode-map (kbd "M-m") 'toggle-frame-fullscreen)))

(add-hook 'text-mode-hook (
                           lambda ()
                             (define-key prog-mode-map (kbd "M-m") 'toggle-frame-fullscreen)))

(use-package flyspell
  :ensure t)

(global-set-key (kbd "<f12>") (function flyspell-auto-correct-previous-word))

(global-visual-line-mode t)

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package smex
  :ensure t
  :init (smex-initialize))

(global-set-key (kbd "M-x") (function smex))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq load-prefer-newer t)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; (setq make-backup-files nil)

(setq electric-pair-pairs '(
                            (?\( . ?\))
                            (?\" . ?\")
                            ))
(add-hook 'org-mode-hook 'electric-pair-mode)
(add-hook 'emacs-lisp-mode-hook 'electric-pair-mode)

(add-hook 'LaTex-mode-hook (lambda ()
                             (setq-local electric-pair-inhibit-predicate
                                         `(lambda (c)
                                            (if (char-equal c ?{) t (,electric-pair-inhibit-predicate c))))))

(show-paren-mode)

(use-package rainbow-delimiters
  :ensure t
  :init
  (rainbow-delimiters-mode 1)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'org-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  )

;; (setq mac-right-command-modifier 'super)
;; (setq mac-option-modifier 'meta)
;; (setq mac-left-option-modifier 'meta)
;; (setq mac-right-option-modifier 'meta)
;; (setq mac-command-modifier 'super)

(add-to-list 'load-path "~/creamy_seas/sync_files/emacs_config/ilya_el_manual/rust-mode-20191011.928")
(autoload 'rust-mode "rust-mode" nil t)

(use-package cargo
  :ensure t)

(use-package racer
  :ensure t)

(use-package rustic
  :ensure t)

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))

;; compling 
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;; code compltion with company
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(setq company-tooltip-align-annotations t)

;; even more formatting
;; (add-hook 'racer-mode-hook 'rustic-mode)
(add-hook 'rust-mode-hook 'lsp-mode)

;; (setq rustic-format-trigger 'on-save)
;; (setq rust-format-on-save t)

(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(define-key rust-mode-map (kbd "C-c C-d") (function racer-describe-tooltip))
(define-key rust-mode-map (kbd "C-c d") (function racer-describe))

(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  (setq elpy-shell-use-project-root nil)
  (setq python-shell-completion-native-enable nil) ;remove a warming about native completion
  )

(use-package py-autopep8
  :ensure t
  :init
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

(defun ilya-python-interrupt ()
  "Send an interrupt signal to python process"
  (interactive)
  (let ((proc (ignore-errors
		(python-shell-get-process-or-error))))
    (when proc
      (interrupt-process proc))))

(add-hook 'elpy-mode-hook #'lsp)

(defun ilya-pyenv-activate (python-environment-path)
  "Activate a particular environment
-------------------------------------------------------------------
python-path     relative path (from home directory) to the python env
                folder to activate
"
  (interactive)
  (progn
    (pyvenv-activate python-environment-path)
    (setq elpy-rpc-python-command "python3.7")
    (setq python-shell-interpreter "python3.7"
          python-shell-interpreter-args "-i")
    (pyvenv-restart-python)))

(use-package hydra
  :ensure t)

(defhydra hydra-python-vi (:color teal
                            :hint nil)
  "
     PYTHON ENVIRONMENT SELECTION
^^^^^------------------------------------------------------------------------------------------
_p_: phd-vi                _r_: restart
_n_: neural-network-vi
_o_: pro_vi
_s_: scraping_vi
^^
^^
"
  ("p"   (ilya-pyenv-activate "~/creamy_seas/sync_files/python_vi/phd_vi"))
  ("o"   (ilya-pyenv-activate "~/creamy_seas/sync_files/python_vi/pro_vi"))
  ("n"   (ilya-pyenv-activate "~/creamy_seas/sync_files/python_vi/nn_vi"))
  ("s"   (ilya-pyenv-activate "~/creamy_seas/sync_files/python_vi/scraping_vi"))
  ("r"   pyvenv-restart-python)
  ("q"   nil "cancel" :color blue))

(global-set-key (kbd "<f9>") (function hydra-python-vi/body))

(add-hook 'python-mode-hook (lambda ()
			      (local-unset-key (kbd "C-c C-j")) ;imenu
			      (local-unset-key (kbd "C-c C-f")) ;elpy-find-file
			      (define-key elpy-mode-map (kbd "C-c C-b") nil) ;select current indentation

			      (define-key elpy-mode-map (kbd "C-c C-k") (function ilya-python-interrupt))
			      (define-key elpy-mode-map (kbd "C-c C-j") (function elpy-shell-kill-all))
			      (define-key elpy-mode-map (kbd "C-c C-n") (function flycheck-next-error))
			      (define-key elpy-mode-map (kbd "C-c C-p") (function flycheck-previous-error))
			      (define-key elpy-mode-map (kbd "C-c C-f") (function elpy-nav-expand-to-indentation))
			      (define-key elpy-mode-map (kbd "C-c C-r") (function elpy-rpc-restart))
			      (define-key elpy-mode-map (kbd "C-c C-;") (function comment-line))))

(use-package pyenv-mode
  :ensure t
  :config)
  ;; (if (file-exists-p "~/.macbook_localiser")
  ;;     (hydra-python-vi/body)
  ;;   (ilya-pyenv-activate "~/creamy_seas/sync_files/python_vi/arch_vi")))



(use-package ag
  :ensure t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (emacs-lisp . t)))

(use-package emojify
  :ensure t)
(global-emojify-mode)

(use-package ggtags
:ensure t
:config 
(add-hook 'c++-mode 
          (lambda ()
            (ggtags-mode 1))))

(use-package counsel
  :ensure t)

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode))

(use-package wgrep
  :ensure t)

(use-package ivy
 :ensure t
 :diminish
 (ivy-mode)
 :init
 (ivy-mode 1)
 :config
 (setq ivy-use-virtual-buffers t
            ivy-count-format "%d/%d "))

(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(setq epa-pinentry-mode 'loopback)

;; add location of lisp files for me4e
(add-to-list 'load-path
             (expand-file-name "/usr/local/share/emacs/site-lisp/mu/mu4e"))

;; location of the mu binary
(setq mu4e-mu-binary "/usr/local/bin/mu")

(use-package mu4e
  :config

  ;; 1 - method to pull in the mial
  (setq mu4e-get-mail-command "offlineimap")
  (setq mu4e-maildir "~/mail")
  (setq mu4e-view-show-addresses t)
  (setq mu4e-update-interval 86000)
  ;; (setq mu4e~get-mail-password-regexp "^Enter password for user 'Remote': $")

  ;; 2 - directory for saving attachments
  (setq mu4e-attachment-dir (expand-file-name "~/mail/attachments/"))

  ;; 3 - method to generate html messages and preview images
  ;;   - html2text -utf8 -width 72
  ;;   - textutil -stdin -format html -convert txt -stdout
  ;;   - html2markdown | grep -v '&nbsp_place_holder;' (Requires html2text pypi)
  ;;   - w3m -dump -cols 80 -T text/html
  ;; (setq mu4e-html2text-command "textutil -stdin -format html -convert txt -stdout")
  (setq mu4e-html2text-command "w3m -T text/html")
  (setq mu4e-view-show-images t)
  (add-to-list 'mu4e-view-actions '("web-view" . mu4e-action-view-in-browser) t)
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;; 4 - main accounts and sending mail
  (setq mu4e-user-mail-address-list '("ilya.antonov@dreams-ai.com"
                                      "ilya.antonov24@ntlworld.com"
                                       "antonov.ilya225@gmail.com"
                                       "ilya.antonov24@ntlworld.com"))
  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy 'always-ask)

  ;; 5 - replies and citations
  (setq mu4e-compose-signature (concat "Wishing all the very best,\n"
                                       "Ilya\n"))
  (setq message-citation-line-format "%N @ %Y-%m-%d %H:%M %Z:\n")
  (setq message-citation-line-function 'message-insert-formatted-citation-line)

  ;; 6 - spell check
  (add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "⦿⦿ Those sweet custom settings"
           (set-fill-column 72)
           (flyspell-mode)))

  ;; 7 - fine tuning of accounts
  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "ntlworld"
          :enter-func (lambda () (mu4e-message "Entering NTLWORLD"))
          :leave-func (lambda () (mu4e-message "Leaving NTLWORLD"))
          :match-func (lambda (msg)
                        (when msg
                          (mu4e-message-contact-field-matches
                           msg '(:from :to :cc :bcc) "ilya.antonov24@ntlworld.com")))
          :vars '((user-mail-address . "ilya.antonov24@ntlworld.com")
                  (user-full-name . "Ilya Antonov (NTLWORLD)")
                  ;; (mu4e-sent-messages-behavior 'delete)
                  (mu4e-sent-folder . "/ilya_NTLWORLD/Sent")
                  (mu4e-drafts-folder . "/ilya_NTLWORLD/Drafts")
                  (mu4e-trash-folder . "/ilya_NTLWORLD/Trash")
                  (mu4e-refile-folder . "/ilya_NTLWORLD/Archive")
                  (mu4e-compose-signature . (concat
                                             "Ilya Antonov,\n"
                                             "⦿ NTLWORLD\n"))
                  (mu4e-compose-format-flowed . nil)))
         (make-mu4e-context
          :name "dreams-ai"
          :enter-func (lambda () (mu4e-message "Entering Dreams ☁"))
          :leave-func (lambda () (mu4e-message "Entering Dreams ☁"))
          :match-func (lambda (msg)
                        (when msg
                          (mu4e-message-contact-field-matches
                           msg '(:from :to :cc :bcc) "ilya.antonov@dreams-ai.com")))
          :vars '((user-mail-address . "ilya.antonov@dreams-ai.com")
                  (user-full-name . "Ilya Antonov (Dreams-AI)")
                  ;; (mu4e-sent-messages-behavior 'delete)
                  (mu4e-sent-folder . "/ilya_DREAMSAI/[Gmail].Sent Mail")
                  (mu4e-drafts-folder . "/ilya_DREAMSAI/[Gmail].Drafts")
                  (mu4e-trash-folder . "/ilya_DREAMSAI/[Gmail].Bin")
                  (mu4e-refile-folder . "/ilya_DREAMSAI/[Gmail].Starred")
                  (mu4e-compose-signature . (concat
                                             "Ilya Antonov,\n"
                                             "☁ DREAMSAI\n"))
                  (mu4e-compose-format-flowed . nil)))
         (make-mu4e-context
          :name "gmail"
          :enter-func (lambda () (mu4e-message "Entering GMAIL"))
          :leave-func (lambda () (mu4e-message "Leaving GMAIL"))
          :match-func (lambda (msg)
                        (when msg
                          (mu4e-message-contact-field-matches
                           msg '(:from :to :cc :bcc) "antonov.ilya225@gmail.com")))
          :vars '((user-mail-address . "antonov.ilya225@gmail.com")
                  (user-full-name . "Ilya Antonov (GMAIL)")
                  ;; (mu4e-sent-messages-behavior 'delete)
                  (mu4e-sent-folder . "/ilya_GMAIL/[Gmail].Sent Mail")
                  (mu4e-drafts-folder . "/ilya_GMAIL/[Gmail].Drafts")
                  (mu4e-trash-folder . "/ilya_GMAIL/[Gmail].Bin")
                  (mu4e-refile-folder . "/ilya_GMAIL/[Gmail].Starred")
                  (mu4e-compose-signature . (concat
                                             "Ilya Antonov,\n"
                                             "⦿ GMAIL\n"))
                  (mu4e-compose-format-flowed . nil)))
         (make-mu4e-context
          :name "outlook"
          :enter-func (lambda () (mu4e-message "Entering OUTLOOK"))
          :leave-func (lambda () (mu4e-message "Leaving OUTLOOK"))
          :match-func (lambda (msg)
                        (when msg
                          (mu4e-message-contact-field-matches
                           msg '(:from :to :cc :bcc) "ilya.antonov.2013@live.rhul.ac.uk")))
          :vars '((user-mail-address . "ilya.antonov.2013@live.rhul.ac.uk")
                  (user-full-name . "Ilya Antonov (OUTLOOK)")
                  (mu4e-sent-folder . "/ilya_OUTLOOK/Sent Items")
                  (mu4e-drafts-folder . "/ilya_OUTLOOK/Drafts")
                  (mu4e-trash-folder . "/ilya_OUTLOOK/Deleted Items")
                  (mu4e-refile-folder . "/ilya_OUTLOOK/Archive")
                  (mu4e-compose-signature . (concat
                                             "Ilya Antonov,\n"
                                             "⦿ From OUTLOOK\n"))
                  (mu4e-compose-format-flowed . nil)))))

  ;; 7 - shortcuts
  (setq mu4e-bookmarks '(("flag:unread" "Unread messages" ?u)
                         ("date:today..now" "Today's messages" ?t)
                         ("date:7d..now" "Last 7 days" ?w)
                         ("mime:image/*" "Messages with images" ?p)))
  (add-to-list 'mu4e-bookmarks
               (make-mu4e-bookmark
                :name "All Inboxes"
                :query "maildir:/ilya_GMAIL/INBOX OR maildir:/ilya_NTLWORLD/INBOX OR maildir:/ilya_OUTLOOK/INBOX OR maildir:/ilya_DREAMSAI/INBOX"
                :key ?i))
  (add-to-list 'mu4e-bookmarks
               (make-mu4e-bookmark
                :name "All Archives"
                :query "maildir:/ilya_GMAIL/[Gmail].Starred OR maildir:/ilya_NTLWORLD/Archive OR maildir:/ilya_OUTLOOK/Archive OR maildir:/ilya_DREAMSAI/[Gmail].Starred"
                :key ?a))


  (setq   mu4e-maildir-shortcuts
          '(("/ilya_DREAMSAI/INBOX"     . ?d)
            ("/ilya_GMAIL/INBOX"     . ?g)
            ("/ilya_NTLWORLD/INBOX"     . ?n)
            ("/ilya_OUTLOOK/INBOX"     . ?l))))

(setq mu4e-headers-fields
    '( (:date          .  10)
       (:flags         .   6)
       (:from          .  30)
       (:subject       .  nil)))

(defun mu4e-in-new-frame ()
  "Start mu4e in new frame."
  (interactive)
  (select-frame (make-frame))
  (mu4e))

(setq mu4e-split-view 'horizontal)

(add-to-list 'mu4e-marks
             '(read-and-trash
               :char       "✘"
               :prompt     "w⦿Read and Trash⦿"
               :show-target (lambda (target) "→Read and Trash")
               :action      (lambda (docid msg target)
                            ;remove Unread and New → Mark as [S]een and [T]rash
                              (mu4e~proc-move docid nil "+S+T-u-N"))))

(mu4e~headers-defun-mark-for read-and-trash)
(define-key mu4e-headers-mode-map (kbd "d") 'mu4e-headers-mark-for-read-and-trash)

(setq message-send-mail-function (function message-send-mail-with-sendmail))
(setq sendmail-program "/usr/local/bin/msmtp")

  ;; Use the correct account context when sending mail based on the from header.
(setq message-sendmail-envelope-from 'header)
;; (add-hook 'message-send-mail-hook 'choose-msmtp-account)

(use-package mu4e-alert
  :ensure t
  :after mu4e
  :init
  (setq mu4e-alert-interesting-mail-query
    (concat
     "flag:unread maildir:/ilya_NTLWORLD/INBOX "
     "OR "
     "flag:unread maildir:/ilya_GMAIL/INBOX "
     "OR "
     "flag:unread maildir:/ilya_DREAMSAI/INBOX "
     " OR "
     "flag:unread maildir:/ilya_OUTLOOK/INBOX"
     ))
  (mu4e-alert-enable-mode-line-display)

  (defun ilya-mu4e-alert-mode-line ()
    (interactive)
    (mu4e~proc-kill)
    (mu4e-alert-enable-mode-line-display)
    )
  (run-with-timer 0 60 'ilya-mu4e-alert-mode-line))

;; funciton is based off epa-decrypt file
(defun ilya-epa-decrypt-file (decrypt-file &optional plain-file)
  "Decrypt DECRYPT-FILE into PLAIN-FILE.
  If you do not specify PLAIN-FILE, this functions prompts for the value to use."
  (interactive
   (let* ((file (read-file-name "File to decrypt: "))
          (plain (epa-read-file-name file)))
     (list file plain)))
  (or plain-file (setq plain-file (epa-read-file-name decrypt-file)))
  (setq decrypt-file (expand-file-name decrypt-file))
  (let ((context (epg-make-context epa-protocol)))
    (epg-context-set-passphrase-callback context
                                         #'epa-passphrase-callback-function)
    (epg-context-set-progress-callback context
                                       (cons
                                        #'epa-progress-callback-function
                                        (format "Decrypting %s..."
                                                (file-name-nondirectory decrypt-file))))
    (setf (epg-context-pinentry-mode context) epa-pinentry-mode)
    (message "Decrypting %s..." (file-name-nondirectory decrypt-file))
    (condition-case error
        (epg-decrypt-file context decrypt-file plain-file)
      (error
       (epa-display-error context)
       (signal (car error) (cdr error))))))

(add-hook 'mu4e-update-pre-hook (lambda ()
                                  (ilya-epa-decrypt-file "~/creamy_seas/sync_files/emacs_config/support_files/load_password_dummy_file.gpg" "/dev/null")))

(fset 'ipic
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 105 112 105 99 return 6 C-backspace 98 101 103 105 110 123 99 101 110 116 101 114 6 return 92 105 110 99 108 117 100 101 103 114 97 112 104 105 99 115 91 4 104 101 105 103 104 116 61 19 125 return backspace 93 5 return 92 101 110 100 123 99 101 110 116 101 114 125] 0 "%d")) arg)))

(fset 'iRa
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 105 82 97 return 134217826 2 2 67108896 6 6 6 6 backspace 92 113 117 97 100 92 82 105 103 104 116 97 114 114 112 119 backspace backspace 111 119 92 113 117 97 100] 0 "%d")) arg)))

(fset 'ira
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 105 114 97 return C-backspace backspace 92 44 92 114 105 103 104 116 97 114 114 111 119 92 44] 0 "%d")) arg)))

(fset 'ipicCaption
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 105 112 105 99 67 return 134217830 C-backspace C-backspace 98 101 103 105 110 123 102 105 103 117 114 101 125 91 104 93 return 92 98 101 103 105 110 123 99 101 110 116 101 114 125 return 92 105 110 99 108 117 100 101 103 114 97 112 104 105 99 115 91 104 101 105 103 104 116 61 4 4 4 19 125 return backspace 93 19 125 return return 92 99 97 112 116 105 111 110 123 92 115 109 97 108 108 4 4 4 32 19 125 return 134217829 return 92 101 110 100 123 99 101 110 116 101 114 125 return 92 101 110 100 123 102 105 103 117 114 101 125] 0 "%d")) arg)))

(fset 'iframed
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([19 105 102 114 97 109 101 return C-backspace 98 101 103 105 110 6 102 114 97 109 101 100 125 92 110 111 105 110 100 101 110 116 return 134217829 backspace return 92 101 110 100 123 102 114 109 backspace 97 109 101 100 125] 0 "%d")) arg)))

(use-package ox-reveal
  :ensure t
  :config
  (require 'ox-reveal)
  (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
  (setq org-reveal-mathjax t)
  )
(use-package htmlize
  :ensure t)

(setq ring-bell-function 'ignore)

(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("/Users/CCCP/.scripts")))

(defun ilya-copy-line ()
  "Copies the current line of the cursor
   Returns the current line as a string"
  (interactive)
  (buffer-substring (line-beginning-position) (line-end-position)))

(defun ilya-extract-string (regexp index string)
  "Extract a particular part of a regexp from the chosen string
-------------------------------------------------------------------
regexp     regular expression with individual arguments in \\(\\)
index         index match to extract
string        string to extract from
"
  (string-match regexp string)
  (match-string index string))

(defun ilya-file-name-from-line (prefix suffix)
  "Copies the current line and elinates all spaces"
  (interactive)
  (let* (
         (file-name (ilya-copy-line))
         (file-name (replace-regexp-in-string "^\s*" "" file-name))
         (file-name (downcase file-name))
         (file-name (replace-regexp-in-string " " "_" file-name))
         (file-name (concat prefix file-name suffix)))
    (message file-name)))

(add-to-list 'load-path "~/creamy_seas/sync_files/emacs_config/ilya_el_manual")

(setq frame-title-format "nsdap")
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(use-package powerline			
  :ensure t
  :init
  (powerline-default-theme)
  (setq ns-use-srgb-colorspace nil))

(setq powerline-default-separator 'box)

;; (use-package spaceline
;;   :ensure t
;;   :config
;;   (require 'spaceline-config)
;;   (setq powerline-default-separator (quote arrow))
;;   (setq ns-use-srgb-colorspace nil)
;;   (spaceline-spacemacs-theme))

;; (use-package smart-mode-line
;;   :ensure t
;;   :init
;;   (use-package smart-mode-line-powerline-theme
;;     :ensure t)
;;   (setq size-indication-mode t)
;;   (setq sml/shorten-directory t)
;;   (setq sml/no-confirm-load-theme t)
;;   (setq sml/shorten-modes t)
;;   (sml/setup))

;; (add-to-list 'sml/replacer-regexp-list '("^.*config.*$" ":ED:") t)
;; (add-to-list 'sml/replacer-regexp-list '("^.*config\\.org$" ":ED:") t)
;; (custom-set-variables
;;  '(sml/col-number-format "")
;;  '(sml/extra-filler -2)
;;  '(sml/line-number-format "")
;;  '(sml/mule-info "")
;;  '(sml/modified-char "☦︎")
;;  '(sml/name-width (quote (20 . 40)))
;;  '(sml/read-only-char "☧")
;;  '(sml/pos-minor-modes-separator " ᛋᛋ")
;;  '(sml/pre-minor-modes-separator "ᛋᛋ")
;;  )

;; (custom-set-faces
;;  '(sml/filename ((t (:inherit mode-line-buffer-id :foreground "#eab700" :weight bold)))) ;file name
;;  '(sml/prefix ((t (:foreground "#eab700")))) ;shortennings
;;  '(sml/folder ((t (:foreground "#505040" :weight normal)))) ;folder
;;  '(sml/global ((t (:foreground "white")))) ;most things on line
;;  '(sml/position-percentage ((t (:foreground "white")))) ;percentageof buffer
;;  '(sml/remote ((t (:foreground "red")))) ;local or remote load
;;  '(sml/git ((t (:foreground "white"))))	;github
;;  '(sml/vc-edited ((t (:foreground "white")))) ;github
;;  '(sml/modes ((t (:foreground "#1eafe1" :weight bold :box (:line-width 1 :color "#2d379a" :style pressed-button))))) ;major mode
;;  '(sml/minor-modes ((t (:foreground "#1eafe1")))) ;major mode
;;  '(sml/process ((t (:foreground "red")))) ;github
;;  '(mode-line ((t (:background "#2d379a" :foreground "#1eafe1" :box nil))))
;;  '(mode-line-inactive ((t (:foreground "#1eafe1" :background "#1d679a" :box nil))))
;;  )

;;    '(sml/charging ((t (:inherit s
;;                                ml/global :foreground "ForestGreen" :underline t))))
;;  '(sml/client ((t (:inherit sml/prefix :underline t))))
;;  '(sml/col-number ((t (:inherit sml/global :underline t))))
;;  '(sml/discharging ((t (:inherit sml/global :foreground "Red" :underline t))))

(if (display-graphic-p)			;only if we are in graphics mode
    (if (file-exists-p "~/.macbook_localiser")
	(load-theme 'deeper-blue)
      (load-theme 'light-blue)))
      ;; (use-package spacemacs-theme
      ;;   :defer t
      ;;   :ensure t
      ;;   :config (load-theme 'spacemacs-dark))))

;; (load-theme 'misterioso)
;; (load-theme 'wheatgrass)

(setq split-height-threshold 80)
(setq split-width-threshold 160)

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
  (add-hook 'prog-mode-hook 'rainbow-mode)
  (add-hook 'fundamental-mode-hook 'rainbow-mode)
  )

(custom-set-faces
 '(default ((t (:family "Inconsolata" :height 170))))
 ;; '(default ((t (:family "Inconsolata" :height 170 :background "#2d3743"))))
 ;; `(popup-scroll-bar-background-face ((t (:background "#189a1e1224a2"))))
 ;; `(popup-scroll-bar-foreground-face ((t (:background "#41bf505b61e3"))))
 ;; `(popup-face ((t (:background "#41bf505b61e3" :foreground "white"))))
 ;; selection on autocomplete
 ;; `(popup-menu-selection-face ((t (:background "orange2" :foreground "#3a3a6e" :weight semibold))))
 ;; rest of autocomplete
 ;; `(popup-menu-face ((t (:inherit default :background "#41bf505b61e3"))))
 ;; `(popup-menu-summary-face ((t (:inherit default :background "#41bf505b61e3"))))
 )
(set-default 'cursor-type 'hollow)
(set-cursor-color "#ffd700")

(defun config-visit()
    "Opens up the configuration file on the stroke of =C-c e=
"
  (interactive)
  (find-file "~/creamy_seas/sync_files/emacs_config/config.org"))

(global-set-key (kbd "C-c e") (function config-visit))

(defun reload-config()
  "Reruns the config file
"
  (interactive)
  (org-babel-load-file (expand-file-name "~/creamy_seas/sync_files/emacs_config/config.org")))

(use-package sudo-edit
  :ensure t
  :bind ("s-e" . sudo-edit))

(global-auto-revert-mode 1)

(use-package symon
  :ensure t
  :bind
  ("s-h" . symon-mode))

(when window-system (global-prettify-symbols-mode t))

(defun narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, org-src-block, org-subtree, or defun,
whichever applies first.
Narrowing to org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing command.
         ;; Remove this first conditional if you don't want it.
         (cond ((ignore-errors (org-edit-src-code))
                (delete-other-windows))
               ((org-at-block-p)
                (org-narrow-to-block))
               (t (org-narrow-to-subtree))))
        (t (narrow-to-defun))))

(global-set-key (kbd "C-x n") (function narrow-or-widen-dwim))

(defun ilya-generate-texfile ()
  "Generates a latex files, placing it in texfiles folder of the current project"
  (interactive)
  (setq temp-file-name-for-snippet (ilya-file-name-from-line "texfiles/" ".tex"))
  (delete-region (line-beginning-position) (line-end-position)))

(use-package latex
  :ensure auctex
  :init
  (setq TeX-auto-save t)
  ;; (setq TeX-parse-self t)			;;access imported packages
  (setq TeX-save-query nil)			;;don't prompt file save
  (setq-default TeX-show-compilation t)		;;display compulation in a parrallel window
  (setq TeX-interactive-mode t)
  (setq Tex-master nil)				;;specify master file for each project
  :config
  ;; spell checking
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)

  ;; display greek symbols
  (add-hook 'LaTeX-mode-hook
            (lambda () (TeX-fold-mode 1)))

  ;; ensure that anything inside $ $ is treated as math mode
  (add-hook 'LaTeX-mode-hook
            (lambda () (set (make-variable-buffer-local 'TeX-electric-math)
                       (cons "$" "$"))))
  :hook
  ;; type ` to get suggestions
  (LaTeX-mode-hook . LaTeX-math-mode)

  ;; font highlighting
  (LaTeX-mode-hook . font-lock-mode))

(use-package reftex
  :ensure t
  :init
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t))

(use-package cdlatex
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex))

(setq cdlatex-math-modify-alist
      '(
        (82 "\\red" "\\red" t nil nil)))

(setq cdlatex-math-symbol-alist
      `(
        (?F ("\\Phi"))))

(setq cdlatex-env-alist
      '(("cases" "\\begin{cases}\nAUTOLABEL\n?\n\\end{cases}" nil)
        ("big-left-right" "\\big(?\\big)" nil)
        ("left-right-bar" "\\left|?\\right|" nil)
        ("bigg-left-right" "\\bigg(?\\bigg)" nil)
        ("left-right-brace" "\\left\\lbrace?\\right\\rbrace" nil)
        ("theorem" "\\begin{theorem}\nLABEL\n?\n\\end{theorem}\n" nil)))

;; last 2 t/nil is whether to activate in text and math modes
(setq cdlatex-command-alist
      '(("blr(" "Insert big left-right brackets"   "" cdlatex-environment ("big-left-right") t t)
        ("bblr(" "Insert bigg-left-right brackets"   "" cdlatex-environment ("bigg-left-right") t t)
        ("lr{" "Inserts brace" "" cdlatex-environment ("left-right-brace") t t)
        ("lr|" "Inserts left and right bars 卍" "" cdlatex-environment ("left-right-bar") t t)
        ("cases" "Insert case environment"   "" cdlatex-environment ("cases") t t)
        ("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)))

(defun ilya_gen-key ()
  "Command binded to C-c C-C will make the pdf with latexmk"
  (interactive)
  (minibuffer-message (concat "ᛋᛋ Generating \"" (TeX-master-file) "\" ᛋᛋ"))
  (let (
        ;; 1 - variable definition
        (command-script (ilya_expand-latex-command "~/creamy_seas/sync_files/emacs_config/ilya_scripts/latex/pdf_engine.sh %s")))

    ;; 2 - prepare for compilation buffer
    (ilya_latex-compilation-prepare "BuildPDF")

    ;; 3 - launch compilation
    (ignore-errors
      (TeX-run-TeX ilya_latex-compilation-process-id command-script (TeX-master-file)))

    ;; 4 - change number of running processes and colour in the modeline
    (setq ilya_LaTeX-running-compilations (+ ilya_LaTeX-running-compilations 1))

  (custom-set-faces
   '(mode-line ((t (:background "#2d379a" :foreground "#1eafe1" :box (:line-width 2 :color "red")))))))
  )

(add-hook 'LaTeX-mode-hook (lambda ()
                             (define-key LaTeX-mode-map (kbd "C-c C-c") (function ilya_gen-key))))

(defun ilya_jew-key()
  (interactive)

  (minibuffer-message (concat "===> 卍 Exterminating \"" (ilya_get-master-file-name) "\" 卍"))

  (let ((command-script (ilya_expand-latex-command "~/creamy_seas/sync_files/emacs_config/ilya_scripts/latex/jew_engine.sh %s")))

    ;; 1 - get the buffer names and variables of running process
    (ilya_latex-compilation-prepare "BuildPDF")

    ;; 2 - delete the "genPDF" process for the current master file
    ;; (ignore-errors
    (set-process-query-on-exit-flag (get-process ilya_latex-compilation-process-id) nil)
    (delete-process (get-process ilya_latex-compilation-process-id))
      ;; )

    ;; 3 - delete the buffer the process was in (reset the buffer name)
    ;; (ignore-errors (kill-buffer (TeX-active-buffer)))
    (ignore-errors (kill-buffer "*TeX Help*"))

    ;; 4 - prepare variables for the gassing
    (ilya_latex-compilation-prepare "jewGas")

    ;; 5 - the gassing itself
    (ignore-errors 
      (TeX-run-TeX "jew_process" command-script (TeX-master-file))
      )

    ;; 6 - change number of running processes and recolour bar if required
    (setq ilya_LaTeX-running-compilations (- ilya_LaTeX-running-compilations 1))

    (if (eq ilya_LaTeX-running-compilations 0)
        (custom-set-faces
         '(mode-line ((t (:background "#2d379a" :foreground "#1eafe1"))))))
    (sleep-for 2)

    ;; 5 - close this buffer window
    (kill-buffer (get-buffer "卍 Exterminating 卍"))
    (minibuffer-message "===> 卍 Extermination complete 卍 - heil!")))

(add-hook 'LaTeX-mode-hook (lambda ()
                             (define-key LaTeX-mode-map (kbd "C-c C-j") (function ilya_jew-key))))

(setq TeX-view-program-list
      '(("SkimViewer" "~/creamy_seas/sync_files/emacs_config/ilya_scripts/latex/search_engine.sh %s %n %o %b")))

(setq TeX-view-program-selection '((output-pdf "SkimViewer")))

(setq ilya_LaTeX-running-compilations 0)

(defun ilya_LaTeX-compilation-buffer-size ()
  "Resize the latex compilation buffer when it launches because it is seriosuly bloat"

  (progn
    ;;1) pdf generation case
    (if (string-equal ilya_latex-compilation-process-type "BuildPDF")
        (progn
          (ignore-errors (rename-buffer ilya_latex-compilation-buffer-name))
          (setq compilation-window-name (get-buffer-window ilya_latex-compilation-buffer-name))
          (window-resize-no-error compilation-window-name (- 5 (window-height compilation-window-name "floor")))))
    ;;2) file clearing case
    (if (string-equal ilya_compilation-process "jewGas")
        (progn
          (ignore-errors (rename-buffer ilya_compilation-name))))))

;;  (add-hook 'comint-mode-hook (function ilya_LaTeX-compilation-buffer-size))

(defun ilya_latex-compilation-prepare (process-type)
  "Set variables that the latex compilation buffer will use"
  ;; 1 - get the master file name
  (setq temp-master-file (ilya_get-master-file-name))

  ;; 2 - generate further variables
  (setq ilya_latex-compilation-process-id (concat process-type ":" temp-master-file))
  (setq ilya_latex-compilation-process-type process-type)
  (setq ilya_latex-compilation-master-file temp-master-file)

  ;; 3 - generate buffer name
  (if (string-equal process-type "BuildPDF")
      (setq ilya_latex-compilation-buffer-name (concat "ᛋᛋ Compiling [" temp-master-file "] ᛋᛋ")))
  (if (string-equal process-type "jewGas")
      (setq ilya_latex-compilation-buffer-name "卍 Exterminating 卍")))

(defun ilya_get-master-file-name ()
  "Get the name of the master latex file in the current project"
  (interactive)
  (TeX-command-expand "%s" 'TeX-master-file TeX-expand-list))

(defun ilya_expand-latex-command (command-script)
  (interactive)
  "Expands the latex command by evaluating the % variables in accordance with the system's master file"
  (TeX-command-expand command-script 'TeX-master-file TeX-expand-list))

(defun ilya_latex-next-error (args)
  "Reads the compilation buffer and extracts errors to run through"
  (interactive "p")

  ;; 1 - search for active buffer (assign it to tempvar)
  (if-let ((tempvar (TeX-active-buffer)))

      ;; 2 - if open, go to that buffer and get all the errors
      (save-excursion
        (set-buffer (TeX-active-buffer))
        (TeX-parse-all-errors)

        ;; 3 - display error list
        (if TeX-error-list
            (minibuffer-message "ᛋᛋ Jew hunt finished ᛋᛋ"))

        ;; 4 - iterate through error list
        (call-interactively (function TeX-next-error))
        ;; clear region
        (delete-region (point-min) (point-max))
        (minibuffer-message "ᛋᛋ Make this totally aryan, free from scheckel mounds ᛋᛋ"))

    (minibuffer-message "ᛋᛋ But mein Führer - there's no-one running ᛋᛋ"))) 

(add-hook 'LaTeX-mode-hook (lambda ()
                             (local-unset-key (kbd "C-c C-w"))
                             (local-set-key (kbd "C-c C-w") (function ilya_latex-next-error))))

(defmacro my-save-excursion (&rest forms)
  (let ((old-point (gensym "old-point"))
        (old-buff (gensym "old-buff")))
    `(let ((,old-point (point))
           (,old-buff (current-buffer)))
       (prog1
           (progn ,@forms)
         (unless (eq (current-buffer) ,old-buff)
           (switch-to-buffer ,old-buff))
         (goto-char ,old-point)))))

(use-package fill-column-indicator
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'fci-mode)
  (setq fci-rule-color "#248")
  (setq fci-rule-width 1))

(defun ilya_buffer-fill-column ()
  (interactive)

  ;; 1 - get the window width
  (setq windowWidth (window-width))
  (setq temp-fill-width (- windowWidth 10))

  ;; 2 - set the fill width to 94 max
  (if (> 94 temp-fill-width)
      (set-fill-column temp-fill-width)
    (set-fill-column 94)))

(defun ilya-reftex-reference (&optional type no-insert cut)
  "Make a LaTeX reference.  Look only for labels of a certain TYPE.
With prefix arg, force to rescan buffer for labels.  This should only be
necessary if you have recently entered labels yourself without using
reftex-label.  Rescanning of the buffer can also be requested from the
label selection menu.
The function returns the selected label or nil.
If NO-INSERT is non-nil, do not insert \\ref command, just return label.
When called with 2 C-u prefix args, disable magic word recognition."

  (interactive)

  ;; Check for active recursive edits
  (reftex-check-recursive-edit)

  ;; Ensure access to scanning info and rescan buffer if prefix is '(4)
  (reftex-access-scan-info current-prefix-arg)

  (let ((reftex-refstyle (when (and (boundp 'reftex-refstyle) reftex-refstyle)
                    reftex-refstyle))
        (reftex-format-ref-function reftex-format-ref-function)
        (form "\\ref{%s}")
        label labels sep sep1 style-alist)

    (unless reftex-refstyle
      (if reftex-ref-macro-prompt
          (progn
            ;; Build a temporary list which handles more easily.
            (dolist (elt reftex-ref-style-alist)
              (when (member (car elt) (reftex-ref-style-list))
                (mapc (lambda (x)
                        (add-to-list 'style-alist (cons (cadr x) (car x)) t))
                      (nth 2 elt))))
            ;; Prompt the user for the macro.
            (let ((key (reftex-select-with-char
                        "" (concat "SELECT A REFERENCE FORMAT\n\n"
                                   (mapconcat
                                    (lambda (x)
                                      (format "[%c] %s  %s" (car x)
                                              (if (> (car x) 31) " " "")
                                              (cdr x)))
                                    style-alist "\n")))))
              (setq reftex-refstyle (cdr (assoc key style-alist)))
              (unless reftex-refstyle
                (error "No reference macro associated with key `%c'" key))))
        ;; Get the first macro from `reftex-ref-style-alist' which
        ;; matches the first entry in the list of active styles.
        (setq reftex-refstyle
              (or (caar (nth 2 (assoc (car (reftex-ref-style-list))
                                      reftex-ref-style-alist)))
                  ;; Use the first entry in r-r-s-a as a last resort.
                  (caar (nth 2 (car reftex-ref-style-alist)))))))

    (unless type
      ;; Guess type from context
      (if (and reftex-guess-label-type
               (setq type (reftex-guess-label-type)))
          (setq cut (cdr type)
                type (car type))
        (setq type (reftex-query-label-type))))

    ;; Have the user select a label
    (set-marker reftex-select-return-marker (point))
    (setq labels (save-excursion
                   (reftex-offer-label-menu type)))
    (reftex-ensure-compiled-variables)
    (set-marker reftex-select-return-marker nil)
    ;; If the first entry is the symbol 'concat, concat all labels.
    ;; We keep the cdr of the first label for typekey etc information.
    (if (eq (car labels) 'concat)
        (setq labels (list (list (mapconcat 'car (cdr labels) ",")
                                 (cdr (nth 1 labels))))))
    (setq type (nth 1 (car labels))
          form (or (cdr (assoc type reftex-typekey-to-format-alist))
                   form))

    (cond
     (no-insert
      ;; Just return the first label
      (car (car labels)))
     ((null labels)
      (message "Quit")
      nil)
     (t
      (while labels
        (setq label (car (car labels))
              sep (nth 2 (car labels))
              sep1 (cdr (assoc sep reftex-multiref-punctuation))
              labels (cdr labels))
        (when cut
          (backward-delete-char cut)
          (setq cut nil))

        ;; remove ~ if we do already have a space
        (when (and (= ?~ (string-to-char form))
                   (member (preceding-char) '(?\ ?\t ?\n ?~)))
          (setq form (substring form 1)))
        ;; do we have a special format?
        (unless (string= reftex-refstyle "\\ref")
          (setq reftex-format-ref-function 'reftex-format-special))
        ;; ok, insert the reference
        (if sep1 (insert sep1))
        (setq ilya-temp-refference
         (if reftex-format-ref-function
             (funcall reftex-format-ref-function label form reftex-refstyle)
           (format form label label)))
        (setq ilya-temp-refference (ilya-extract-string "\\(ref{\\)\\(.*\\)\\(}\\)" 2 ilya-temp-refference))
        ;; take out the initial ~ for good
        (and (= ?~ (string-to-char form))
             (setq form (substring form 1))))
      (message "")
      label))))

(custom-set-faces
 '(font-latex-bold-face ((t (:inherit bold))))
 '(font-latex-italic-face ((t (:inherit italic))))
 '(font-latex-math-face ((t (:foreground "#99c616"))))
 '(font-latex-sedate-face ((t (:foreground "burlywood")))))

(defface ilya_face-latex-background
  '((t :background "#2d3743"
       :foreground "#3a3a6e"
       :weight bold
       ))
  "Face for red blocks")

(defface ilya_face-latex-title
  '((t :foreground "firebrick1"
       :slant italic
       :overline t
       ))
  "Face for comments")

(defface ilya_face-latex-red
  '((t :background "#964854"
       :weight bold
       ))
  "Face for red blocks")

(defface ilya_face-latex-gold
  '((t :background "gold1"
       :weight bold
       ))
  "")

(defface ilya_face-latex-blue
  '((t :background "#464896"
       :weight bold
       ))
  "Face for blue blocks")

;; (font-lock-add-keywords 'latex-mode
  ;;                         '(("\\(\\\\red\{\\)\\(\\(.\\|\\Ca\\)*?\\)\\(\}\\\\ec\\)"
  ;;                            (1 'ilya_face-latex-red t)
  ;;                            (4 'ilya_face-latex-red t))))

  ;; (font-lock-add-keywords 'latex-mode
  ;;                         '(("\\(\\\\blue\{\\)\\(\\(.\\|\\Ca\\)*?\\)\\(\}\\\\ec\\)"
  ;;                            (1 'ilya_face-latex-blue t)
  ;;                            (4 'ilya_face-latex-blue t))))

  ;; (font-lock-add-keywords 'latex-mode
  ;;                         '(("\\(\\\\gold\{\\)\\(\\(.\\|\\Ca\\)*?\\)\\(\}\\\\ec\\)"
  ;;                            (1 'ilya_face-latex-gold t)
  ;;                            (4 'ilya_face-latex-gold t))))

  ;; ;; %% Comment
(font-lock-add-keywords 'latex-mode
			   '(("\\(%\\{2,\\}\\)\\(\s.*\\)\\($\\)"
			      (1 'ilya_face-latex-title t)
			      (2 'ilya_face-latex-title t))))

(add-hook 'LaTeX-mode-hook (lambda ()
                               (local-unset-key (kbd "C-c C-a"))
                               (local-unset-key (kbd "C-c C-b"))
                               (local-unset-key (kbd "C-c C-d"))
                               (local-unset-key (kbd "C-c C-k"))
                               (local-unset-key (kbd "C-c C-r"))
                               (local-unset-key (kbd "C-c C-z"))
                               (local-unset-key (kbd "C-c ESC"))
                               (local-unset-key (kbd "C-c C-t"))
                               (local-unset-key (kbd "C-c <")) ;;index and glossary
                               (local-unset-key (kbd "C-c /")) ;;index
                               (local-unset-key (kbd "C-c \\")) ;;index
                               (local-unset-key (kbd "C-c >")) ;;index
                               (local-unset-key (kbd "C-c _")) ;;set master file
                               (local-unset-key (kbd "C-c C-n")) ;;normal mode (use C-c #)
                               (local-unset-key (kbd "C-c ~")) ;;math mode
                               (local-unset-key (kbd "C-c }")) ;;up list
                               (local-unset-key (kbd "C-c `")) ;TeX-next-error
                               (local-unset-key (kbd "C-c ^")) ;TeX-home-buffer
                               (local-unset-key (kbd "C-x `")) ;next-error
                               ))

  (defun ilya_latex-save-buffer ()
    "Save the current buffer and performs indent"
    (interactive)
    ;; 1 - fill colum
    (setq justify-width (ilya_buffer-fill-column))


    ;; 3 - perform fill
    ;; (ignore-errors (LaTeX-fill-environment justify-width))

    ;; 2 - save file
    (save-buffer))

  (defun ilya_latex-indent-buffer (args)
    "Indents the full buffer"
    (interactive "P")
    ;; 1 - fill the column
    (setq justify-width (ilya_buffer-fill-column))

    ;; 3 - perform fill
    (ignore-errors (LaTeX-fill-buffer justify-width))
    )

  (defun ilya_insert-underscore (args)
    "Inserts an underscore, because the jews put in dollars around it"
    (interactive "P")
    (insert "_"))

(add-hook 'LaTeX-mode-hook (lambda ()
                             (define-key LaTeX-mode-map (kbd "C-c C-n") (function next-error))
                             (define-key LaTeX-mode-map (kbd "C-c C-;") (function comment-line))
                             (define-key LaTeX-mode-map (kbd "C-c C-u") (function ilya_insert-underscore))
                             (define-key LaTeX-mode-map (kbd "C-c C-q") (function ilya_latex-indent-buffer))
                             (define-key LaTeX-mode-map (kbd "C-c C-h") (function TeX-home-buffer))
                             (define-key LaTeX-mode-map (kbd "C-x C-s") (function ilya_latex-save-buffer))))

(add-hook 'artist-mode-hook
          (lambda ()
            (local-set-key (kbd "<f1>") 'org-mode)
            (local-set-key (kbd "<f2>") 'artist-select-op-pen-line) ; f2 = pen mode
            (local-set-key (kbd "<f3>") 'artist-select-op-line)     ; f3 = line
            (local-set-key (kbd "<f4>") 'artist-select-op-square)   ; f4 = rectangle
            (local-set-key (kbd "<f5>") 'artist-select-op-ellipse)  ; f5 = ellipse
))

;; (require 'cedet) ;; использую "вшитую" версию CEDET. Мне хватает...
;; (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
;; (semantic-mode   t)
;; (global-ede-mode t)
;; (require 'ede/generic)
;; (require 'semantic/ia)
;; (ede-enable-generic-projects)

;;tie backend of company to company-irony
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

(use-package csv-mode
  :ensure t)

(require 'dired+)
(global-set-key (kbd "C-x C-d") (function dired))
(define-key dired-mode-map (kbd "C-c C-q") (function toggle-read-only))
;; (define-key dired-mode-map (kbd "RET") (function dired-find-alternate-file)) ;close the current dired file and open new one with target
(define-key dired-mode-map (kbd "<right>") (function dired-find-file-other-window))

(use-package ein
  :ensure t
  :init
  (setq ein:completion-backend 'ein:use-company-backend)
  (custom-set-variables
   '(ein:jupyter-default-notebook-directory
     "~/creamy_seas/2am/python")))

(defun ilya-no-relative-numbering ()
  "turn off relative numbering"
  (linum-relative-global-mode -1))

(add-hook 'ein:notebook-mode-hook (function ilya-no-relative-numbering))

(custom-set-faces
 '(ein:cell-output-area ((t (:foreground "cornsilk4" :background "#2d3743"))))
 '(ein:cell-input-prompt ((t (:foreground "azure4" :background "#2d3743"))))
 '(header-line ((t (:foreground "DeepPink1" :background "#2d3743"))))
 '(ein:notification-tab-normal ((t (:inhert header-line))))
  '(ein:notification-tab-selected ((t (:inhert header-line :weight bold :foreground "tan1"))))
 '(ein:cell-heading-1 ((t (:inherit ein:cell-heading-3 :foreground "cornflower blue" :weight bold :height 1.2))))
 '(ein:cell-heading-2 ((t (:inherit ein:cell-heading-3 :foreground "SteelBlue2" :weight bold :height 1.05))))
 '(ein:cell-heading-6 ((t (:inherit variable-pitch :foreground "MediumPurple3" :weight bold)))))

;; (defun ilya_ein-header (ws cell type &optional level focus)
;;   "Change the cell type of the current cell.
;; Prompt will appear in the minibuffer.

;; When used in as a Lisp function, TYPE (string) should be chose
;; from \"code\", \"hy-code\", \"markdown\", \"raw\" and \"heading\".  LEVEL is
;; an integer used only when the TYPE is \"heading\"."
;;   (interactive
;;    (let* ((ws (ein:worksheet--get-ws-or-error))
;; 	  (cell (ein:worksheet-get-current-cell))
;; 	  (choices (case (slot-value ws 'nbformat)
;; 		     (2 "cm")
;; 		     (3 "cmr123456")
;; 		     (4 "chmr123456")))
;; 	  (key (ein:ask-choice-char
;; 		(format "Cell type [%s]: " choices) choices))
;; 	  (type (case key
;; 		  (?c "code")
;; 		  (?h "hy-code")
;; 		  (?m "markdown")
;; 		  (?r "raw")
;; 		  (t "heading")))
;; 	  (level (when (equal type "heading")
;; 		   (string-to-number (char-to-string key)))))
;;      (list ws cell type level t)))

;;   (let ((new (ein:cell-convert-inplace cell type)))
;;     (when level
;;       (ein:cell-change-level new level))
;;     ))

;; (let ((new (ein:cell-convert-inplace cell type)))
;;   (when (ein:codecell-p new)
;;     (setf (slot-value new 'kernel) (slot-value ws 'kernel)))
;;   (when level
;;     (ein:cell-change-level new level))
;;   (ein:worksheet--unshift-undo-list cell)
;; (when focus (ein:cell-goto new relpos)))


;; (with-eval-after-load "ein-notebook"
;;  (define-key ein:notebook-mode-map (kbd "C-c C-u") (function ilya_ein-header)))

;; (defun ilya-login-east-india (callback &optional cookie-plist)
;;   "based of ein:notebook-login, but with supplied part to connect to"
;;   (setq url-or-port "https://project02.sinobestech.com.hk")
;;   (interactive `(,(lambda (buffer url-or-port) (pop-to-buffer buffer))
;;                  ,(if current-prefix-arg (ein:notebooklist-ask-user-pw-pair "Cookie name" "Cookie content"))))
;;   (unless callback (setq callback (lambda (buffer url-or-port))))

;;   (when cookie-plist
;;     (let* ((parsed-url (url-generic-parse-url (file-name-as-directory url-or-port)))
;;            (domain (url-host parsed-url))
;;            (securep (string-match "^wss://" url-or-port)))
;;       (loop for (name content) on cookie-plist by (function cddr)
;;             for line = (mapconcat #'identity (list domain "FALSE" (car (url-path-and-query parsed-url)) (if securep "TRUE" "FALSE") "0" (symbol-name name) (concat content "\n")) "\t")
;;             do (write-region line nil (request--curl-cookie-jar) 'append))))


;;   (let ((token (ein:notebooklist-token-or-password url-or-port)))
;;     (cond ((null token) ;; don't know
;;            (ein:notebooklist-login--iteration url-or-port callback nil nil -1 nil))
;;           ((string= token "") ;; all authentication disabled
;;            (ein:log 'verbose "Skipping login %s" url-or-port)
;;            (ein:notebooklist-open* url-or-port nil nil nil callback nil))
;;            (t (ein:notebooklist-login--iteration url-or-port callback nil token 0 nil))
;;            (message "null")
;;           )
;;     )
;;   (switch-to-buffer-other-window "*ein:notebooklist https://project02.sinobestech.com.hk/user/ilya*"))

;; (defun ilya-login-jupyter (callback &optional cookie-plist)
;;   "based of ein:notebook-login, but with supplied part to connect to
;; must set the variables
;; ilj-url-or-port:		the url of the notebook server
;; ilj-buffer-name:		of the buffer that will be created
;; "
;;   (setq url-or-port ilj-url-or-port)
;;   (interactive `(,(lambda (buffer ilj-url-or-port) (pop-to-buffer buffer))
;;                  ,(if current-prefix-arg (ein:notebooklist-ask-user-pw-pair "Cookie name" "Cookie content"))))
;;   (unless callback (setq callback (lambda (buffer url-or-port))))

;;   (when cookie-plist
;;     (let* ((parsed-url (url-generic-parse-url (file-name-as-directory url-or-port)))
;;            (domain (url-host parsed-url))
;;            (securep (string-match "^wss://" url-or-port)))
;;       (loop for (name content) on cookie-plist by (function cddr)
;;             for line = (mapconcat #'identity (list domain "FALSE" (car (url-path-and-query parsed-url)) (if securep "TRUE" "FALSE") "0" (symbol-name name) (concat content "\n")) "\t")
;;             do (write-region line nil (request--curl-cookie-jar) 'append))))


;;   (let ((token (ein:notebooklist-token-or-password url-or-port)))
;;     (cond ((null token) ;; don't know
;;            (ein:notebooklist-login--iteration url-or-port callback nil nil -1 nil))
;;           ((string= token "") ;; all authentication disabled
;;            (ein:log 'verbose "Skipping login %s" url-or-port)
;;            (ein:notebooklist-open* url-or-port nil nil nil callback nil))
;;            (t (ein:notebooklist-login--iteration url-or-port callback nil token 0 nil))
;;            (message "null")
;;           )
;;     )
;;   (switch-to-buffer-other-window ilj-buffer-name))


;; (setq ein:notebooklist-login-timeout 10000)

;; (defun ilya-start-jupyter-notebook ()
;;   "Opens up either a local jupyter server or connects to east-india's one"
;;   (interactive)
;;   (let ((choices (list "✇ local" "☉ Jupyter-DreamsAI" "₿ Mayfair")))
;;     (setq temp-chosen-server (ido-completing-read "Portal to open:" choices))
;;     (if (string-equal temp-chosen-server "☉ Jupyter-DreamsAI")
;;         (progn
;;           (setq ilj-url-or-port "jupyter.dreams-ai.com/user/ilya.antonov/lab/workspaces")
;;           (setq ilj-buffer-name "*ein:notebooklist http://jupyter.dreams-ai.com/user/ilya.antonov*")
;;           (call-interactively (function ilya-login-jupyter))
;;           ))
;;     (if (string-equal temp-chosen-server "₿ Mayfair")
;;         (progn
;;           (setq ilj-url-or-port "http://61.92.238.30:8888")
;;           (setq ilj-buffer-name "*ein:notebooklist http://61.92.238:8888*")
;;           (call-interactively (function ilya-login-jupyter))
;;           ))
;;     (if (string-equal temp-chosen-server "✇ local")
;;         (call-interactively (function ein:run)))))

;; (global-set-key (kbd "C-x C-j") (function ilya-start-jupyter-notebook))

(defun ilya-login-east-india (callback &optional cookie-plist)
  "based of ein:notebook-login, but with supplied part to connect to"
  (setq url-or-port "https://project02.sinobestech.com.hk")
  (interactive `(,(lambda (buffer url-or-port) (pop-to-buffer buffer))
                 ,(if current-prefix-arg (ein:notebooklist-ask-user-pw-pair "Cookie name" "Cookie content"))))
  (unless callback (setq callback (lambda (buffer url-or-port))))

  (when cookie-plist
    (let* ((parsed-url (url-generic-parse-url (file-name-as-directory url-or-port)))
           (domain (url-host parsed-url))
           (securep (string-match "^wss://" url-or-port)))
      (loop for (name content) on cookie-plist by (function cddr)
            for line = (mapconcat #'identity (list domain "FALSE" (car (url-path-and-query parsed-url)) (if securep "TRUE" "FALSE") "0" (symbol-name name) (concat content "\n")) "\t")
            do (write-region line nil (request--curl-cookie-jar) 'append))))


  (let ((token (ein:notebooklist-token-or-password url-or-port)))
    (cond ((null token) ;; don't know
           (ein:notebooklist-login--iteration url-or-port callback nil nil -1 nil))
          ((string= token "") ;; all authentication disabled
           (ein:log 'verbose "Skipping login %s" url-or-port)
           (ein:notebooklist-open* url-or-port nil nil nil callback nil))
           (t (ein:notebooklist-login--iteration url-or-port callback nil token 0 nil))
           (message "null")
          )
    )
  (switch-to-buffer-other-window "*ein:notebooklist https://project02.sinobestech.com.hk/user/ilya*"))

(setq ein:notebooklist-login-timeout 10000)

(defun ilya-start-jupyter-notebook ()
  "Opens up either a local jupyter server or connects to east-india's one"
  (interactive)
  (let ((choices (list "✇ local" "₿ east-india-server")))
    (setq temp-chosen-server (ido-completing-read "Portal to open:" choices))
    (if (string-equal temp-chosen-server "₿ east-india-server")
        (call-interactively (function ilya-login-east-india))
      (call-interactively (function ein:run)))))

(global-set-key (kbd "C-x C-j") (function ilya-start-jupyter-notebook))

(defun ilya-save-exectute-and-goto-next ()
  "Saves the notebook → execute cell → go to next cell"
  (interactive)
  (call-interactively (function ein:notebook-save-notebook-command))
  (call-interactively (function ein:worksheet-execute-cell-and-goto-next)))

(defun ilya-save-exectute ()
  "Saves the notebook → execute cell → go to next cell"
  (interactive)
  (call-interactively (function ein:notebook-save-notebook-command))
  (call-interactively (function ein:worksheet-execute-cell)))

(with-eval-after-load "ein-notebook"
  (define-key ein:notebook-mode-map (kbd "<M-return>") (function ilya-save-exectute-and-goto-next))
  (define-key ein:notebook-mode-map (kbd "C-c C-c") (function ilya-save-exectute)))

(defun temp (url-or-port callback errback token iteration response-status)
  ;; (ein:log 'debug "Login attempt #%d in response to %s from %s."
  ;;          iteration response-status url-or-port)
  ;; (unless callback
  ;;   (setq callback #'ignore))
  ;; (unless errback
  ;;   (setq errback #'ignore))
  (ein:query-singleton-ajax
   (list 'notebooklist-login--iteration url-or-port)
   (ein:url url-or-port "login")
   :timeout 10000
   ;; :data (if token (concat "password=" (url-hexify-string token)))
   ;; :parser #'ein:notebooklist-login--parser
   ;; :complete (apply-partially #'ein:notebooklist-login--complete url-or-port)
   ;; :error (apply-partially #'ein:notebooklist-login--error url-or-port token
   ;;                         callback errback iteration)
   :success (apply-partially #'ein:notebooklist-login--success url-or-port callback
                             errback token iteration)
  ))

(with-eval-after-load "ein-notebook"
  (hungry-delete-mode)			;turns off hungry delete
  ;; (define-key ein:notebook-mode-map (kbd "DEL") (function backward-delete-char))
  ;; (define-key ein:notebook-mode-map (kbd "DEL") (function python-indent-dedent-line-backspace))
  ;; (define-key ein:notebook-mode-map (kbd "DEL") (function sp-backward-delete-char))
  (define-key ein:notebook-mode-map (kbd "'") (function self-insert-command))
  (define-key ein:notebook-mode-map (kbd "C-c C-d") (function ein:pytools-request-tooltip-or-help))
  (define-key ein:notebook-mode-map (kbd "C-c C-j") (function ein:notebook-kernel-interrupt-command))
  ;; (define-key ein:notebook-mode-map (kbd "C-c C-j") (function
  ;;                                                    (prog
  ;;                                                     (ein:notebook-kernel-interrupt-command)
  ;;                                                     (ein:worksheet-clear-all-output))))
  (define-key ein:notebook-mode-map (kbd "C-:") (function iedit-mode))
  (define-key ein:notebook-mode-map (kbd "C-c C-;") (function comment-line))
  (define-key ein:notebook-mode-map (kbd "C-c TAB") (function ein:completer-complete)))

;; language server
(use-package lsp-mode
  :ensure t
  :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package flycheck
  :ensure t
  :init
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  (add-hook 'c++-mode-hook 'flycheck-mode))

(set-face-attribute 'flycheck-error nil
                    ;; :family "Font Fira"
                    :background "#bf0004"
                    :foreground "gold2"
                    :underline nil
                    :box '(:color "gold2" :line-width 1))
(set-face-attribute 'flycheck-warning nil
                    :underline "DarkOrange")

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package magit
  :ensure t)  

(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode +1))

(use-package git-timemachine
  :ensure t)

(defhydra hydra-git-gutter (:body-pre (git-gutter-mode 1)
                                      :hint nil)
  "
  Git gutter:
    _j_: next hunk        _s_tage hunk     _q_uit
    _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
    ^ ^                   _p_opup hunk
    _h_: first hunk
    _l_: last hunk        set start _R_evision
  "
  ("j" git-gutter:next-hunk)
  ("k" git-gutter:previous-hunk)
  ("h" (progn (goto-char (point-min))
              (git-gutter:next-hunk 1)))
  ("l" (progn (goto-char (point-min))
              (git-gutter:previous-hunk 1)))
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("p" git-gutter:popup-hunk)
  ("R" git-gutter:set-start-revision)
  ("q" nil :color blue)
  ("Q" (progn (git-gutter-mode -1)
              ;; git-gutter-fringe doesn't seem to
              ;; clear the markup right away
              (sit-for 0.1)
              (git-gutter:clear))
   :color blue))

(global-set-key (kbd "M-g M-g") (function hydra-git-gutter/body))

(global-set-key (kbd "C-c c") (function org-capture))
(global-set-key (kbd "C-c a") (function org-agenda))

(setq org-agenda-files (list "~/creamy_seas/antlers.org"
                             "~/gdrive/east-data-company.org"
                             "~/gdrive/people.org"
                             "~/gdrive/adv18_sa36_automation/adventure_brief.org"
                             "~/gdrive/adv17_ext_horseBetting/adventure_brief.org"
                             "~/gdrive/adv16_sa_onFire/adventure_brief.org"))

(setq org-agenda-custom-commands
      (quote (("c" "Simple agenda view"
         ((agenda ""))))))

(setq org-capture-templates
      '(
        ;; random tasks and reminders
        ("b" "Bloat" entry (id "antlers-bloat")
         "** BLOAT %^{stuff-to-be-done}\nSHEDULED: %^T")
        ;; copy pasta
        ("c" "Copy Pasta" entry (id "copy-pasta") "** %^{Pasta Title} %t\n%?")
        ;; temporary org file on desktop
        ("d" "Draft" plain (file "~/Desktop/.temp.org")
         "%?")
        ;; tasks for neural network future
        ("e" "East-India Data Company")
        ("e2" "2am goals" entry (id "bryan-plan")
         "** DREAMS-AI %^{Project}: %^{stuff-to-be-done}\nDEADLINE: %^T")
        ("et" "Time log" table-line (id "bryan-done")
         "| %^u | %^{Project}: %^{task-summary} | %^{hours-worked} hours | |"
         :table-line-pos "@<-1")
        ;; lukes quotes
        ("l" "Boomer Entry" item (file+headline "~/creamy_seas/1488.org.gpg" "Becoming a boomer") "%^{What did Luke say} %^G\n%?"
         (file "~/creamy_seas/1488.org.gpg") "%?")
        ("p" "PhD Tasks")
        ("pp" "Photon Counting" entry (id "phd-photon")
         "*** PHD Photn Counting [/]: %^{stuff-to-be-done}\nDEADLINE: %^T\n- [ ] %?")
        ("pt" "Twin Qubit" entry (id "phd-twin")
         "*** PHD Twin Qubit [/]: %^{stuff-to-be-done}\nDEADLINE: %^T\n- [ ] %?")
        ("px" "xMon" entry (id "phd-xmon")
         "*** PHD xMon [/]: %^{stuff-to-be-done}\nDEADLINE: %^T\n- [ ] %?")
        ("pg" "General" entry (id "phd-general")
         "*** PHD General [/]: %^{stuff-to-be-done}\nDEADLINE: %^T\n- [ ] %?")
        ;; save a really good url
        ("u" "Save URL" entry (file+headline "~/creamy_seas/1488.org.gpg" "URL too good to throw away")
         "** %^L %? %^G"
         :kill-buffer t)
        ;; random stories to save
        ("s" "Stories" entry (id "stories") "** %^{Title} %t\n%?")
        ;; tutoring
        ("t" "Tutoring lessons")
        ("tw" "Nikhil Lesson (Winchester)" table-line (id "tutoring-nikhil-invoice")
         "| # | %^u | %^{lesson summary} | 120%? | |"
         :table-line-pos "III-1")
        ("tn" "Nathan Lesson" table-line (id "tutoring-nathan-invoice")
         "| # | %^u | %^{lesson summary} | 45%? | |"
         :table-line-pos "III-1")
        ("td" "Darrens Programming" table-line (id "tutoring-darren-invoice")
         "| # | %^u | %^{lesson summary} | 50%? | |"
         :table-line-pos "III-1")
        ("f" "Future Lesson")
        ("fw" "Nikhil Lesson (Winchester)" entry (id "tutoring-nikhil-lesson")
         "*** TUTORING Lesson %^{location|at Home|on Skype} covering: %^{topic-to-cover}\n%^T")
        ("fn" "Nathan Lesson" entry (id "tutoring-nathan-lesson")
         "*** TUTORING Lesson %^{location|at Home|on Skype} covering: %^{topic-to-cover}\n%^T")
        ))

(defadvice org-capture-finalize 
    (after delete-capture-frame activate)  
  "Advise capture-finalize to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
      (delete-frame)))

(defadvice org-capture-destroy 
    (after delete-capture-frame activate)  
  "Advise capture-destroy to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
      (delete-frame)))  

(use-package noflet
  :ensure t )
(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-capture)))

(use-package org-ac
  :ensure t
  :init
  (require 'org-ac)
  (org-ac/config-default)
  (setq org-ac/ac-trigger-command-keys (quote ("\\" ":" "[" "+"))) ;keys that trigger autocomplete
  ;bing the usual scrolling keys
  (define-key ac-completing-map (kbd "C-n") (function ac-next))
  (define-key ac-completing-map (kbd "C-p") (function ac-previous))
  (define-key ac-completing-map (kbd "C-v") (function ac-quick-help-scroll-down))
  (define-key ac-completing-map (kbd "M-v") (function ac-quick-help-scroll-up)))

(setq org-todo-keywords '((sequence "TODO(t)" "BLOAT(B)" "BRYAN(b)" "PHD(p)" "DREAMS-AI(a)" "WORKFORCE(w)" "SCHOOLS(s)" "TUTORING(l)" "CURRENT(c)" "|" "DOMINATED(d)")))

(setq org-todo-keyword-faces (quote (
                                     ("STARTED" . "yellow")
                                     ("CURRENT" . (:foreground "#ffff0a" :background "#754ec1" :weight bold))
                                     ("DREAMS-AI" . (:foreground "#68c3c1" :background "#fdc989" :weight bold))
                                     ("WORKFORCE" . (:background "#68c3c1" :foreground "#fdc989" :weight bold))
                                     ("PHD" . (:foreground "yellow" :background "#FF3333"))
                                     ("SCHOOLS" . (:foreground "#090C42" :background "#9DFE9D"))
                                     ("Dominated" . (:foreground "#9DFE9D" :weight bold))
                                     ("BLOAT" . (:foreground "#000001" :background "#ffffff"))
                                     ("TUTORING" . (:foreground "#090C42" :background "#FFD700": weight bold))
                                     ("BRYAN" . (:foreground "#090C42" :background "#33ccff" :weight bold)))))

(setq org-agenda-span 10)

(defun ilya-org-insert-link (&optional complete-file link-location default-description)
  "Insert a link.  At the prompt, enter the link.

Completion can be used to insert any of the link protocol prefixes in use.

The history can be used to select a link previously stored with
`org-store-link'.  When the empty string is entered (i.e. if you just
press `RET' at the prompt), the link defaults to the most recently
stored link.  As `SPC' triggers completion in the minibuffer, you need to
use `M-SPC' or `C-q SPC' to force the insertion of a space character.

You will also be prompted for a description, and if one is given, it will
be displayed in the buffer instead of the link.

If there is already a link at point, this command will allow you to edit
link and description parts.

With a `\\[universal-argument]' prefix, prompts for a file to link to.  The \
file name can be
selected using completion.  The path to the file will be relative to the
current directory if the file is in the current directory or a subdirectory.
Otherwise, the link will be the absolute path as completed in the minibuffer
\(i.e. normally ~/path/to/file).  You can configure this behavior using the
option `org-link-file-path-type'.

With a `\\[universal-argument] \\[universal-argument]' prefix, enforce an \
absolute path even if the file is in
the current directory or below.

A `\\[universal-argument] \\[universal-argument] \\[universal-argument]' \
prefix negates `org-keep-stored-link-after-insertion'.

If the LINK-LOCATION parameter is non-nil, this value will be used as
the link location instead of reading one interactively.

If the DEFAULT-DESCRIPTION parameter is non-nil, this value will
be used as the default description.  Otherwise, if
`org-make-link-description-function' is non-nil, this function
will be called with the link target, and the result will be the
default link description."
  (interactive "P")
  (let* ((wcf (current-window-configuration))
         (origbuf (current-buffer))
         (region (when (org-region-active-p)
                   (buffer-substring (region-beginning) (region-end))))
         (remove (and region (list (region-beginning) (region-end))))
         (desc region)
         (link link-location)
         (abbrevs org-link-abbrev-alist-local)
         entry all-prefixes auto-desc)
    (cond
     (t
      ;; Read link, with completion for stored links.
      (org-link-fontify-links-to-this-file)
      (org-switch-to-buffer-other-window "*Org Links*")
      (let ((cw (selected-window)))
        (select-window (get-buffer-window "*Org Links*" 'visible))
        (with-current-buffer "*Org Links*" (setq truncate-lines t))
        (unless (pos-visible-in-window-p (point-max))
          (org-fit-window-to-buffer))
        (and (window-live-p cw) (select-window cw)))
      (setq all-prefixes (append (mapcar 'car abbrevs)
                                 (mapcar 'car org-link-abbrev-alist)
                                 (org-link-types)))
      (unwind-protect
          ;; Fake a link history, containing the stored links.
          (let ((org--links-history
                 (append (mapcar #'car org-stored-links)
                         org-insert-link-history)))
            (setq link "file")
            (unless (org-string-nw-p link) (user-error "No link selected"))
            (dolist (l org-stored-links)
              (when (equal link (cadr l))
                (setq link (car l))
                (setq auto-desc t)))
            (when (or (member link all-prefixes)
                      (and (equal ":" (substring link -1))
                           (member (substring link 0 -1) all-prefixes)
                           (setq link (substring link 0 -1))))
              (setq link (with-current-buffer origbuf
                           (org-link-try-special-completion link)))))
        (set-window-configuration wcf)
        (kill-buffer "*Org Links*"))
      (setq entry (assoc link org-stored-links))
      (or entry (push link org-insert-link-history))
      (setq desc (or desc (nth 1 entry)))))

    (when (funcall (if (equal complete-file '(64)) 'not 'identity)
                   (not org-keep-stored-link-after-insertion))
      (setq org-stored-links (delq (assoc link org-stored-links)
                                   org-stored-links)))

    (when (and (string-match org-plain-link-re link)
               (not (string-match org-ts-regexp link)))
      ;; URL-like link, normalize the use of angular brackets.
      (setq link (org-unbracket-string "<" ">" link)))

    ;; Check if we are linking to the current file with a search
    ;; option If yes, simplify the link by using only the search
    ;; option.
    (when (and buffer-file-name
               (let ((case-fold-search nil))
                 (string-match "\\`file:\\(.+?\\)::" link)))
      (let ((path (match-string-no-properties 1 link))
            (search (substring-no-properties link (match-end 0))))
        (save-match-data
          (when (equal (file-truename buffer-file-name) (file-truename path))
            ;; We are linking to this same file, with a search option
            (setq link search)))))

    ;; Check if we can/should use a relative path.  If yes, simplify
    ;; the link.
    (let ((case-fold-search nil))
      (when (string-match "\\`\\(file\\|docview\\):" link)
        (let* ((type (match-string-no-properties 0 link))
               (path-start (match-end 0))
               (search (and (string-match "::\\(.*\\)\\'" link)
                            (match-string 1 link)))
               (path
                (if search
                    (substring-no-properties
                     link path-start (match-beginning 0))
                  (substring-no-properties link (match-end 0))))
               (origpath path))
          (cond
           ((or (eq org-link-file-path-type 'absolute)
                (equal complete-file '(16)))
            (setq path (abbreviate-file-name (expand-file-name path))))
           ((eq org-link-file-path-type 'noabbrev)
            (setq path (expand-file-name path)))
           ((eq org-link-file-path-type 'relative)
            (setq path (file-relative-name path)))
           (t
            (save-match-data
              (if (string-match (concat "^" (regexp-quote
                                             (expand-file-name
                                              (file-name-as-directory
                                               default-directory))))
                                (expand-file-name path))
                  ;; We are linking a file with relative path name.
                  (setq path (substring (expand-file-name path)
                                        (match-end 0)))
                (setq path (abbreviate-file-name (expand-file-name path)))))))
          (setq link (concat type path (and search (concat "::" search))))
          (when (equal desc origpath)
            (setq desc path)))))

    (unless auto-desc
      (let ((initial-input
             (cond
              (default-description)
              ((not org-make-link-description-function) desc)
              (t (condition-case nil
                     (funcall org-make-link-description-function link desc)
                   (error
                    (message "Can't get link description from `%s'"
                             (symbol-name org-make-link-description-function))
                    (sit-for 2)
                    nil))))))
        (setq desc link)
        ;; (setq desc (read-string "Description: " initial-input))
        ))

    (unless (string-match "\\S-" desc) (setq desc nil))
    (when remove (apply 'delete-region remove))

    (insert (org-make-link-string link desc))
    ;; Redisplay so as the new link has proper invisible characters.
    (sit-for 0)))

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
(add-to-list 'org-structure-template-alist
             '("py" "#+BEGIN_SRC python \n ? \n #+END_SRC"))
(add-to-list 'org-structure-template-alist
             '("sh" "#+BEGIN_SRC shell \n ? \n #+END_SRC"))

(add-hook 'org-mode-hook 'org-indent-mode)

(use-package ox-twbs
  :ensure t
)

(defun my-org-inline-css-hook (exporter)
  "Insert custom inline css"
  (when (eq exporter 'html)
    (let* ((dir (ignore-errors (file-name-directory (buffer-file-name))))
           (path (concat dir "style.css"))
           (homestyle (or (null dir) (null (file-exists-p path))))
           (final (if homestyle "~/creamy_seas/sync_files/emacs_config/support_files/org_style.css" path)))
      (setq org-html-head-include-default-style nil)
      (setq org-html-head (concat
                           "<style type=\"text/css\">\n"
                           "<!--/*--><![CDATA[/*><!--*/\n"
                           (with-temp-buffer
                             (insert-file-contents final)
                             (buffer-string))
                           "/*]]>*/-->\n"
                           "</style>\n")))))

(eval-after-load 'ox
  '(progn
     (add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)))

;;(use-package ox-reveal
;;  :ensure t)
;;(use-package htmlize
;;  :ensure t)
;;(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")

(defmath gradeBand(score)
  (if (< score 1)
      "DNS"
    (if (< score 40)
        "Working"
      (if (< score 50)
          "3rd"
        (if (< score 60)
            "2:2"
          (if (< score 70)
              "2:1"
            "1st"))))))

(setq org-format-latex-options (plist-put org-format-latex-options
                                          :scale 1.7))
(setq org-format-latex-options (plist-put org-format-latex-options
                                          :foreground "#fdab10"))

(define-key org-mode-map (kbd "<C-return>") (function org-insert-heading))
(define-key org-mode-map (kbd "C-x RET") (function org-insert-subheading))
(define-key org-mode-map (kbd "C-c C-;") (function comment-line))
(define-key org-mode-map (kbd "C-c C-r") (function org-toggle-inline-images))
(define-key emacs-lisp-mode-map (kbd "C-c C-;") (function comment-line))
(global-set-key "\C-cb" 'org-switchb)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)

(setq inkscape-generate-location "~/creamy_seas/sync_files/emacs_config/ilya_scripts/inkscape/inkscape_generate.sh")

(defun inkscape-generate (base-directory)
  "Reads the current line and launches an inkscape document under this name. Base directory must end in /"
  (interactive)
  (let* (;; a - generate filename
         (file-name (ilya-copy-line))	;reads in current line
         (file-name (replace-regexp-in-string "^\s*" "" file-name))
        (file-name (downcase file-name)) ;downcase
        (file-name (replace-regexp-in-string " " "_" file-name)) ;replace spaces
        ;; b - find root folder and create a directory path
        (inkscape-dir (concat base-directory "images_inkscape"))
        ;; c - generate full path name
        (file-name-full (concat inkscape-dir "/" file-name)))

    ;; 1 - create directory in root folder
    (ignore-errors (make-directory inkscape-dir))

    ;; 2 - open inkscape with the file-name
    (shell-command (concat inkscape-generate-location " \"" file-name-full "\""))

    ;; 3 - prepare for snippet
    (setq temp-file-name-for-snippet file-name)
    (delete-region (line-beginning-position) (line-end-position))
    ))

(defun inkscape-load-part1 (base-directory)
  "Part 1 of the loading image process: store the old default directory and write a new one base-directoy MUST END WITH /"

  ;; 1 - create path to inkscape directory and save the old default directory
  (setq inkscape-directory (concat base-directory "images_inkscape"))
  (setq old-default-directory default-directory)

  ;; 2 - reset the default directory to the inkscape one if it exists
  (if (null (file-directory-p inkscape-directory))
      (message "卍 But mein führer - they have been exterminated 卍")
    (setq default-directory inkscape-directory)))

(defun inkscape-load-part2 (file-name-full)
  "Uses the currently set default-directory and asks the user to open an image file"
  (interactive "fWhich image to open: ")

  ;; 1 - cope the last part of the file
  (setq file-name-full (replace-regexp-in-string "\\..*$" "" file-name-full))

  ;; 2 - reset back to the previous default directory
  (setq default-directory old-default-directory)

  ;; 3 - open the file for editing
  (shell-command (concat inkscape-generate-location " " file-name-full)))

(defun inkscape-load (base-directory)
  "Loads up a user chosen inkscape file"
  (interactive)
  (inkscape-load-part1 base-directory)
  (call-interactively 'inkscape-load-part2))

(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/creamy_seas/sync_files/emacs_config/elfeed.org")))

(use-package elfeed
  :ensure t
  :init
  (setq elfeed-db-directory "~/creamy_seas/sync_files/emacs_config/elfeeddb")
  (setq-default elfeed-search-filter "+unread")
  :bind
  (:map elfeed-search-mode-map
        ("*" . bjm/elfeed-star)
        ("8" . bjm/elfeed-unstar)
        ("q" . bjm/elfeed-save-db-and-bury)
        ("h" . make-hydra-elfeed)
        ("H" . make-hydra-elfeed))
  )

(require 'hydra)
(defhydra hydra-elfeed (global-map "<f5>")
  ""
  ("p" (elfeed-search-set-filter "+prog") "programming")
  ("l" (elfeed-search-set-filter "+boomer") "luke boomer")
  ("s" (elfeed-search-set-filter "+strat") "stratechery")
  ("i" (elfeed-search-set-filter "+starred") "shiny star")
  ("*" bjm/elfeed-star "star it" :color pink)
  ("8" bjm/elfeed-unstar "unstar it" :color pink)
  ("a" (elfeed-search-set-filter "@5-year-ago") "all")
  ("u" (elfeed-search-set-filter "+unread") "unread")
  ("q" bjm/elfeed-save-db-and-bury "quit" :color blue)
  )

;;function that is associated with "H" keybinding in elfeed mode
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
elfeed-search-header-function
(custom-set-faces
 '(elfeed-search-date-face
   ((t :foreground "#11a"
       :weight bold))))
 '(elfeed-search-feed-face
   ((t :foreground "#444"
       :weight bold)))
 '(elfeed-search-title-face
   ((t :foreground "#3ef"
       :weight bold)))

(defface elfeed-search-starred-title-face
  '((t :foreground "#f77"
       :weight extra-bold
       :underline t))
  "marks a starred Elfeed entry")

(push '(starred elfeed-search-starred-title-face) elfeed-search-face-alist)

;; (add-hook 'elfeed-new-entry-hook
;;          (elfeed-make-tagger :feed-url "stratechery.com/feed/"
;;                              :entry-title '("Exponent Podcast:.*")
;;                              :add 'podcast
;;                              :remove 'unread))

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

(add-hook 'sh-mode-hook (lambda ()
                              (define-key sh-mode-map (kbd "C-c C-;") (function comment-line))))

(defun ilya-figlet (string-to-convert)
  "Converts 'string-to-convert' to ascii art and inserts it into buffer

  string-to-convert:	string to turn to art
  "
  (interactive "sString to make into art: ")
  (setq ascii-art (shell-command-to-string (concat "figlet -k" " " string-to-convert)))
  (setq ascii-art (replace-regexp-in-string "^"
                                            comment-start
                                            ascii-art))
  (insert ascii-art)
  )

(use-package yasnippet
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)
  (add-hook 'LaTeX-mode-hook 'yas-minor-mode)
  (add-hook 'python-mode-hook 'yas-minor-mode)
  (add-hook 'org-mode-hook 'yas-minor-mode)
  (add-hook 'c++-mode-hook 'yas-minor-mode)
  (add-hook 'shell-mode-hook 'yas-minor-mode)
  (add-hook 'rust-mode-hook 'yas-minor-mode)
  (add-hook 'markdown-mode-hook 'yas-minor-mode)

  :config
  (add-to-list 'yas-snippet-dirs "~/creamy_seas/sync_files/emacs_config/snippets/snippet-mode")

  (use-package yasnippet-snippets	;the snippets file
    :ensure t)

  (yas-reload-all))

(defun yas/insert-by-name (name)
  (cl-flet ((dummy-prompt
          (prompt choices &optional display-fn)
          (declare (ignore prompt))
          (or (find name choices :key display-fn :test #'string=)
              (throw 'notfound nil))))
    (let ((yas/prompt-functions '(dummy-prompt)))
      (catch 'notfound
        (yas/insert-snippet t)))))

(use-package auto-yasnippet
  :ensure t)

(use-package company
  :ensure t
  :config
  (add-hook 'org-mode-hook 'company-mode)
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'text-mode-hook 'company-mode)
  (add-hook 'inferior-python-mode-hook 'company-mode)
  (add-hook 'LaTeX-mode-hook 'company-mode)
  (add-hook 'c++-mode-hook 'company-mode)

  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 4))

(use-package company
  :ensure t
  :init
  (custom-set-faces
   ;; annotation (i.e. function or method)
   `(company-tooltip-annotation ((t (:foreground "#CFD0E3"))))
   `(company-tooltip-annotation-selection ((t (:foreground "#334676"))))
   ;; scrollbar showing position in list
   `(company-scrollbar-bg ((t (:background "#189a1e1224a2"))))
   `(company-scrollbar-fg ((t (:background "#41bf505b61e3"))))
   ;; text being expanded
   `(company-tooltip-common ((t (:foreground "#33ccff"))))
   `(company-tooltip-common-selection ((t (:foreground "#3a3a6e" :weight bold))))
   ;; autocompletion selection
   `(company-tooltip-selection ((t (:background "orange2" :foreground "#090C42" :weight bold))))
   ;; change background of the box
   `(company-tooltip ((t (:inherit default :background "#41bf505b61e3"))))
   ))

(with-eval-after-load 'company;;remap navigation only if company mode is loaded
  ;;cancel some keys, and activate others
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  )

(setq bookmark-save-flag t) 		;save bookmars to file
(when (file-exists-p (concat user-emacs-directory "bookmarks"))
  (bookmark-load bookmark-default-file t)) ;load boomarks from "~/.emacs.d/bookmarks"
(setq bookmark-default-file (concat user-emacs-directory "bookmarks"))

(global-set-key (kbd "<f6>") 'bookmark-set)
(global-set-key (kbd "<f7>") 'bookmark-jump)
(global-set-key (kbd "<f8>") 'bookmark-bmenu-list)

(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list))) ;;mapc is a for loop, running 'function to the supplied (list)
(global-set-key (kbd "C-x a b") 'kill-all-buffers)

(global-set-key (kbd "C-x b") 'ibuffer)
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("⍫ Magit" (or
                           (name . "^.*gitignore$")
                           (name . "^magit.*$")))
               ("ᛔ Jupyter" (or
                             (mode . "ein:notebooklist-mode")
                             (name . "\\*ein:.*")
                             ))
               ("ᛥ Dired" (mode . dired-mode))
               ("ᚧ Python" (or
                            (mode . python-mode)
                            (mode . inferior-python-mode)
                            (name . "^\\*Python Doc\\*$")
                            (name . "^matplotlibrc$")
                            (name . "^.*mplstyle$")
                            (name . "^\\*Flycheck error messages\\*$")))
               ("ᛋᛋ Latex" (or
                            (name . "^.*tex$")
                            (name . "^.*bib$")
                            (name . "^.*log$")
                            (name . "\\*RefTeX Select\\*")
                            (name . "^\\*toc\\*$")
                            (mode . comint-mode)))
               ("ᚸ Org" (name . "\\.org"))
               ("⚓ Shell" (name . "\\.sh"))
               ("෴ PDF" (name . "\\.pdf"))
               ("卍 Config" (name . "^\\..*$"))
               ("ᛓ Elfeed" (or
                            (name . "\\*elfeed.*\\*")
                            (name . "^ef.*$")))
               ))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "default")))

;; (" Emacs" (or
;;               (name . "^\\*scratch\\*$")
;;               (name . "^\\*Messages\\*$")
;;               (name . "^\\*Backtrace\\*$")))
;; ("卍 Horter" (or
;;               (name . "^\\*dashboard\\*$")
;;               (mode . emacs-lisp-mode)))
;;(add-to-list `ibuffer-never-show-predicates "*Completions*")
;;  (add-to-list `ibuffer-never-show-predicates "*Help*")
;; (add-to-list `ibuffer-never-show-predicates "*elfeed-log*")

(setq ibuffer-formats 
      '((mark
         modified
         "   "
         (mode 20 30 :left)
         "   "
         ;; (size 9 -1 :right)
         (name 10 70 :left);; :elide)
         "   "
         )
              ;; " "
              ;; (mode 50 50 :left :elide)
              ;; " " filename-and-process)
        ;; (mark " "
              ;; (name 16 -1)
              ;; " " filename)
      ))

(setq mp/ibuffer-collapsed-groups (list "Default" "*Internal*" "ᛓ Elfeed"))
;; (setq mp/ibuffer-collapsed-groups (list "*Internal*"))

(defadvice ibuffer (after collapse-helm)
  (dolist (group mp/ibuffer-collapsed-groups)
          (progn
            (goto-char 1)
            (when (search-forward (concat "[ " group " ]") (point-max) t)
              (progn
                (move-beginning-of-line nil)
                (ibuffer-toggle-filter-group)
                )
              )
            )
          )
    (goto-char 1)
    (search-forward "[ " (point-max) t)
  )

(setq ido-enable-flex-matching nil)
(setq ido-create-new-bffer 'always)
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

(eval-after-load "calendar" '(progn
  (define-key calendar-mode-map "<" 'lawlist-scroll-year-calendar-backward)
  (define-key calendar-mode-map ">" 'lawlist-scroll-year-calendar-forward) ))

(defun year-calendar (&optional month year)
  "Generate a one (1) year calendar that can be scrolled by month in each direction.
This is a modification of:  http://homepage3.nifty.com/oatu/emacs/calendar.html
See also:  http://ivan.kanis.fr/caly.el"
(interactive)
  (require 'calendar)
  (let* (
      (current-year (number-to-string (nth 5 (decode-time (current-time)))))
      (month (if month month
        (string-to-number
          (read-string "Please enter a month number (e.g., 1):  " nil nil "1"))))
      (year (if year year
        (string-to-number
          (read-string "Please enter a year (e.g., 2014):  "
            nil nil current-year)))))
    (switch-to-buffer (get-buffer-create calendar-buffer))
    (when (not (eq major-mode 'calendar-mode))
      (calendar-mode))
    (setq displayed-month month)
    (setq displayed-year year)
    (setq buffer-read-only nil)
    (erase-buffer)
    ;; horizontal rows
    (calendar-for-loop j from 0 to 3 do
      ;; vertical columns
      (calendar-for-loop i from 0 to 2 do
        (calendar-generate-month
          ;; month
          (cond
            ((> (+ (* j 3) i month) 12)
              (- (+ (* j 3) i month) 12))
            (t
              (+ (* j 3) i month)))
          ;; year
          (cond
            ((> (+ (* j 3) i month) 12)
             (+ year 1))
            (t
              year))
          ;; indentation / spacing between months
          (+ 5 (* 25 i))))
      (goto-char (point-max))
      (insert (make-string (- 10 (count-lines (point-min) (point-max))) ?\n))
      (widen)
      (goto-char (point-max))
      (narrow-to-region (point-max) (point-max)))
    (widen)
    (goto-char (point-min))
    (setq buffer-read-only t)))

(defun lawlist-scroll-year-calendar-forward (&optional arg event)
  "Scroll the yearly calendar by month in a forward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (unless arg (setq arg 1))
  (save-selected-window
    (if (setq event (event-start event)) (select-window (posn-window event)))
    (unless (zerop arg)
      (let* (
            (month displayed-month)
            (year displayed-year))
        (calendar-increment-month month year arg)
        (year-calendar month year)))
    (goto-char (point-min))
    (run-hooks 'calendar-move-hook)))

(defun lawlist-scroll-year-calendar-backward (&optional arg event)
  "Scroll the yearly calendar by month in a backward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (lawlist-scroll-year-calendar-forward (- (or arg 1)) event))

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

(delete-selection-mode t)

(use-package iedit
  :ensure t
  :config
  (global-set-key (kbd "C-:") (function iedit-mode)))

(setq inhibit-startup-screen t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 40)))
  (setq dashboard-startup-banner "~/creamy_seas/gallery_road/pepe/ree.png")
  (setq dashboard-banner-length 300)
  ;;   (setq dashboard-banner-logo-title "- Dinner is 2030. And dinner is first\n              - Respond with exact timings for commitments\n              - Understand that it is hard being pregnant"))
  (setq dashboard-banner-logo-title "Привет от Леонта!"))

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g p" . dumb-jump-back)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;;
  :ensure t)

(use-package eyebrowse
  :ensure t)

(eyebrowse-mode)3

(use-package hydra
  :ensure t)

(use-package hideshow-org
    :ensure t
    :config
    (add-hook 'elpy-mode-hook 'hs-minor-mode))

(defhydra hydra-python-collapse
  (:color pink				;all colors pink by default
          :timeout 1488
          :hint nil
          :foreign-keys run		;when non hydra keys are pressed, keep it open
          :pre (progn(			;what to do when hydra is on
                      set-cursor-color "#40e0d0"))
          :post (progn			;hydro turned off
                  (set-cursor-color "#ffd700")
                  (message
                   "↪ 13 percent of the population accounts for 50 percent of the crime rate")))
  "
^Hide^                        ^Show^         
^^^^^^^^------------------------------------ 
_a_: all                      _A_: All
_b_: block                    _B_: Block
_l_: level                                   

"
  ("a" hs-hide-all)
  ("A" hs-show-all)
  ("l" hs-hide-level)
  ("b" hs-hide-block)
  ("B" hs-show-block)
  ;; ("[TAB]" hs-toggle-hiding "toggle hiding")
  ("t" hs-toggle-hiding "toggle hiding")
  ("q" nil "quit")
  )

(define-key elpy-mode-map (kbd "C-c C-h") (function hydra-python-collapse/body))

;;(windmove-default-keybindings)

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 8)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty) 
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "g" "h" "j"))
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

(use-package swiper
  :ensure t
  :config
  (global-set-key (kbd "C-s") 'swiper))

(global-subword-mode 1)

;;  (display-time-mode 1)

(use-package linum-relative
  :ensure t
  :init
  (setq linum-relative-backend 'display-line-numbers-mode)
  (add-hook 'python-mode-hook 'linum-relative-mode)
  (add-hook 'LaTeX-mode-hook 'linum-relative-mode))

;; (use-package pdf-tools
;;   :ensure t
;;   :config
;;   (pdf-tools-install))

(use-package org-pdfview
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))
   ;; (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
   ;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(defhydra hydra-projectile-other-window (:color teal)
  "projectile-other-window"
  ("f"  projectile-find-file-other-window        "file")
  ("g"  projectile-find-file-dwim-other-window   "file dwim")
  ("d"  projectile-find-dir-other-window         "dir")
  ("b"  projectile-switch-to-buffer-other-window "buffer")
  ("q"  nil                                      "cancel" :color blue))

(defhydra hydra-projectile (:color teal
                            :hint nil)
  "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
 _fd_: file curr dir   _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
  _r_: recent file                                               ^^^^_z_: cache current
  _d_: dir

"
  ("a"   projectile-ag)
  ("b"   projectile-switch-to-buffer)
  ("c"   projectile-invalidate-cache)
  ("d"   projectile-find-dir)
  ("s-f" projectile-find-file)
  ("ff"  projectile-find-file-dwim)
  ("fd"  projectile-find-file-in-directory)
  ("g"   ggtags-update-tags)
  ("s-g" ggtags-update-tags)
  ("i"   projectile-ibuffer)
  ("K"   projectile-kill-buffers)
  ("s-k" projectile-kill-buffers)
  ("m"   projectile-multi-occur)
  ("o"   projectile-multi-occur)
  ("s-p" projectile-switch-project "switch project")
  ("p"   projectile-switch-project)
  ("s"   projectile-switch-project)
  ("r"   projectile-recentf)
  ("x"   projectile-remove-known-project)
  ("X"   projectile-cleanup-known-projects)
  ("z"   projectile-cache-current-file)
  ("`"   hydra-projectile-other-window/body "other window")
  ("q"   nil "cancel" :color blue))

;; (use-package smartparens
;;   :ensure t
;;   :hook (prog-mode . smartparens-mode)
;;   :config
;;   (require 'smartparens-config)
;;   :bind
;;   (("C-<down>" . sp-down-sexp)
;;    ("C-<up>" . sp-up-sexp)
;;    ("M-<down>" . sp-backward-down-sexp)
;;    ("M-<up>" . sp-backward-up-sexp)))

;; ;; highlight brackets
;; (show-paren-mode)

;; ;; remap delete-char → sp-delete-char to always preserve brackets
;; (smartparens-global-strict-mode)
;; (use-package smartparens
;;   :ensure t
;;   :config
;;   (require 'smartparens-config)
;;   :bind
;;   (("C-<down>" . sp-down-sexp)
;;    ("C-<up>" . sp-up-sexp)
;;    ("M-<down>" . sp-backward-down-sexp)
;;    ("M-<up>" . sp-backward-up-sexp)))

;; (add-hook 'LaTeX-mode-hook 'smartparens-strict-mode)
;; (add-hook 'prog-mode-hook 'smartparens-strict-mode)

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode 1))
(global-set-key (kbd "M-/") 'undo-tree-visualize)

(use-package diminish
    :ensure t
    :init
    (diminish 'hungry-delete-mode)
    (diminish 'beacon-mode)		
    (diminish 'which-key-mode)
    (diminish 'undo-tree-mode)
    (diminish 'rainbow-mode)
    (diminish 'subword-mode)
    (diminish 'visual-line-mode)
    (diminish 'org-indent-mode)
    (diminish 'prettify-symbols-mode)
    (diminish 'hl-line-mode)
    (diminish 'column-number-mode)
    (diminish 'line-number-mode)
    (diminish 'linum-relative-mode)
    (diminish 'flyspell-mode)
    (diminish 'cdlatex-mode)
    (diminish 'tex-scale-mode)		;changing the scale
)

(defun python-args-to-docstring-numpy ()
 "return docstring format for the python arguments in yas-text"
 (let* ((args (python-split-args yas-text))
        (format-arg (lambda(arg)
                      (concat "    " (nth 0 arg) " : " (if (nth 1 arg) ", optional") "\n")))
        (formatted-params (mapconcat format-arg args "\n"))
        (formatted-ret (mapconcat format-arg (list (list "out")) "\n    ")))
   (unless (string= formatted-params "")
     (mapconcat 'identity
                (list "\n    Parameters\n    ----------" formatted-params
                      "\n    Returns\n    -------" formatted-ret)
                "\n"))))

(define-prefix-command 'ilya-map)
(global-set-key (kbd "C-z") 'ilya-map)
(define-key ilya-map (kbd "m") (function mu4e))
(define-key ilya-map (kbd "s") (function aya-create))
(define-key ilya-map (kbd "y") (function aya-expand))
(define-key ilya-map (kbd "f") (function elfeed))
(define-key ilya-map (kbd "p") (function hydra-projectile/body))

(define-key key-translation-map (kbd "C-x 8 h") (kbd "卍"))
(define-key key-translation-map (kbd "C-x 8 w") (kbd "🐳"))
(define-key key-translation-map (kbd "C-x 8 W") (kbd "🐋"))
(define-key key-translation-map (kbd "C-x 8 O") (kbd "Ω"))
(define-key key-translation-map (kbd "C-x 8 #") (kbd "£"))
(define-key key-translation-map (kbd "C-x 8 -") (kbd "→"))
(define-key key-translation-map (kbd "C-x 8 t") (kbd "✔"))
(define-key key-translation-map (kbd "C-x 8 c") (kbd "✘"))
(define-key key-translation-map (kbd "C-x 8 b") (kbd "⦿"))
(define-key key-translation-map (kbd "C-x 8 _") (kbd "̲"))
(define-key key-translation-map (kbd "C-x 8 q") (kbd "\""))
(global-set-key (kbd "C-c C-;") (function comment-line))
(global-set-key (kbd "C-x m")  'rename-file-and-buffer)
(global-unset-key (kbd "C-c q"))
(global-unset-key (kbd "C-x #"))
(global-unset-key (kbd "C-o"))
(global-unset-key (kbd "ESC ESC ESC"))
(global-set-key (kbd "C-x C-i") (function server-edit))

(hydra-python-vi/body)

(unless (server-running-p)
       (server-start))

(put 'dired-find-alternate-file 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)	;set goal column, so that with next line you stay in same column

(toggle-frame-fullscreen)

(global-set-key (kbd "C-(") 'mc/mark-next-lines)
(global-set-key (kbd "C-)") 'mc/mark-previous-lines)

;; (setq python-shell-interpreter "python3.7"
;;       python-shell-interpreter-args "-i")

;;(setq python-shell-interpreter "jupyter"
;;      python-shell-interpreter-args "console --simple-prompt"
;;      python-shell-prompt-detect-failure-warning nil)
;;(add-to-list 'python-shell-completion-native-disabled-interpreters
;;             "jupyter")

;;(setq python-shell-interpreter "ipython"
;;      python-shell-interpreter-args "-i --simple-prompt")

;; (setq kill-buffer-query-functions nil)

;; (defvar my-term-shell "/bin/bash")
;; (defadvice ansi-term (before force-bash)
;;   (interactive (list my-term-shell)))
;; (ad-activate 'ansi-term)

;; (use-package dmenu
;;   :ensure t
;;   :bind
;;   ("s-SPC" . 'dmenu))
