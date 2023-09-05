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

from subprocess import check_output
from re import sub

def get_pass(account):
    data = check_output("/usr/local/bin/pass " + account, shell=True).splitlines()
    password = data[0]

    return {"password": password, "user": account}

def get_client_id(account):
    """Assumes ilya.antonov@dreams-ai.com-client_id"""
    return check_output("/usr/local/bin/pass " + account + "-client_id", shell=True).splitlines()[0].decode()

def get_client_secret(account):
    return check_output("/usr/local/bin/pass " + account + "-client_secret", shell=True).splitlines()[0].decode()

def get_refresh_token(account):
    return check_output("/usr/local/bin/pass " + account + "-refresh_token", shell=True).splitlines()[0].decode()

def folder_filter(name):
    return not (name in ['INBOX',
                         '[Gmail]/Spam',
                         '[Gmail]/Important',
                         '[Gmail]/Starred'] or
                name.startswith('[Airmail]'))

def nametrans(name):
    """Translation of golder names"""
    return sub('^(Starred|Sent Mail|Drafts|Trash|All Mail|Spam)$', '[Gmail]/\\1', name)

def nametrans_reverse(name):
    return sub('^(\[Gmail\]/)', '', name)

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("-u", "--user", required=True, help="user")
    args = vars(ap.parse_args())

    print(get_pass(args["user"])["password"].decode("utf-8"))
