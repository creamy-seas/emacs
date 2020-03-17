;;; Compiled snippets and support files for `latex-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'latex-mode
		     '(("nnp" "\\lstset{language=python,        backgroundcolor=\\color{python},        frame=tb, tabsize=4,basicstyle=\\small, showstringspaces=false,commentstyle=\\color{red!70}}\n\\begin{lstlisting}\n ${1:code-goes-here}\n\\end{lstlisting}" "nn-python" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/nn-python" nil nil)
		       ("lr" "\\left(${1:content}\\right)$0" "left-right-bracket" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/left-right-bracket" nil nil)
		       ("pt" "\\verb|${1:`${2:enter-here-chad}'}|" "ilya-verb-parantheses" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-verb-parantheses" nil nil)
		       ("vec" "\\vec{${1:vector-content}}$0" "vec" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-vec" nil nil)
		       ("up" "\\usepackage{${1:package-to-use}}\n\n$0" "usepacakge" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-usepackage" nil nil)
		       ("ium" "\\iunitMixed{${1:number}}{${2:math-unit}}{${3:text-unit}}$0" "ilya-unit-mixed" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-unit-mixed" nil nil)
		       ("iu" "\\iunit{${1:number}}{${2:text-unit}$0}" "ilya-unit" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-unit" nil nil)
		       ("itcr" "\\iTwoColumnsRAW{\n  ${1:left-hand-side}\n }\n {\n  ${2:right-hand-side}\n }$0" "ilya-two-column-raw" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-two-column-RAW" nil nil)
		       ("itc" "\\iTwoColumns{\n  ${1:left-hand-side}\n }\n {\n  ${2:right-hand-side}\n }$0" "ilya-two-columns" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-two-column" nil nil)
		       ("tt" "\\texttt{${1:text-here}$0}" "texttt" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-texttt" nil nil)
		       ("tx" "\\text{$1}$0" "text-mode" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-text-mode" nil nil)
		       ("ilya-texfile-generate-snippet-part1" "\\newpage\\include{`temp-file-name-for-snippet`}\n" "ilya-texfile-generate-snippet" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-texfile-generate-snippet-part1" nil nil)
		       ("ilya-texfile-generate-snippet" "\\newpage\\include{`temp-file-name-for-snippet`}\n" "ilya-texfile-generate-snippet-part1" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-texfile-generate-snippet" nil nil)
		       (nil
			(progn
			  (ilya-generate-texfile)
			  (yas/insert-by-name "ilya-texfile-generate-snippet-part1")
			  (with-temp-buffer
			    (write-file temp-file-name-for-snippet))
			  (setq temp-texmaster
				(concat "% -*- TeX-master:\"../"
					(TeX-master-file)
					".tex\" -*-\n\n"))
			  (append-to-file temp-texmaster nil temp-file-name-for-snippet)
			  (find-file temp-file-name-for-snippet)
			  (end-of-buffer)
			  (LaTeX-section 2))
			"ilya-texfile-generate" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-texfile-generate" "C-c t" nil)
		       ("tm" "% -*- TeX-master: \"../${1:MASTERFILEEDITHERENIGGER}\" -*-$0\n" "set-texMaster" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-texMaster" nil nil)
		       ("t" "\\begin{table}[h]\n  \\centering\n  \\begin{tabular}{${1:|c|c|}}\n    \\hline\n     $2 & $3 \\\\\\\\\\hline$0\n\\end{tabular}\n\\end{table}" "ilya-table" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-table" nil nil)
		       ("ism" "\\isigmaminus" "ilya-sigma-minus" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-sigma-minus" nil nil)
		       ("rat" "\\iratext{${1:arrow-overtext}}$0" "ilya-rightarrow-text" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-rightarrow-text" nil nil)
		       ("ra" "\\ira $0" "ilya-rightarrow" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-rightarrow" nil nil)
		       ("redb" "\\red{\\textbf{${1:text-in-red}}}\\ec$0" "red-bold" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-red-bold" nil nil)
		       ("red" "\\red{${1:red-like-the-reich-flag}}$0" "red" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-red" nil nil)
		       ("qp" "``$0''" "ilya-quotes" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-quote-symmetric" nil nil)
		       ("q" "\\`\\`${1:quote-me-in}'' $0" "quote" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-quote-quotes" nil nil)
		       ("q" "\\mi{$1$0}" "quote-fatmanual" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-quote-fatmaunal" nil nil)
		       ("iq" "\\quote{${1:text-to-quote}}$0" "quote" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-quote" nil nil)
		       ("iprob" "\\iprob{${1:text-here}$0}" "ilya-probability" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-probability" nil nil)
		       ("pi2" "$ \\pi/2$-pulse $0" "pipulse-over-2" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-pipulse-over-2" nil nil)
		       ("picc" "\\begin{center}\n  \\includegraphics[height=${1:height}]{${2:example-image-c}}\n  \n  {\\small ${3:caption-text}\\label{fig:$2}}\n\\end{center}\n\n\\noindent $0" "ilya-picture-centered" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-picture-framed" nil nil)
		       ("pic" "\\begin{figure}[h]\n  \\centering\n  \\includegraphics[height=${1:height}]{${2:example-image-a}}\n  \\caption{\\small ${3:caption-text}\\label{fig:$2}}\n\\end{figure}\n\n\\noindent $0" "ilya-picture" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-picture" nil nil)
		       ("ns" "\\,ns $0" "ns" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-ns" nil nil)
		       ("ni" "\\noindent $0" "noindent" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-noindent" nil nil)
		       ("np" "\\newpage$0" "newpage" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-newpage" nil nil)
		       ("nl" "\\\\\\\\\\\\hline\n" "newline" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-newline" nil nil)
		       ("nm" "\\,nm $0" "nanometers" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-nanometers" nil nil)
		       ("mini" "\\begin{minipage}{${1:${2:width}\\textwidth}}\n${3:text}\n\\end{minipage}" "minipage" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-minipage" nil nil)
		       ("imatp" "\\\\begin{pmatrix}\n $1 & $2 \\\\\\\\\n $3 & $4\n\\\\end{pmatrix}$0" "ilya-matrix-p" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-matrix-pd" nil nil)
		       ("matp" "\\begin{pmatrix}\n	${1:matrix-value}\n\\end{pmatrix}$0" "matrix-parantheses" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-matrix-parantheses" nil nil)
		       ("matl" "\\ensuremath{\\left(\\begin{smallmatrix} ${1:matrix-values} \\end{smallmatrix}\\right)} $0" "matrix-line" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-matrix-line" nil nil)
		       ("imatb" "\\\\begin{bmatrix}\n${1} & ${2}\\\\\n${3} & ${4}\n\\\\end{bmatrix}$0" "ilya-matrix-b" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-matrix-b" nil nil)
		       ("mat2" "\\begin{pmatrix}\n $1 & $2\\\\\n $3 & $4\n\\end{pmatrix} $0\n" "matrix2-2" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-matrix-2-2" nil nil)
		       ("mt" "\\\\,\\$$1$0\\$\\\\," "math-mode" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-math-mode" nil nil)
		       ("lra" "\\ilra$0" "ilya-leftrightarrow" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-leftrightArrow" nil nil)
		       ("ikb" "\\iketbra{${1:ket-part}}{${2:bra-part}}$0" "ilya-ketbra" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-ketbra" nil nil)
		       ("ik" "\\iket{$1}$0\n" "ilya-ket" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-ket" nil nil)
		       ("ilya-inkscape-latex-snippet" "\\begin{figure}[h]\n  \\centering\n  \\inkfig{${1:width}$0cm}{`temp-file-name-for-snippet`}\n  \\caption{\\small ${3:caption-text}\\label{fig:`temp-file-name-for-snippet`}}\n\\end{figure}" "ilya-inkscape-latex-snippet" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-inkscape-latex-snippet" nil nil)
		       (nil
			(progn
			  (inkscape-load
			   (concat
			    (expand-file-name
			     (TeX-master-directory))
			    "/")))
			"ilya-inkscape-latex-load" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-inkscape-latex-load" "C-c l" nil)
		       (nil
			(progn
			  (inkscape-generate
			   (expand-file-name
			    (TeX-master-directory)))
			  (yas/insert-by-name "ilya-inkscape-latex-snippet"))
			"ilya-inkscape-latex" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-inkscape-latex" "C-c i" nil)
		       ("ilya-hyperref-snippet" "\\hyperref[`ilya-temp-refference`]{\\underline{${1:display-name}$0}}\n" "ilya-hyperref-snippet" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-hyperref-snippet" nil nil)
		       ("hyp"
			(progn
			  (ilya-reftex-reference)
			  (yas/insert-by-name "ilya-hyperref-snippet"))
			"ilya-hyperref" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-hyperref" nil nil)
		       ("html" "\\begin{html}\n${1:html-here}\n\\end{html}" "html" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-html" nil nil)
		       ("hr" "\\href{${1:website}}{${2:description}}" "ilya-href" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-href" nil nil)
		       ("hf" "\\hfill $0" "horizontal-fill" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-horizontal-fill" nil nil)
		       ("hl" "\\hline\n$0" "hline" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-hline" nil nil)
		       ("hat" "\\hat{${1:hat-value}}$0" "hat" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-hat" nil nil)
		       ("igc" "\\begin{center}\n   \\includegraphics[height=${1:height}cm]{${2:example-image-a}}\n\\end{center}\n\n\\noindent $0" "ilya-graphic-centered" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-graphic-centered" nil nil)
		       ("gold" "\\gold{${1:gold-text}}\\ec$0" "ilya-gold" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-gold" nil nil)
		       ("g1" "g^{(1)}(\\\\tau)$0" "ilya-g1" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-g1" nil nil)
		       ("ifr" "\\begin{framed}\\noindent\n	${1:frame-contnent}$0\n\\end{framed}" "framed" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-framed." nil nil)
		       ("isl" "\\begin{frame}\n  \\frametitle{\\insertsection}\n  \\framesubtitle{\\insertsubsection}\n\n  ${1:get-creative-here!}$0\n\n\\end{frame}" "ilya-slide" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-frame" nil nil)
		       ("cm" "\\cmd{${1:command}} $0" "command" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-fatmanual-command" nil nil)
		       ("eq" "\\begin{equation}${1:\\label{eq:${2:label}}}\n ${3:equation-content}$0\n\\end{equation}\n\n\\noindent " "ilya-equation" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-equation" nil nil)
		       ("dot" "\\dot{${1:dot-content}}$0" "dot" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-dot" nil nil)
		       ("drv" "\\iderivative{${1:numerator}}{${2:denominator}}$0" "ilya-derivative" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-derivative" nil nil)
		       ("ic" "\\\\item[\\faBullseye]" "ilya-custom-itemize" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-custom-itemize" nil nil)
		       ("icmdq" "\\cmd{\\`\\`${1:comment}''}$0" "ilya-command-quotes" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-command-quote" nil nil)
		       ("icmd" "\\cmd{${1:enter-command}}$0" "ilya-command" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-command" nil nil)
		       ("cas" "\\begin{cases}${1:\\label{eq:${2:label}}}\n ${3:cases-content}$0\n\\end{cases}" "cases" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-cases" nil nil)
		       ("ib" "\\ibra{${1:bra-variable}}$0" "ilya-bra" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-bra" nil nil)
		       ("ibx" "\\ibox{${1:put-it-into-box}}" "ilya-box" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-box" nil nil)
		       ("blue" "\\blue{${1:text-in-blue}}$0" "blue" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-blue" nil nil)
		       ("bt" "\\ibaseten{${1:power-input}}$0" "ilya-base-ten" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-base-ten" nil nil)
		       ("av" "\\iaverage{${1:average-value}}$0" "ilya-average" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-average" nil nil)
		       ("ali" "\\begin{aligned}\n	${1:first-line} \\\\\\\\\n	${2:second-line} $0\n\\end{aligned}" "aligned" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-aligned" nil nil)
		       ("iabs" "\\iabsSquared{${1:math-value}} $0" "ilya-absolute-squared" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-absolute-squared" nil nil)
		       ("iab" "\\iabs{${1:math-value}} $0" "ilya-absolute" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-absolute" nil nil)
		       ("Ra" "\\iRa" "RightArrow" nil nil nil "/Users/CCCP/creamy_seas/sync_files/emacs_config/personal-snippets/latex-mode/ilya-Rightarrow-large" nil nil)))


;;; Do not edit! File generated at Thu Mar 12 18:00:37 2020
