(defun compile_initial_program (list-of-org-file)
  (while iter
    (let ((file-name (car iter))))
    (find-file file-name)

    (org-babel-tangle)
    (rename-file el-compiled-file el-emacs-file t)
    (setq package-list-as-string
	  (append
					; actually there is only one element when the get the 'car' of the current item. But without list appending acts strage
	   (list
	    (prin1-to-string (car iter)))
	   package-list-as-string))
    (find-file "/Users/CCCP/creamy_seas/sync_files/emacs_config/base.org")
    (org-babel-tangle)
    ))


(load (concat user-emacs-directory "preliminary.el"))
