# Operational Runbook: Baseer Intelligent Financial System

**Document ID:** BASEER-P6-003  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** DevOps & Operations

---

## 1. System Overview

### Architecture Summary

```
┌───────────────────────────────────────────────────────────────┐
│                     Load Balancer (GCP)                        │
└──────────────────────────┬────────────────────────────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
    ┌─────────┐       ┌─────────┐       ┌─────────┐
    │ API-1   │       │ API-2   │       │ API-3   │
    │ (Pod)   │       │ (Pod)   │       │ (Pod)   │
    └────┬────┘       └────┬────┘       └────┬────┘
         │                 │                 │
         └────────────┬────┴─────────────────┘
                      │
         ┌────────────┼────────────┐
         ▼            ▼            ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │PostgreSQL│  │ Redis   │  │ Storage │
    │ (Cloud) │  │ (Cache) │  │ (GCS)   │
    └─────────┘  └─────────┘  └─────────┘
```

### Access Information

| Resource   | Access Method   | Documentation         |
| ---------- | --------------- | --------------------- |
| Kubernetes | `kubectl`       | k8s/README.md         |
| Database   | Cloud SQL Proxy | Secrets in Vault      |
| Logs       | Cloud Logging   | GCP Console           |
| Monitoring | Grafana         | monitoring.baseer.app |

---

## 2. Common Operations

### Scaling

```bash
# Scale API pods
kubectl scale deployment baseer-api --replicas=5 -n baseer-prod

# Check HPA status
kubectl get hpa -n baseer-prod
```

### Log Access

```bash
# Stream live logs
kubectl logs -f deployment/baseer-api -n baseer-prod

# Search logs (last hour)
gcloud logging read 'resource.type="k8s_container" AND resource.labels.namespace_name="baseer-prod"' --limit=100 --freshness=1h
```

### Database Operations

```bash
# Connect to database
cloud_sql_proxy -instances=baseer-prod:us-central1:main=tcp:5432 &
psql "host=127.0.0.1 dbname=baseer user=app"

# Create backup
gcloud sql backups create --instance=baseer-main --async
```

---

## 3. Incident Response

### Severity Definitions

| Level | Criteria          | Response Time | Examples             |
| ----- | ----------------- | ------------- | -------------------- |
| SEV1  | Total outage      | 15 min        | Site down, data loss |
| SEV2  | Major degradation | 1 hour        | Payments failing     |
| SEV3  | Minor degradation | 4 hours       | Slow performance     |
| SEV4  | Low impact        | 24 hours      | UI bug               |

### On-Call Rotation

| Week | Primary           | Secondary         |
| ---- | ----------------- | ----------------- |
| 1    | DevOps Engineer A | Backend Engineer  |
| 2    | DevOps Engineer B | Backend Engineer  |
| 3    | Backend Engineer  | DevOps Engineer A |

### Incident Workflow

```
1. DETECT   → Alert triggered / User report
2. TRIAGE   → Assess severity, assign owner
3. CONTAIN  → Stop the bleeding
4. DIAGNOSE → Find root cause
5. RESOLVE  → Fix the issue
6. RECOVER  → Verify normal operation
7. REVIEW   → Post-mortem within 48h
```

---

## 4. Common Issues & Fixes

### Issue: High API Latency

**Symptoms:** API response time > 500ms

**Diagnosis:**

```bash
# Check pod resource usage
kubectl top pods -n baseer-prod

# Check database connections
SELECT count(*) FROM pg_stat_activity;
```

**Resolution:**

1. Scale API pods if CPU > 80%
2. Clear Redis cache if stale
3. Check for slow queries in logs

---

### Issue: Database Connection Errors

**Symptoms:** "connection refused" or "too many connections"

**Diagnosis:**

```bash
# Check connection count
SELECT count(*) FROM pg_stat_activity WHERE state = 'active';

# Check for long-running queries
SELECT pid, age(clock_timestamp(), query_start), query
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start;
```

**Resolution:**

1. Kill long-running queries if blocking
2. Increase connection pool if legitimate load
3. Scale API pods to distribute connections

---

### Issue: Pods Crashing (OOMKilled)

**Symptoms:** Pods restarting, OOMKilled in events

**Diagnosis:**

```bash
kubectl describe pod <pod-name> -n baseer-prod
kubectl logs <pod-name> --previous -n baseer-prod
```

**Resolution:**

1. Check for memory leaks in recent deploys
2. Increase memory limits temporarily
3. Investigate with memory profiling

---

### Issue: Invoice Generation Failing

**Symptoms:** 500 errors on invoice create

**Diagnosis:**

```bash
# Check ZATCA API connectivity
curl -I https://gw-fatoora.zatca.gov.sa/e-invoicing/developer-portal

# Check certificate validity
openssl x509 -in zatca-cert.pem -noout -dates
```

**Resolution:**

1. Renew ZATCA certificate if expired
2. Check ZATCA service status
3. Enable offline mode if ZATCA down

---

## 5. Maintenance Procedures

### Database Maintenance

| Task         | Frequency     | Command                    |
| ------------ | ------------- | -------------------------- |
| Vacuum       | Weekly (auto) | `VACUUM ANALYZE;`          |
| Reindex      | Monthly       | `REINDEX DATABASE baseer;` |
| Stats update | Daily (auto)  | `ANALYZE;`                 |

### Certificate Renewal

| Certificate | Expiry Check   | Renewal            |
| ----------- | -------------- | ------------------ |
| TLS/SSL     | 30 days before | Let's Encrypt auto |
| ZATCA       | 60 days before | Manual renewal     |
| API Keys    | Never expires  | Rotate annually    |

### Dependency Updates

| Type             | Frequency   | Process         |
| ---------------- | ----------- | --------------- |
| Security patches | Immediately | Hotfix deploy   |
| Minor versions   | Weekly      | Staging → Prod  |
| Major versions   | Quarterly   | Full test cycle |

---

## 6. Monitoring Alerts

### Critical Alerts (Page On-Call)

| Alert         | Threshold         | Action                  |
| ------------- | ----------------- | ----------------------- |
| API Down      | 0 healthy pods    | Immediate response      |
| Error Rate    | > 5%              | Investigate immediately |
| Database Down | Connection failed | Failover check          |
| Disk Usage    | > 90%             | Emergency cleanup       |

### Warning Alerts (Slack Only)

| Alert              | Threshold   | Action           |
| ------------------ | ----------- | ---------------- |
| High Latency       | p95 > 500ms | Monitor trend    |
| Memory Usage       | > 80%       | Plan scaling     |
| Certificate Expiry | < 30 days   | Schedule renewal |

---

## 7. Recovery Procedures

### Full System Recovery

1. Verify infrastructure status
2. Check database availability and restore if needed
3. Deploy API from last known good image
4. Verify health checks passing
5. Run smoke tests
6. Enable traffic

### Database Recovery

```bash
# List available backups
gcloud sql backups list --instance=baseer-main

# Restore from backup
gcloud sql backups restore <BACKUP_ID> --restore-instance=baseer-main

# Verify data integrity
SELECT COUNT(*) FROM invoices;
SELECT COUNT(*) FROM users;
```

---

## 8. Contact Information

### Escalation Contacts

| Role             | Name       | Phone    | Slack        |
| ---------------- | ---------- | -------- | ------------ |
| On-Call Primary  | (Rotation) | +966 5XX | @oncall      |
| DevOps Lead      | -          | +966 5XX | @devops-lead |
| Engineering Lead | -          | +966 5XX | @eng-lead    |
| CEO              | -          | +966 5XX | @ceo         |

### External Contacts

| Service    | Support                  |
| ---------- | ------------------------ |
| GCP        | Cloud Support Console    |
| ZATCA      | Technical Support Portal |
| Domain/DNS | Cloudflare Dashboard     |

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
