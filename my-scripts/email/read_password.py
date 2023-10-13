#!/usr/bin/env python3

from functools import partial
import json
import argparse
import subprocess
import time
import http.server
import threading
import urllib.parse
import webbrowser

# MAKE SURE TO INSTALL THESE with python -m pip install google google-auth-oauthlib msal
# using the python version that runs offlineimap
from google.auth.transport.requests import Request
from google_auth_oauthlib.flow import InstalledAppFlow
from google.oauth2.credentials import Credentials
from msal import ConfidentialClientApplication, SerializableTokenCache

CREDENTIAL_FOLDER = "/home/antonov/db_mail"
GPG_RECIPIENT = "ilya.antonov24@ntlworld.com"

class GpgFileManager:
    """
    Read and write GPG-encrypted files
    """
    def __init__(self, folder, gpg_recipient):
          self.folder = folder
          self.gpg_recipient = gpg_recipient

    def make_file_path(self, user):
        return self.folder + '/' + user + ".gpg"

    def read_file(self, user):
        """
        Decrypts and returns content of file for specified user
        """

        try:
            credentials = json.loads(
                subprocess.check_output(
                    ["gpg",
                     "-d",
                     "--quiet",
                     "--batch",
                     self.make_file_path(user)
                     ],
                )
            )

            # Set refresh token if it does not exist
            if "refresh_token" not in credentials:
                credentials["refresh_token"] = None

            return credentials

        except:
            f"Made sure that {user}.gpg is created in {CREDENTIAL_FOLDER}"

    def write_file(self, credentials, user):
        """
        Write credentials to a gpg encrypted file
        @param credentials as a dictionary
        """
        # Store in gpg-encrypted file
        with open(self.make_file_path(user), "w") as encrypted_file:
            p1 = subprocess.Popen(('echo', credentials), stdout=subprocess.PIPE)
            p2 = subprocess.Popen(['gpg', '--encrypt', "--recipient", self.gpg_recipient], stdin=p1.stdout, stdout=encrypted_file)
            p1.stdout.close()
            p2.wait()

# To simplify threading, declare global vars for outlook
outlook_auth_response = None
outlook_temp_server = None

class OutlookTempServer(http.server.BaseHTTPRequestHandler):
    """
    Server spun up to recieve response when running Microsoft authentication
    """

    def do_GET(self):
        # Parse the path that was redirected to
        parsed_query = urllib.parse.parse_qs(
            urllib.parse.urlparse(self.path).query
        )
        global outlook_auth_response
        outlook_auth_response = next(iter(parsed_query['code']), '')

        # Close of connection
        response_body = b'Success. Look back at your terminal\r\n'
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.send_header('Content-Length', len(response_body))
        self.end_headers()
        self.wfile.write(response_body)

        # Shut down server
        global outlook_temp_server
        t = threading.Thread(target=lambda: outlook_temp_server.shutdown())
        t.start()

class OutlookAuth(GpgFileManager):

    CONFIG = {
        "web": {
            "auth_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
            "token_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/token"
        },
        "scopes": [
            "https://outlook.office.com/SMTP.Send",
            "https://outlook.office.com/POP.AccessAsUser.All",
            "https://outlook.office.com/IMAP.AccessAsUser.All"
        ],
        "redirect_uri": "http://localhost:8745/"
    }

    def __init__(self, folder, gpg_recipient):
        super().__init__(folder, gpg_recipient)

    def run_authentication(self, user):
        """
        Spin up a temporary server, that will recieve a response from the authentication flow
        in the browser
        """

        credentials = self.read_file(user)

        # Direct user to authentication page
        webbrowser.open(
            self.app.get_authorization_request_url(
                self.CONFIG["scopes"],
                redirect_uri=self.CONFIG["redirect_uri"],
                login_hint=user)
        )

        # Launch temporary server - it will process response after the authentication page redirects user
        global outlook_temp_server
        outlook_temp_server = http.server.HTTPServer(('', 8745), OutlookTempServer)
        outlook_temp_server.serve_forever()

        # Once server shuts down, unpack the response
        global outlook_auth_response
        if outlook_auth_response == "":
            print('After login, you will be redirected to a blank (or error) page with a url containing an access code. Paste the url below.')
            resp = input('Response url: ')
            i = resp.find('code') + 5
            outlook_auth_response = resp[i : resp.find('&', i)] if i > 4 else resp

        credentials = self.update_credentials(
            credentials,
            self.app.acquire_token_by_authorization_code(
                outlook_auth_response,
                self.CONFIG["scopes"],
                redirect_uri=self.CONFIG["redirect_uri"]
            )
        )
        self.write_file(json.dumps(credentials), user)

        return credentials

    def check_if_expired(self, credentials):
        try:
            if (float(credentials["set_at"]) + float(credentials["expires_in"]) > time.time()):
                return False
            return True
        except:
            return True

    def update_credentials(self, original_creds, new_creds):
        """
        Update original credentials by:
        - Merging in the new ones
        - Setting a timestamp for token expiration calculation
        """

        return {
            **original_creds,
            **new_creds,
            "set_at": str(time.time())
        }


    def get_token(self, user):
        """
        Fetches token for user - if expired, trigger refresh procedure
        """
        credentials = self.read_file(user)

        if (self.check_if_expired(credentials)):

            # If expired or not set, begin microsoft authentication
            self.app = ConfidentialClientApplication(
                credentials["client_id"],
                client_credential=credentials["client_secret"],
                # Non persistent cache - wiped after exit
                token_cache=SerializableTokenCache()
            )

            try:
                print("> Refreshing access_token")
                credentials = self.update_credentials(
                    credentials,
                    self.app.acquire_token_by_refresh_token(
                        credentials["refresh_token"],
                        self.CONFIG["scopes"]
                    ))
                self.write_file(json.dumps(credentials), user)
            except:
                print("> Creating access tokens")
                credentials = self.run_authentication(user)

        return credentials["access_token"]


class GoogleAuth(GpgFileManager):

    CONFIG = {
        "web": {
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://accounts.google.com/o/oauth2/token"
        },
        "scopes": ["https://mail.google.com/"]
    }

    def __init__(self, folder, gpg_recipient):
        super().__init__(folder, gpg_recipient)

    def run_authentication(self, user):
        """
        Directs user to google auth page, returning the authenticated payload:

        credentials = {
          "token": "xxx",
          "refresh_token": "yyy",
          "token_uri": "https://accounts.google.com/o/oauth2/token",
          "client_id": "zzz",
          "client_secret": "www",
          "scopes": ["https://mail.google.com/"],
          "expiry": "2023-09-23T17:24:16.748044Z"
        }
        """

        # Launch online authentication
        flow = InstalledAppFlow.from_client_config(
            {
                "web": {
                    # Read in encrypted credentials
                    **self.read_file(user),
                    # Google endpoints
                    **self.CONFIG["web"]
                }
            },
            self.CONFIG["scopes"]
        )
        flow.run_local_server(port=0)

        # Pad the credentials with scope information
        credentials = flow.credentials
        credentials._scopes = flow.oauth2session.token["scope"]

        # Write to file
        self.write_file(credentials.to_json(), user)

        # Return credentials object
        return credentials


    def get_token(self, user):
        """
        Fetches token for user - if expired, trigger refresh procedure
        """
        credentials = Credentials.from_authorized_user_info(self.read_file(user))
        if credentials.expired:
            try:
                #print("> Refreshing access_token")
                credentials.refresh(Request())
            except:
                # In case that refresh token is only valid for a short time,
                # run full authentication to get new refresh token
                # e.g. https://stackoverflow.com/a/65936387
                # https://developers.google.com/identity/protocols/oauth2#expiration
                #print("> Creating access tokens")
                credentials = self.run_authentication(user)

        return credentials.token

def get_pass(user):
    """
    Read a simple password stored in "pass"
    """
    data = subprocess.check_output("pass " + user, shell=True).splitlines()
    password = data[0]

    return {"password": password, "user": user}

def get_credentials(user):
    """
    Read static credentials - prevents the full flow from being executed, when a known field such as client_id needs to be read
    """
    fm = GpgFileManager(CREDENTIAL_FOLDER, GPG_RECIPIENT)
    return  fm.read_file(user)

def get_token(app, user):
    """
    Fetch a valid auth token using a dedicated flow for the chosen app
    """

    if (app == "GMAIL"):
        return GoogleAuth(CREDENTIAL_FOLDER, GPG_RECIPIENT).get_token(user)
    elif (app == "OUTLOOK"):
        return OutlookAuth(CREDENTIAL_FOLDER, GPG_RECIPIENT).get_token(user)
    else:
        raise Exception(f"App {app} not recognised")

# Shorthand command versions - used by offlineimap
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
    #
    # DREAMS-AI works great
    # GMAIL works great - we can issue a refresh request when the old token has timed out
    # print(get_token_outlook("ilya.antonov@rhul.ac.uk"))

    # Main script - used by msmtp
    parser = argparse.ArgumentParser()
    parser.add_argument('app')
    parser.add_argument('user')
    args = parser.parse_args()
    print(get_token(user=args.user, app=args.app))
