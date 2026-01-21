# Typesense Configuration (Railway)

**Created:** 2026-01-21
**Environment:** Railway (rijksuitgaven project)

---

## Service Details

| Property | Value |
|----------|-------|
| Service Name | typesense |
| Docker Image | `typesense/typesense:27.1` |
| Platform | Railway |
| Project | rijksuitgaven |

---

## Environment Variables

```env
TYPESENSE_API_KEY=rua-ts-k8x2m9p4q7w3
TYPESENSE_DATA_DIR=/data
```

**Note:** Store the API key securely. You'll need it for:
- Next.js client to query search
- Data sync scripts to index data

---

## Custom Start Command

```bash
mkdir -p /data && typesense-server --data-dir=/data --api-key=$TYPESENSE_API_KEY --enable-cors
```

**Why:** Railway doesn't auto-create the `/data` directory, so we create it before starting Typesense.

---

## Networking

Railway auto-generates:
- Internal URL (for services within the same project)
- Public URL (after enabling in Settings → Networking)

**To get the public URL:**
1. Go to Typesense service → Settings → Networking
2. Click "Generate Domain" or enable public access
3. URL format: `https://typesense-production-xxxx.up.railway.app`

---

## API Endpoints

Once running, Typesense exposes:

| Endpoint | Purpose |
|----------|---------|
| `GET /health` | Health check |
| `GET /collections` | List collections |
| `POST /collections` | Create collection |
| `POST /collections/{name}/documents` | Index documents |
| `GET /collections/{name}/documents/search` | Search |

**Authentication:** All requests require header:
```
X-TYPESENSE-API-KEY: rua-ts-k8x2m9p4q7w3
```

---

## Data Persistence

**Status:** ✅ Persistent (Railway Volume attached)

| Property | Value |
|----------|-------|
| Mount path | `/data` |
| Size | Auto-managed by Railway |
| Added | 2026-01-21 |

Search index now persists across redeploys.

---

## Monitoring

- **Logs:** Railway dashboard → Typesense service → Deployments → View Logs
- **Metrics:** Railway dashboard → Typesense service → Metrics tab
- **Health check:** `curl https://[your-url]/health`

---

## Collections to Create (Week 1)

| Collection | Source Table | Purpose |
|------------|--------------|---------|
| `recipients` | All tables | Autocomplete on Ontvanger/Leverancier |
| `instrumenten` | instrumenten | Module search |
| `apparaat` | apparaat | Module search |
| `inkoop` | inkoop | Module search |
| `provincie` | provincie | Module search |
| `gemeente` | gemeente | Module search |
| `publiek` | publiek | Module search |
| `universal` | universal_search | Cross-module search |

---

## Related Files

- Database schema: `scripts/sql/001-initial-schema.sql`
- Sync scripts: `scripts/data/` (to be created)
