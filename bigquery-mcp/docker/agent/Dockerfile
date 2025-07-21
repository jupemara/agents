FROM python:3.12.11-slim

WORKDIR /app
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p /app/agent
COPY agent.py /app/agent/
EXPOSE 8080

CMD ["adk", "web", "--host", "0.0.0.0", "--port", "8080"]
