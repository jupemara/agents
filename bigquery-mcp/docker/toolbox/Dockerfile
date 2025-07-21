FROM us-central1-docker.pkg.dev/database-toolbox/toolbox/toolbox:0.9.0

WORKDIR /app
COPY tools.yaml /app/tools.yaml
EXPOSE 5000
CMD ["toolbox", "--tools-file", "/app/tools.yaml", "--address", "0.0.0.0", "--port", "5000"]
