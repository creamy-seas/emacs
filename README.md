# Installation #

Backup your `.emacs.d` directory and run

``` shell
git clone https:\\gitlab.com/creamy-seas/emacs.git ~/.emacs.d && cd ~/.emacs.d
```

Check that dependencies are installed (otherwise parts of the program will fail to run)
``` shell
make check
```

Create the first `init.el` file that will perform the very first evaluation of the config
``` shell
make init
```

**Launch emacs**

*Upon the first load of emacs, all the required packages will be downloaded. There may be manual tweaking required as described in the section below*


# Personal customization #
See the top sections of the following files to set personal customization
- [email configuration](./emailmode.org)
- [orgmode configuration](./org-config.org)
- [python configuration](./pythonmode.org)

Moreover, you can always go into the init.el file and comment out the modes you do not want to load

# Entrypoint keybindings #
| **Keybinding** | **Description**                                                         |
|:---------------|:------------------------------------------------------------------------|
| `C-c e`        | Edit a config file                                                      |
| `C-i` or `C-z` | Quirky custom functions, ranging from working on venv to changing theme |


# TODO
- email mode
