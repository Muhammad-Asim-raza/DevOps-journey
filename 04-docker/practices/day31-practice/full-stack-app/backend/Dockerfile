FROM python:3.11-slim

WORKDIR /app

# Create non-root user
RUN useradd -m -u 1001 appuser

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app.py .

# Set ownership
RUN chown -R appuser:appuser /app
USER appuser

ENV PORT=5000
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

HEALTHCHECK --interval=15s \
            --timeout=5s \
            --start-period=10s \
            --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://localhost:5000/health')" \
    || exit 1

CMD ["python3", "app.py"]
