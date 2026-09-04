FROM python:3.11-slim

WORKDIR /app

COPY app_v1.py app.py

ENV PORT=8000 PYTHONUNBUFFERED=1

EXPOSE 8000

HEALTHCHECK --interval=10s --timeout=3s \
    --start-period=5s --retries=2 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://127.0.0.1:8000/')" \
    || exit 1

CMD ["python3", "app.py"]
