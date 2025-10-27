# ---- Builder: install deps in a clean layer ----
FROM python:3.11-slim AS builder

# Faster, repeatable builds
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN python -m pip install --upgrade pip && pip install -r requirements.txt --prefix /install

# ---- Runtime: minimal image with only what we need ----
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create non-root user
RUN useradd -m appuser

# Copy only installed site-packages and the app code
COPY --from=builder /install /usr/local
WORKDIR /app
COPY app/ app/

# Switch to non-root
USER appuser

EXPOSE 8000

# Use uvicorn as the app server (simple & fast)
# Note: --proxy-headers supports running behind reverse proxies/ingress
ENTRYPOINT ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers"]
