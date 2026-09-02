FROM python:3.11-slim
RUN useradd --uid 1001 --system --no-create-home appuser
WORKDIR /app
COPY log_app.py app.py
RUN chown appuser /app/app.py
USER appuser
ENV PORT=8000 PYTHONUNBUFFERED=1 LOG_LEVEL=INFO
EXPOSE 8000
CMD ["python3", "app.py"]
