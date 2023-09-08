#!/usr/bin/python
from subprocess import check_output
import os
import argparse
import re
from subprocess import check_output
from re import sub

# PATH_OF_PASSWORD_FILE = "~/db_mail/.pswd_mail.gpg"
PATH_OF_PASSWORD_FILE = os.path.expanduser("~/creamy_seas/sync_files/mail/.pswd_mail.gpg")

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

def get_pass(account):
    data = check_output("/usr/local/bin/pass " + account, shell=True).splitlines()
    password = data[0]

    # print("----------")
    # print(password)
    # print(account)
    # print("----------")

    return {"password": password, "user": account}

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
