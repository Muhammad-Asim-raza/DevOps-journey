FROM python:3.11-slim

# Build arguments for registry metadata
ARG APP_VERSION=1.0.0
ARG BUILD_DATE="unknown"
ARG GIT_COMMIT="unknown"
ARG REGISTRY="local"

LABEL org.opencontainers.image.version="${APP_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL maintainer="Asim Raza"

ENV APP_VERSION=${APP_VERSION}
ENV BUILD_DATE=${BUILD_DATE}
ENV GIT_COMMIT=${GIT_COMMIT}
ENV REGISTRY=${REGISTRY}
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

WORKDIR /app

RUN useradd -m -u 1001 appuser

COPY app.py .
RUN chown appuser:appuser /app/app.py

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=15s --timeout=5s \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://localhost:8000/health')" \
    || exit 1

CMD ["python3", "app.py"]
