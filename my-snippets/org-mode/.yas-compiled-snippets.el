;;; Compiled snippets and support files for `org-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'org-mode
                     '(("rr" "| | /${1:Process}/ | ${2:=${3:Equipment}=} | ${4:Materials}| | ${5:param-1} | ${6:param-2} | ${7:param-3} | ${8:param-4} |" "recipe-row" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/recipe-row" nil nil)
                       ("rn" "|-\n| | Process | Equipment | Material | | Param-1 | Param-2 | Param-3 | Param-4 |\n| / | <> | <> | < | | | | | > |\n$0" "recipe-new" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/recipe-new" nil nil)
                       ("warn" "#+begin_warning\n${1:warning-content}\n#+end_warning" "my-warning" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-warning" nil nil)
                       ("tip" "#+begin_tip\n${1:tip}\n#+end_tip" "my-tip" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-tip" nil nil)
                       ("sidebar" "#+begin_sidebar\n${1:content that will be shown in sidebar}\n#+end_sidebar" "my-sidebar" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-sibebar" nil nil)
                       ("quote" "#+begin_quote\n${1:quote-content}\n#+end_quote\n" "my-quote" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-quote" nil nil)
                       ("oh" "#+ATTR_ORG: :width ${1:200px}" "my-org-height" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-org-height" nil nil)
                       ("al" "\\begin{aligned}\n$0\n\\end{aligned}" "my-org-aligned" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-org-aligned" nil nil)
                       ("note" "#\n#+begin_note\n${1:note-content}\n#+end_note" "my-note" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-note" nil nil)
                       ("important" "#+begin_important\n${1:important-content}\n#+end_important" "my-important" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-important" nil nil)
                       ("hh" "#+ATTR_HTML: :height ${1:200px}" "my-html-height" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-html-height" nil nil)
                       ("col" "@@html:<font color = \"${1:red}\">@@\n${2:text}$0\n@@html:</font>@" "colour-html-colour" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-html-colour" nil nil)
                       ("caution" "#+begin_caution\n${1:caution-content}\n#+end_caution" "my-caution" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-caution" nil nil)
                       ("b64r" "#+BEGIN_SRC emacs-lisp :results html :exports results\n(my/org/tob64-roided \"${1:`(my/org/image-select)`}\" \"${2:caption}\" ${3:850})\n#+END_SRC" "my-base64-roided" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-base64-roided" nil nil)
                       ("b64" "#+BEGIN_SRC emacs-lisp :results html :exports results\n(my/org/tob64 \"${1:`(my/org/image-select)`}\" ${2:850})\n#+END_SRC" "my-base64" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-base64" nil nil)
                       ("attention" "#+begin_attention\n${1:attention content}\n#+end_attention" "my-attention" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/my-attention" nil nil)
                       ("in" "*Invoice Physics Tuition*: ${1:date-start} - ${2:date-end}\n\n*_Ilya Antonov_*\n\n*Sort Code:* =09-01-28=\n\n*Account Number:* =37219913=" "invoice-tuition" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/invoice-tuition" nil nil)
                       ("ts" "${1:00}:${2:00}:${3:00}$0" "time-stamp" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-timestamp" nil nil)
                       ("task" "<<Task: ${1:task-name}>>" "task" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-tak" nil nil)
                       ("prop" ":PROPERTIES:\n:EXPORT_TITLE: ${1:title}\n:EXPORT_FILE_NAME: $1\n:END:\n\n$0" "org-properties" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-properties" nil nil)
                       ("mt" "\\$$1$0\\$" "math-mode" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-math-mode" nil nil)
                       ("ilya-inkscape-org-snippet" "[[file:images_inkscape/`temp-file-name-for-snippet`.png][`temp-file-name-for-snippet`]]\n" "ilya-inkscape-org-snippet" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-inkscape-org-snippet" nil nil)
                       (nil
                        (progn
                          (inkscape-load default-directory))
                        "ilya-inkscape-org-load" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-inkscape-org-load" "C-c d" nil)
                       (nil
                        (progn
                          (inkscape-generate default-directory)
                          (yas/insert-by-name "ilya-inkscape-org-snippet"))
                        "ilya-inkscape-org" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-inkscape-org" "C-c i" nil)
                       ("eq" "\\begin{equation}\n ${1:type--it-here}\n\\end{equation}" "eq" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-equation" nil nil)
                       ("et" "-------------------------------------------------------------------\n⦿ ${1: enter title}\n-------------------------------------------------------------------\n\n$0\n\n-------------------------------------------------------------------\n✘✘" "ilya-eidc-title" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/ilya-eidc-title" nil nil)
                       ("pfile" ":PROPERTIES:\n:EXPORT_TITLE: ${1:Title of export}\n:EXPORT_FILE_NAME: ${2:Name of export}\n:END:" "file-property" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/org-mode/file-property" nil nil)))


;;; Do not edit! File generated at Tue Jun 30 21:58:25 2020
