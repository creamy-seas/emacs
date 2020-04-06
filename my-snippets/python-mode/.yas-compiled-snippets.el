;;; Compiled snippets and support files for `python-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'python-mode
		     '(("pltx" "plt.plot(x,y,marker=\"${1:insertmehere}\")\nplt.show()" "test" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/test" nil nil)
		       ("pr" "print(${1:to-print})$0" "print" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/print" nil nil)
		       ("imp" "import numpy as np\nimport matplotlib as mpl\nimport matplotlib.pyplot as plt\n\n$0" "import-standard" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/import-standard" nil nil)
		       ("bct" "########################################\n# 📔 ${1:title}\n########################################\n$0" "big comment task" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/ilya-big-comment-task" nil nil)
		       ("bce" "########################################\n# 🍏 ${1:title}\n########################################\n$0\n" "big comment example" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/ilya-big-comment-example" nil nil)
		       ("bc" "########################################\n# ⦿ ${1:title}\n########################################\n$0" "ilya-big-comment" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/ilya-big-comment" nil nil)
		       ("com" "\"\"\"${1:description of function does}\n${2:__ Parameters __\n${3:parameter me up}}\n\n${4:__ Return __\n${5:any return values}}$0\n\"\"\"\n" "comment" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/python-mode/comment" nil nil)))


;;; Do not edit! File generated at Sun Apr  5 14:00:01 2020
