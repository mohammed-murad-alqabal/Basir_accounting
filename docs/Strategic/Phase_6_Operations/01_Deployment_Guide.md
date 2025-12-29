# Deployment Guide: Baseer Intelligent Financial System

**Document ID:** BASEER-P6-002  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** DevOps & Operations

---

## 1. Mobile App Deployment

### Android (Play Store)

#### Build Commands

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Build App Bundle (recommended)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

#### Signing Configuration

```groovy
// android/app/build.gradle
android {
    signingConfigs {
        release {
            keyAlias = <credential-fixture>("ANDROID_KEY_ALIAS")
            keyPassword = <credential-fixture>("ANDROID_KEY_PASSWORD")
            storeFile = file(System.getenv("ANDROID_KEYSTORE_PATH"))
            storePassword = System.getenv("ANDROID_STORE_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### Play Store Checklist

- [ ] App bundle built and signed
- [ ] Store listing complete (Arabic + English)
- [ ] Screenshots (6 per language)
- [ ] Feature graphic (1024x500)
- [ ] Privacy policy URL
- [ ] Content rating questionnaire
- [ ] Target audience settings
- [ ] In-app purchases configured (if applicable)

---

### iOS (App Store)

#### Build Commands

```bash
# Install pods
cd ios && pod install && cd ..

# Build iOS release
flutter build ios --release

# Open in Xcode for archive
open ios/Runner.xcworkspace
```

#### Xcode Configuration

1. Select "Any iOS Device" as target
2. Product → Archive
3. Distribute App → App Store Connect
4. Upload

#### App Store Checklist

- [ ] Bundle ID registered
- [ ] Provisioning profiles valid
- [ ] App icon (1024x1024)
- [ ] Screenshots (all device sizes)
- [ ] App previews (optional)
- [ ] Privacy policy URL
- [ ] App Store description (Arabic + English)
- [ ] Keywords optimized
- [ ] Review notes prepared

---

## 2. Backend Deployment

### Docker Build

```dockerfile
# Dockerfile
FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/server

FROM alpine:3.19
RUN apk --no-cache add ca-certificates tzdata
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
```

### Kubernetes Deployment

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: baseer-api
  labels:
    app: baseer-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: baseer-api
  template:
    metadata:
      labels:
        app: baseer-api
    spec:
      containers:
        - name: api
          image: gcr.io/baseer/api:latest
          ports:
            - containerPort: 8080
          resources:
            requests:
              memory: "256Mi"
              cpu: "100m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: baseer-secrets
                  key: <credential-fixture>
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 30
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
```

### Deploy Script

```bash
#!/bin/bash
# deploy.sh

set -e

ENV=$1
IMAGE_TAG=$2

echo "Deploying to $ENV with tag $IMAGE_TAG"

# Build and push image
docker build -t gcr.io/baseer/api:$IMAGE_TAG .
docker push gcr.io/baseer/api:$IMAGE_TAG

# Update Kubernetes
kubectl set image deployment/baseer-api \
  api=<credential-fixture>:$IMAGE_TAG \
  -n baseer-$ENV

# Wait for rollout
kubectl rollout status deployment/baseer-api -n baseer-$ENV

echo "Deployment complete!"
```

---

## 3. Database Migration

### Migration Commands

```bash
# Create new migration
migrate create -ext sql -dir migrations -seq create_invoices

# Run migrations
migrate -path migrations -database "$DATABASE_URL" up

# Rollback last migration
migrate -path migrations -database "$DATABASE_URL" down 1

# Check version
migrate -path migrations -database "$DATABASE_URL" version
```

### Pre-Deployment Checklist

- [ ] Migration tested in staging
- [ ] Backup completed
- [ ] Rollback plan documented
- [ ] Downtime window communicated (if required)

---

## 4. Environment Configuration

### Required Environment Variables

| Variable        | Description           | Example           |
| --------------- | --------------------- | ----------------- |
| `DATABASE_URL`  | PostgreSQL connection | `postgres://...`  |
| `REDIS_URL`     | Redis connection      | `redis://...`     |
| `JWT_SECRET`    | Token signing key     | `(secure random)` |
| `ZATCA_API_URL` | ZATCA endpoint        | `https://...`     |
| `ZATCA_CERT`    | ZATCA certificate     | `(base64)`        |
| `SENTRY_DSN`    | Error tracking        | `https://...`     |

### Secrets Management

```yaml
# k8s/secrets.yaml (encrypted with SOPS)
apiVersion: v1
kind: Secret
metadata:
  name: baseer-secrets
type: Opaque
data:
  database-url: <base64>
  jwt-secret: <credential-fixture>
  zatca-cert: <base64>
```

---

## 5. Rollback Procedures

### Mobile App Rollback

| Platform | Procedure                                |
| -------- | ---------------------------------------- |
| Android  | Staged rollout → halt → previous version |
| iOS      | Request expedited review for fix         |

### Backend Rollback

```bash
# Rollback to previous deployment
kubectl rollout undo deployment/baseer-api -n baseer-prod

# Rollback to specific revision
kubectl rollout undo deployment/baseer-api --to-revision=5 -n baseer-prod
```

### Database Rollback

```bash
# Rollback last migration
migrate -path migrations -database "$DATABASE_URL" down 1

# Restore from backup (last resort)
pg_restore -d baseer_prod backup_20251227.dump
```

---

## 6. Health Checks

### Endpoints

| Endpoint   | Purpose            | Expected Response    |
| ---------- | ------------------ | -------------------- |
| `/health`  | Liveness           | 200 OK               |
| `/ready`   | Readiness          | 200 OK (all deps up) |
| `/metrics` | Prometheus metrics | Metrics data         |

### Monitoring Post-Deploy

1. Check error rates in Sentry
2. Monitor API latency in Grafana
3. Verify database connections
4. Check app store crash reports

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
