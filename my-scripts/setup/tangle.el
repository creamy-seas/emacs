(require 'ob-tangle)

(defun tangle-config-files (doom-directory)
  "Go through each config file and tangle it"
  (dolist (org-file
           ;; Remove files that are not org files and not one of the default doom files
         (cl-remove-if-not
          (lambda (x)
	    (and
            (equal "org" (file-name-extension x))
	    (not (string-match "\\(README\\|cheatsheet\\).org" x))))
          (directory-files doom-directory)))
    (let (
          (prog-mode-hook nil)
	  (org-file-name (concat doom-directory org-file))
	  (el-file-name (concat doom-directory
			        (replace-regexp-in-string "\.org" "\.el" org-file))))
      (org-babel-tangle-file org-file-name el-file-name "emacs-lisp")
       (byte-compile-file el-file-name)
       (message (concat "۞ Compiled and loaded " el-file-name)))))

