FROM python:3.11-slim
RUN useradd --uid 1001 --system --no-create-home appuser
WORKDIR /app
COPY metrics_app.py app.py
RUN chown appuser /app/app.py
USER appuser
ENV PORT=8000 PYTHONUNBUFFERED=1
EXPOSE 8000
HEALTHCHECK --interval=15s --timeout=5s \
    --start-period=10s --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://localhost:8000/health')" \
    || exit 1
CMD ["python3", "app.py"]
