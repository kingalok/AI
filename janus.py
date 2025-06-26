from langchain_core.tools import tool
from trino.dbapi import connect
from trino.auth import OAuth2Authentication, ConsoleRedirectHandler
import os

# Create a reusable connection
def create_starburst_connection():
    auth = OAuth2Authentication(
        redirect_handler=ConsoleRedirectHandler()
    )

    conn = connect(
        host=os.getenv("STARBURST_HOST"),
        port=int(os.getenv("STARBURST_PORT", 443)),
        user=os.getenv("STARBURST_USER"),
        http_scheme="https",
        auth=auth,
        catalog=os.getenv("STARBURST_CATALOG"),
        schema=os.getenv("STARBURST_SCHEMA")
    )
    return conn

# Tool function
@tool("query_starburst", return_direct=True)
def query_starburst(query: str) -> str:
    """
    Executes a SQL query on Starburst (Trino) and returns the results as a string.

    Args:
        query (str): SQL query to run on Starburst.
    
    Returns:
        str: Query result or error message.
    """
    try:
        conn = create_starburst_connection()
        cur = conn.cursor()
        cur.execute(query)
        rows = cur.fetchall()
        result = "\n".join(str(row) for row in rows)
        return result or "✅ Query ran successfully but returned no data."
    except Exception as e:
        return f"❌ Error running query: {e}"
