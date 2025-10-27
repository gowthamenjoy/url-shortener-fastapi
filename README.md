# URL Shortener (FastAPI) — Prod-Style DevOps Demo

A production-style microservice showcasing **modern DevOps practices** end-to-end:

- Python FastAPI microservice, containerized with Docker
- Helm-managed Kubernetes deployment
- GitHub Actions CI: build, tag, push to GHCR + Trivy security scans + Helm lint/template checks
- Autoscaling with HPA (metrics-server)
- Observability with Prometheus + Grafana (ServiceMonitor)
- NGINX Ingress
- Progressive delivery with **Argo Rollouts (canary 20→40→60 with pauses)**

---

## 🖼 Architecture

```mermaid
flowchart LR
  Browser -->|HTTP| Ingress
  Ingress --> Rollout
  Rollout -->|Stable| PodsStable[Stable Pods]
  Rollout -->|Canary| PodsCanary[Canary Pods]
  PodsStable --> Service
  PodsCanary --> Service
  Service --> FastAPI[FastAPI app :8000]
  FastAPI -->|/metrics| Prometheus
  Prometheus --> Grafana
  Rollout -->|autoscale| HPA
  HPA --> metrics-server
  CI[GitHub Actions] --> GHCR
  GHCR --> Rollout
```

## 📸 Production Observability Snapshots

### Canary Rollout (Argo Rollouts)
<img src="docs/argo-canary.png" width="650"/>

### Autoscaling CPU Load Test (HPA)
<img src="docs/hpa-scale.png" width="650"/>

### Live Request Metrics (Grafana)
<img src="docs/grafana-requests.png" width="650"/>

