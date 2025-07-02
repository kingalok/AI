# janus_connector.py
from server.auth_server import create_session  # Or wherever your session logic is

def janus_query(query: str) -> list[dict]:
    session = create_session()
    if not session:
        raise Exception("Could not authenticate with Janus")

    result = session.sql(query).to_arrow().to_pylist()
    return result
