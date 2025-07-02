import streamlit as st
from langchain.agents import initialize_agent, Tool
from langchain_community.chat_models import AzureChatOpenAI
from janus_tool import JanusQueryTool  # this should point to your janus tool file

# Load LLM (Azure OpenAI GPT-4o)
llm = AzureChatOpenAI(
    deployment_name="gpt-4o",
    model_name="gpt-4o",
    openai_api_version="2024-05-01-preview",
    openai_api_key="<your-api-key>",
    openai_api_base="https://<your-resource-name>.openai.azure.com/",
    openai_api_type="azure"
)

# Define tools
janus_tool = JanusQueryTool()
tools = [
    Tool(
        name="JanusQueryTool",
        func=janus_tool.run,
        description="Use this tool to run SQL-like queries on Janus data mesh."
    )
]

# Initialize agent
agent = initialize_agent(
    tools=tools,
    llm=llm,
    agent="zero-shot-react-description",
    verbose=True
)

# Streamlit frontend
st.title("📊 Janus + Azure OpenAI Assistant")

query = st.text_input("Ask a data question:")

if query:
    with st.spinner("Thinking..."):
        response = agent.run(query)
        st.success(response)
