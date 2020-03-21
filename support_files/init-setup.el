(require 'ob-tangle)

(defun init/fetch-config-files ()
  (with-temp-buffer
    (insert-file-contents (concat user-emacs-directory "./support_files/my_org_files.txt"))
    (sort
     (split-string
					; select the whole buffer
      (buffer-substring-no-properties
       (point-min)
       (point-max))
      "\n" t)
     'string<)))

(defun init/compile-config-files ()
  "Go through each config file and tangle it"
  (dolist (org-file (init/fetch-config-files))
    (let ((prog-mode-hook nil)
	  (org-file-path (concat user-emacs-directory org-file))
	  (el-file-path (concat
			 user-emacs-directory
			 (replace-regexp-in-string "\.org" "\.el" org-file))))

					; Tangle the file -> get name of file -> move it to folder
      (rename-file
       (car (org-babel-tangle-file org-file-path))
       el-file-path t)
      (byte-compile-file el-file-path t)
      (message (concat ">>>>>>>>>> Compiled and loaded " el-file-path)))))
(init/compile-config-files)

(defun init/overwrite ()
  "Replace content of this file with the init-final"
  (copy-file (concat user-emacs-directory "./support_files/init-final.el")
	     (concat user-emacs-directory "init.el")
	      t)
  (load-file (concat user-emacs-directory "init.el")))
(init/overwrite)
