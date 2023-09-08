;;; Compiled snippets and support files for `markdown-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'markdown-mode
                     '(("warn" "<aside class=\"warning\">\n$0\n</aside>\n" "my-warning" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/markdown-mode/my-warning" nil nil)
                       ("success" "<aside class=\"success\">\n$0\n</aside>\n" "my-success" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/markdown-mode/my-sucess" nil nil)
                       ("no" "<aside class=\"notice\">\n$0\n</aside>\n" "my-notice" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/markdown-mode/my-notice" nil nil)
                       ("co" "<details>\n<summary>Click this to collapse/fold.</summary>\n\n${1: text-here}\n\n</details>\n" "collapse" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/markdown-mode/my-collapse" nil nil)
                       ("href" "<a href=\"${1:link}\">${2:content}$0</a>" "ilya-href" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/markdown-mode/ilya-href" nil nil)
                       ("red" "<font color=red>$1</font>" "font-red" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/markdown-mode/font-red" nil nil)))


;;; Do not edit! File generated at Sun Apr 10 20:02:43 2022
