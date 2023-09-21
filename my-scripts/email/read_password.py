#!/usr/local/opt/python@3.11/bin/python3.11
import subprocess
from subprocess import check_output, CalledProcessError
import json
from google_auth_oauthlib.flow import InstalledAppFlow
from google.oauth2.credentials import Credentials
from functools import partial
import argparse

CREDENTIAL_FOLDER = "/Users/CCCP/db_mail"
GPG_RECIPIENT = "ilya.antonov24@ntlworld.com"

APP_CONFIG = {
    "GMAIL": {
        "web": {
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://accounts.google.com/o/oauth2/token"
        },
        "scopes": ["https://mail.google.com/"]
    },
    "OUTLOOK": {
        "web": {
            "auth_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
            "token_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/token"
        },
        "scopes": [
            "https://outlook.office.com/SMTP.Send",
            "https://outlook.office.com/POP.AccessAsUser.All",
            "https://outlook.office.com/IMAP.AccessAsUser.All"
        ]
    }
}

def get_pass(account):
    data = check_output("/usr/local/bin/pass " + account, shell=True).splitlines()
    password = data[0]

    return {"password": password, "user": account}

def make_config_file_path(user):
    return CREDENTIAL_FOLDER + '/' + user + ".gpg"

def read_config_file(user):
    """
    Decrypts and returns content of file
    """
    config = json.loads(
        check_output(
            ["gpg",
             "-d",
             "--quiet",
             "--batch",
             make_config_file_path(user)
             ],
        )
    )

    # Set refresh token if it does not exist
    if "refresh_token" not in config:
        config["refresh_token"] = None

    return config

def prepare_auth_flow(app, user):
    """
    Data required to launch authentication flow
    """

    try:
        auth_config = {
            "web": {
                # Read in encrypted credentials
                **read_config_file(user),
                # And the default config for the specific app
                **APP_CONFIG[app]["web"]
            }
        }
        scope = APP_CONFIG[app]["scopes"]

        return (auth_config, scope)

    except CalledProcessError:
        f"Made sure that {user}.gpg is created in {CREDENTIAL_FOLDER}"
    except KeyError:
        raise KeyError(f"{app} is not defined! Please choose from {list(APP_CONFIG.keys())}")

def run_authentication(app, user):
    """
    Directs user to auth page, storing the returned tokens in a gpg-encrypted file
    """

    # Launch online authentication
    flow = InstalledAppFlow.from_client_config(
             *prepare_auth_flow(app, user)
        )
    flow.run_local_server(port=0)

    # Pad the credentials with scope information
    creds = flow.credentials
    creds._scopes = flow.oauth2session.token["scope"]

    # Store in gpg-encrypted file
    with open(make_config_file_path(user), "w") as encrypted_file:
        p1 = subprocess.Popen(('echo', creds.to_json()), stdout=subprocess.PIPE)
        p2 = subprocess.Popen(['gpg', '--encrypt', "--recipient", GPG_RECIPIENT], stdin=p1.stdout, stdout=encrypted_file)
        p1.stdout.close()
        p2.wait()

    # Return updated credentials
    return creds

def get_token(app, user):
    """
    Fetches token for user - if expired, trigger refresh procedure
    """
    creds = Credentials.from_authorized_user_info(read_config_file(user))
    if creds.expired:
        creds = run_authentication(app, user)
    return creds.token

get_token_gmail = partial(get_token, "GMAIL")
get_token_outlook = partial(get_token, "OUTLOOK")

if __name__ == '__main__':
    # Debug
    # run_authentication(app="OUTLOOK", user="ilya.antonov@rhul.ac.uk")
    # print(get_token(app="OUTLOOK", user="ilya.antonov@rhul.ac.uk"))
    # run_authentication(app="GMAIL", user="ilya.antonov@dreams-ai.com")
    # print(get_token(app="GMAIL", user="ilya.antonov@dreams-ai.com"))
    # print(get_refresh_token("ilya.antonov@dreams-ai.com"))
    # print(read_config_file("ilya.antonov@dreams-ai.com")["token"])

    # Main script
    parser = argparse.ArgumentParser()
    parser.add_argument('app')
    parser.add_argument('user')
    args = parser.parse_args()
    print(get_token(user=args.user, app=args.app))
