from langchain_core.tools import tool
from trino.dbapi import connect
from trino.auth import OAuth2Authentication, ConsoleRedirectHandler
import os

@tool("query_janus", return_direct=True)
def query_janus(sql_query: str) -> str:
    """
    Executes a SQL query on the Janus Data Mesh (Starburst/Trino) using OAuth2 authentication.

    Args:
        sql_query (str): The SQL query to run.

    Returns:
        str: The query results as a string or error message.
    """
    try:
        # Setup OAuth2 authentication
        auth = OAuth2Authentication(
            redirect_auth_handler=ConsoleRedirectHandler,
            client_id=os.getenv("JANUS_CLIENT_ID"),
            redirect_uri=os.getenv("JANUS_REDIRECT_URI"),
            auth_url=os.getenv("JANUS_AUTH_URL"),
            token_url=os.getenv("JANUS_TOKEN_URL")
        )

        # Establish connection
        conn = connect(
            host=os.getenv("JANUS_HOST"),
            port=int(os.getenv("JANUS_PORT", 443)),
            http_scheme="https",
            catalog=os.getenv("JANUS_CATALOG", "hive"),
            schema=os.getenv("JANUS_SCHEMA", "default"),
            auth=auth,
        )

        # Execute query
        cur = conn.cursor()
        cur.execute(sql_query)
        rows = cur.fetchall()

        if not rows:
            return "⚠️ Query executed successfully, but returned no data."
        
        # Format results
        result_str = "\n".join([str(row) for row in rows])
        return f"✅ Query result:\n{result_str}"

    except Exception as e:
        return f"❌ Error querying Janus: {str(e)}"
