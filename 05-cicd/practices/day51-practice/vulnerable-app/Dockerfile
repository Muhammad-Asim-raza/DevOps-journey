# Intentionally uses old base image (for demo)
FROM python:3.9   # :latest equivalent - not pinned
# ❌ No USER instruction (runs as root)
# ❌ No healthcheck
# ❌ No non-root user
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src/ .
CMD ["python3", "app.py"]
