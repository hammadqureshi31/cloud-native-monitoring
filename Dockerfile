FROM python:3.11-slim-bookworm

WORKDIR /app

COPY requirements-runtime.txt .

RUN pip install --no-cache-dir -r requirements-runtime.txt

COPY . .

RUN useradd --create-home --shell /usr/sbin/nologin appuser && chown -R appuser:appuser /app

USER appuser

ENV FLASK_RUN_HOST=0.0.0.0 \
    PORT=5000

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:%s/healthz' % os.environ.get('PORT', '5000'), timeout=3).read()" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
