FROM python:3.11-slim

RUN useradd --uid 1001 --system \
    --no-create-home appuser

WORKDIR /app
COPY graceful_app.py app.py
RUN chown appuser /app/app.py

USER appuser
ENV PORT=8000 \
    PYTHONUNBUFFERED=1 \
    SHUTDOWN_TIMEOUT=30

EXPOSE 8000

# Give enough time for graceful shutdown
# Default docker stop timeout: 10 seconds
# Our app may need more
STOPSIGNAL SIGTERM

HEALTHCHECK --interval=10s --timeout=3s \
    --start-period=5s --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://localhost:8000/health')" \
    || exit 1

CMD ["python3", "app.py"]
