from dotenv import load_dotenv
from google.adk.agents import LlmAgent

load_dotenv()

def add(a: float, b: float) -> float:
    """2つの数値を足し算します"""
    return a + b

def subtract(a: float, b: float) -> float:
    """2つの数値を引き算します"""
    return a - b

def multiply(a: float, b: float) -> float:
    """2つの数値を掛け算します"""
    return a * b

def divide(a: float, b: float) -> float:
    """2つの数値を割り算します"""
    if b == 0:
        raise ValueError("ゼロで割ることはできません")
    return a / b

root_agent = LlmAgent(
    model="gemini-2.0-flash",
    name="calculator_agent",
    description="基本的な計算を行うエージェント",
    tools=[add, subtract, multiply, divide],
    instruction="あなたは計算エージェントです。ユーザーの計算要求に対して、適切な関数を使用して計算を実行し、結果を分かりやすく返答してください。"
)