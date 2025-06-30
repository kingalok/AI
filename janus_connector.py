# janus_connector.py

import trino
from trino.auth import OAuth2Authentication
import os

def get_janus_connection():
    return trino.dbapi.connect(
        host=os.getenv("JANUS_HOST"),
        port=443,
        user=os.getenv("JANUS_USER"),
        catalog="janus",
        schema="default",
        http_scheme="https",
        auth=OAuth2Authentication(
            redirect_uri=os.getenv("JANUS_REDIRECT_URI"),
            client_id=os.getenv("JANUS_CLIENT_ID"),
            token_url=os.getenv("JANUS_TOKEN_URL"),
            auth_url=os.getenv("JANUS_AUTH_URL")
        )
    )
