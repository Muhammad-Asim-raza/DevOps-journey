FROM python:3.11-slim

RUN useradd --uid 1001 --system \
    --no-create-home appuser

WORKDIR /app
COPY app_with_health.py app.py
RUN chown appuser:appuser /app/app.py

USER appuser

ENV PORT=8000 PYTHONUNBUFFERED=1

EXPOSE 8000

# Production health check:
# interval: how often to check
# timeout: how long to wait for response
# start-period: grace period after start
# retries: failures before marking unhealthy
HEALTHCHECK \
    --interval=15s \
    --timeout=5s \
    --start-period=20s \
    --retries=3 \
    CMD python3 -c \
    "import urllib.request, sys; \
     r = urllib.request.urlopen( \
         'http://localhost:8000/health', \
         timeout=4 \
     ); \
     sys.exit(0 if r.status == 200 else 1)" \
    || exit 1

CMD ["python3", "app.py"]
