from dotenv import load_dotenv
from google.adk.agents import LlmAgent
from google.adk.tools.mcp_tool.mcp_toolset import MCPToolset
from google.adk.tools.mcp_tool.mcp_session_manager import SseConnectionParams

load_dotenv()

root_agent = LlmAgent(
    model="gemini-2.0-flash",
    name="playwright_browser_agent",
    description="ブラウザー操作エージェント",
    instruction="ユーザーの指示に従ってWebブラウザーを操作してください。",
    tools=[
        MCPToolset(
            connection_params=SseConnectionParams(
                url="http://localhost:8931"
            )
        )
    ]
)
