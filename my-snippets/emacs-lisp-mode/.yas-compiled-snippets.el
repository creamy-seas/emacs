;;; Compiled snippets and support files for `emacs-lisp-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-lisp-mode
                     '(("upa" "(use-package ${1:pakage-name}\n  :ensure t\n  :init (my/add-to-package-list '$1)$0)" "use-package-add-to-hashmap" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/emacs-lisp-mode/use-package-add-to-hashmap" nil nil)
                       ("up" "(use-package ${1:package-name}\n:ensure t\n:init (my/add-to-package-list '$1)$0)" "use-package" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/emacs-lisp-mode/use-package" nil nil)))


;;; Do not edit! File generated at Sun Apr 10 20:02:43 2022
