# Installation
Backup your `.emacs.d` directory and run

``` shell
git clone https:\\gitlab.com/creamy-seas/emacs.git ~/.emacs.d
```

Open the `Makefile` and edit parameters (in progress). Then run
```
make
```

Upon the first load of emacs, all the required packages will be downloaded. There may be manual tweaking required as described in the section below

# Required installations ##
| projectile cross-project search     | `the_silver_searcher`                                      |
| tracking inkscape files for changes | `fswatch`                                                  |
| latex documents                     | `latex`, `biber`                                           |
| updating the keyring                | `gnu-elpa-keyring-update` through emacsa `package-install` |
| for pretty symbols in the modeline  | `emacs-all-the-icons` through yay                          |
|                                     |                                                            |

- `ispell`
- `latex` and `latexmk`
- `python`
See the top sections of the following files for more persinal configuraiton
- [latex configuration](./latexmode.org)
- [email configuration](./emailmode.org)
- [orgmode configuration](./orgmode.org)

> [Best-Site](https://www.motherfuckingwebsite.com "Best-site")

I've been creating this fully functional baby from scratch. The most useful commands are <kbd>Ctrl</kbd> and <kbd>Meta</kbd>.



## Essential autism ##


- ```init.el``` must be copied into the ```~/.emacs.d``` directory.
- Install `inconsolata` fonts by downloading the `.ttf` file
- Setup the python virtual environment:
  `mkvirtualenv NAME` -> run `install_python.sh` script from [jannies hub](https://github.com/creamy-seas/jannies)

## Cool features ##
- One of the first things I did, was change the awful white background and pipe in some nice inconsolata fonts.
- Very seamless <kbd>python</kbd> development using elpy
- Redpilled and based <kbd>LaTeX</kbd> environment, with all the highlighting you would ever need
- Unreal <kbd>orgmode</kbd> customization

Work in progess.
