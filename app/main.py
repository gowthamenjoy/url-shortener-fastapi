from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = FastAPI(title="URL Shortener (skeleton)")

# Simple example metric: count HTTP requests by path/method/status
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["path", "method", "status"]
)

@app.middleware("http")
async def metrics_middleware(request: Request, call_next):
    response = await call_next(request)
    # Avoid high cardinality by only labeling known paths in this step
    path = request.url.path if request.url.path in {"/", "/healthz", "/metrics"} else "other"
    REQUEST_COUNT.labels(path=path, method=request.method, status=str(response.status_code)).inc()
    return response

@app.get("/", response_class=PlainTextResponse)
def read_root():
    return "URL Shortener API – skeleton is alive. Try /healthz and /metrics"

@app.get("/healthz", response_class=PlainTextResponse)
def healthz():
    # Later we’ll check DB/Redis; for now just OK
    return "ok"

@app.get("/metrics")
def metrics():
    data = generate_latest()
    return PlainTextResponse(data.decode("utf-8"), media_type=CONTENT_TYPE_LATEST)
