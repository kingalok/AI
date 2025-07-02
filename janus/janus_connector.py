# janus_connector.py

from langchain.tools import tool

@tool
def query_janus(query: str) -> str:
    """Executes SQL query against Janus and returns results as string."""
    from janus_connector import janus_query
    try:
        result = janus_query(query)
        return str(result)
    except Exception as e:
        return f"Error querying Janus: {e}"
