# Local Development Setup

**Purpose:** Everything needed to develop on a new machine.

**Last Updated:** 2026-01-24

---

## Quick Start (New Machine)

```bash
# 1. Clone the repo
git clone [your-repo-url]
cd rijksuitgaven

# 2. Install system dependencies
brew install node python3

# 3. Install Python packages (for Typesense sync)
pip3 install typesense psycopg2-binary

# 4. Install Node packages (run from /app folder)
cd app
npm install

# 5. Set up environment variables
cp .env.example .env.local
# Edit .env.local with your keys
```

---

## System Requirements

| Tool | Version | Install Command | Purpose |
|------|---------|-----------------|---------|
| Node.js | 18+ | `brew install node` | Next.js runtime |
| Python | 3.10+ | `brew install python3` | Typesense sync scripts |
| npm | 9+ | Comes with Node | Package manager |
| Git | Any | `brew install git` | Version control |

### Verify Installation

```bash
node --version    # Should be v18+
npm --version     # Should be v9+
python3 --version # Should be 3.10+
git --version     # Any version
```

---

## Python Packages

| Package | Install Command | Purpose |
|---------|-----------------|---------|
| typesense | `pip3 install typesense` | Typesense API client |
| psycopg2-binary | `pip3 install psycopg2-binary` | PostgreSQL driver |

### Install All Python Packages

```bash
pip3 install typesense psycopg2-binary
```

---

## Node Packages (in /app folder)

Installed via `npm install` from `package.json`. Key packages:

| Package | Purpose | Status |
|---------|---------|--------|
| next | React framework | ✅ Installed |
| react | UI library (v19) | ✅ Installed |
| typescript | Type safety | ✅ Installed |
| tailwindcss | Styling | ✅ Installed |
| @supabase/supabase-js | Supabase client | ✅ Installed |
| typesense | Typesense client | ✅ Installed |
| @tanstack/react-table | Data tables | ✅ Installed |
| @tanstack/react-query | Server state | ✅ Installed |
| @tremor/react | Charts/dashboards | ⏳ **NOT YET** - needs React 18, we have React 19 |
| shadcn/ui components | UI components | ✅ Installed (v3.7.0) |

### Tremor Compatibility Issue (2026-01-24)

Tremor v3.18.7 requires React 18, but Next.js 15 uses React 19. Options:
1. Wait for Tremor to update (recommended - we don't need charts until Week 3)
2. Use `--legacy-peer-deps` to force install (risky)
3. Use Recharts directly (Tremor is built on Recharts)

**Decision:** Skip Tremor for now, revisit in Week 3 when charts are needed.

---

## Environment Variables

Create `app/.env.local` with:

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://kmdelrgtgglcrupprkqf.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[get from Supabase dashboard]
SUPABASE_SERVICE_ROLE_KEY=[get from Supabase dashboard]

# Typesense
NEXT_PUBLIC_TYPESENSE_HOST=typesense-production-35ae.up.railway.app
NEXT_PUBLIC_TYPESENSE_PORT=443
NEXT_PUBLIC_TYPESENSE_PROTOCOL=https
TYPESENSE_API_KEY=0vh4mxafjeuvd676gw92kpjflg6fuv57

# Database (for scripts only, not Next.js)
SUPABASE_DB_URL=postgresql://postgres.kmdelrgtgglcrupprkqf:bahwyq-6botry-veStad@aws-1-eu-west-1.pooler.supabase.com:5432/postgres
```

**Get keys from:**
- Supabase: https://supabase.com/dashboard/project/kmdelrgtgglcrupprkqf/settings/api

---

## Running Locally

### Next.js Development Server

```bash
cd app
npm run dev
```

Opens at: http://localhost:3000

### Typesense Sync

```bash
cd /Users/michielmaandag/SynologyDrive/code/watchtower/rijksuitgaven
SUPABASE_DB_URL="postgresql://postgres.kmdelrgtgglcrupprkqf:bahwyq-6botry-veStad@aws-1-eu-west-1.pooler.supabase.com:5432/postgres" python3 scripts/typesense/sync_to_typesense.py --recreate
```

---

## IDE Setup (Optional)

### VS Code Extensions

- ESLint
- Prettier
- Tailwind CSS IntelliSense
- TypeScript Vue Plugin (Volar) - for better TS support

### VS Code Settings

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

---

## Railway Deployment

| Property | Value |
|----------|-------|
| App URL | `https://rijksuitgaven-production.up.railway.app` |
| **Beta URL** | `https://beta.rijksuitgaven.nl` |
| Root Directory | `app` |
| Region | EU West (Amsterdam) |
| Auto-deploy | Yes (on push to main) |

**To redeploy manually:** Push to GitHub, Railway auto-deploys.

### DNS Configuration (Vimexx)

| Type | Name | Value |
|------|------|-------|
| CNAME | beta | `rijksuitgaven-production.up.railway.app` |

**Production DNS (Week 8):** Will point `rijksuitgaven.nl` to Railway.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `command not found: node` | `brew install node` |
| `command not found: python` | Use `python3` instead |
| `command not found: pip` | Use `pip3` instead |
| Supabase connection fails | Use pooler URL, not direct URL |
| Port 3000 in use | `npx kill-port 3000` or use `npm run dev -- -p 3001` |

---

## Folder Structure

```
rijksuitgaven/
├── app/                    # Next.js application (NEW)
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── .env.local         # Environment variables (not in git)
├── scripts/
│   ├── typesense/         # Typesense sync scripts
│   ├── sql/               # Database scripts
│   └── data/              # Data migration scripts
├── docs/                  # Documentation
├── logs/                  # Session logs
└── ...
```
