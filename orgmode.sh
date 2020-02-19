socketfile=$(lsof -c Emacs | grep server | tr -s " " | cut -d' ' -f 8); /usr/local/bin/emacsclient -ne "(make-capture-frame)" -s $socketfile
