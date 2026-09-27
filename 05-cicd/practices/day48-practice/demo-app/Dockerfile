FROM python:3.11-slim AS production
RUN useradd --uid 1001 --system --no-create-home appuser
WORKDIR /app
COPY src/app.py .
RUN chown appuser:appuser /app/app.py
USER appuser
ARG APP_VERSION=dev
ARG CI_PIPELINE_ID=0
ARG CI_COMMIT_SHA=local
ENV APP_VERSION=${APP_VERSION} \
    CI_PIPELINE_ID=${CI_PIPELINE_ID} \
    CI_COMMIT_SHA=${CI_COMMIT_SHA} \
    PORT=8000 PYTHONUNBUFFERED=1
EXPOSE 8000
HEALTHCHECK --interval=15s --timeout=5s --retries=3 \
    CMD python3 -c \
    "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" \
    || exit 1
CMD ["python3", "app.py"]
