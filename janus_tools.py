# janus_tools.py

from langchain_core.tools import tool
from janus_connector import get_janus_connection

@tool("query_janus_data", return_direct=True)
def query_janus_data(query: str) -> str:
    """
    Executes a SQL query on Janus using a secure OAuth2-based connection.

    Args:
        query (str): SQL statement to execute (e.g., "SELECT * FROM users LIMIT 5").

    Returns:
        str: Results or error message.
    """
    try:
        conn = get_janus_connection()
        cursor = conn.cursor()
        cursor.execute(query)
        rows = cursor.fetchall()
        return "\n".join(str(row) for row in rows)
    except Exception as e:
        return f"❌ Error querying Janus: {e}"
