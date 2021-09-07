#!/usr/bin/python
from subprocess import check_output
import os
import argparse
import re

# PATH_OF_PASSWORD_FILE = "~/db_mail/.pswd_mail.gpg"
PATH_OF_PASSWORD_FILE = os.path.expanduser("~/db_mail/.pswd_mail.gpg")


def get_password_emacs(user):

    # 1 - prepare regexp ######################################################
    s = "%s password ([^ ]*)\n" % (user)
    p = re.compile(s)

    # 2 - kill pinentry programs which tend to stall on the mac ###########
    os.system("killall pinentry 2> /dev/null")

    # 3 - get password ########################################################
    # authinfo = open(PATH_OF_PASSWORD_FILE, "r").read()
    authinfo = os.popen("gpg -q --no-tty -d " + PATH_OF_PASSWORD_FILE).read()

    # 4 - return ##############################################################
    return p.search(authinfo).group(1)


def get_pswd(path):
    return check_output(
        ["gpg", "--quiet", "--batch", "-d", os.path.expanduser(path)]
    ).strip()


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("-u", "--user", required=True, help="user")
    args = vars(ap.parse_args())

    print(get_password_emacs(args["user"]))
