# V1.0 Sprint Plan

**Created:** 2026-01-20
**Duration:** 8 weeks
**Working Mode:** Solo founder + AI (few hours daily)
**Start Date:** TBD (after account setup)

---

## Working Assumptions

| Factor | Value |
|--------|-------|
| Daily dedication | 2-4 hours |
| Decision speed | Immediate (no approval delays) |
| Execution speed | Same-day (copy-paste commands) |
| AI role | Writes all code, provides commands |
| Human role | Executes commands, tests, decides |

---

## Pre-Sprint: Account Setup (Day 0)

**Duration:** 1-2 hours
**Blocker:** Must complete before Week 1

| Task | Action | Time |
|------|--------|------|
| Create Supabase account | https://supabase.com → Sign up → Create project (EU region) | 10 min |
| Create Railway account | https://railway.app → Sign up | 5 min |
| Note credentials | Save project URLs, API keys in password manager | 5 min |
| Share with Claude | Provide project URLs (not secrets) for configuration | 5 min |

**Deliverable:** Supabase project URL, Railway account ready

---

## Week 1: Infrastructure + Data Migration

**Goal:** Data in Supabase, searchable in Typesense

### Day 1-2: Supabase Setup

| Task | Details |
|------|---------|
| Create database schema | Claude provides SQL, you execute in Supabase SQL editor |
| Tables to create | `apparaat`, `inkoop`, `instrumenten`, `provincie`, `publiek`, `stad`, `universal_search`, `universal_search_source` |
| Enable pgvector | For V2.0 readiness (empty, just enable extension) |
| Set up Row Level Security | Basic policies for authenticated users |

### Day 3-4: Data Migration

| Task | Details |
|------|---------|
| Export MySQL data | CSV export of source tables (not pivot tables) |
| Transform if needed | Claude provides scripts for any data cleaning |
| Import to Supabase | Use Supabase CSV import or SQL INSERT |
| Verify row counts | Compare MySQL vs Supabase counts |

### Day 5-6: Typesense Setup

| Task | Details |
|------|---------|
| Deploy Typesense on Railway | Claude provides railway.json config |
| Create search collections | One per module + universal |
| Build initial index | Sync from Supabase → Typesense |
| Test search | Verify <100ms response |

### Day 7: Next.js Project

| Task | Details |
|------|---------|
| Create Next.js app | `npx create-next-app@latest rijksuitgaven-v2` |
| Install dependencies | Supabase client, Typesense client, shadcn/ui, Tremor, TanStack |
| Project structure | Claude provides folder structure |
| Deploy to Railway | Basic "Hello World" deployment |

**Week 1 Deliverables:**
- [ ] Supabase with all source data
- [ ] Typesense with search index
- [ ] Next.js deployed on Railway
- [ ] All services connected

---

## Week 2: Backend API + Data Layer

**Goal:** API endpoints for all modules with on-the-fly aggregation

### Day 1-2: API Structure

| Task | Details |
|------|---------|
| FastAPI setup | Or Next.js API routes (decide based on preference) |
| Base endpoints | `/api/v1/modules/{module}` |
| Query parameters | filters, sort, pagination, grouping |

### Day 3-4: Aggregation Queries

| Task | Details |
|------|---------|
| Single-view queries | GROUP BY with year columns |
| Expandable row data | Detail query for expansion |
| Performance test | Ensure <500ms for aggregations |

### Day 5-7: Module Endpoints

| Endpoint | Table |
|----------|-------|
| `/api/v1/instrumenten` | `instrumenten` |
| `/api/v1/apparaat` | `apparaat` |
| `/api/v1/inkoop` | `inkoop` |
| `/api/v1/provincie` | `provincie` |
| `/api/v1/stad` | `stad` |
| `/api/v1/publiek` | `publiek` |
| `/api/v1/integraal` | `universal_search` + `universal_search_source` |

**Week 2 Deliverables:**
- [ ] All 7 module API endpoints working
- [ ] On-the-fly aggregation tested
- [ ] <500ms response times verified

---

## Week 3: Core UI Components

**Goal:** Reusable table component with single-view architecture

### Day 1-2: Table Component

| Component | Features |
|-----------|----------|
| `DataTable` | TanStack Table base |
| Year columns | 2016-2024 always visible |
| Totaal column | Row sum |
| Sorting | Click column headers |
| Pagination | 25/50/100 rows per page |

### Day 3-4: Expandable Rows

| Feature | Details |
|---------|---------|
| Expand icon | ▶ / ▼ toggle |
| Sub-rows | Grouped by user-selected field |
| Grouping selector | Dropdown: Regeling, Artikel, Instrument, etc. |
| Lazy loading | Fetch detail data on expand |

### Day 5-7: Filter Panel

| Filter | Type |
|--------|------|
| Text search | Typesense instant search |
| Year range | Slider or dropdown |
| Amount range | Min/max input |
| Module-specific | Varies per module |
| Clear all | Reset button |

**Week 3 Deliverables:**
- [ ] DataTable component working
- [ ] Expandable rows with grouping
- [ ] Filter panel functional
- [ ] Real-time filter application

---

## Week 4: Module Pages

**Goal:** All 7 module pages functional

### Day 1-3: Module Pages

| Page | Route | Special Features |
|------|-------|------------------|
| Instrumenten | `/instrumenten` | Regeling, Ontvanger, Artikel filters |
| Apparaat | `/apparaat` | Kostensoort (no Ontvanger) |
| Inkoop | `/inkoop` | Leverancier, Ministerie, Categorie |
| Provincie | `/provincie` | Provincie filter |
| Stad (Gemeente) | `/gemeente` | Stad filter |
| Publiek | `/publiek` | Source (RVO/COA/NWO), Regeling |

### Day 4-5: Cross-Module (Integraal)

| Feature | Details |
|---------|---------|
| Route | `/integraal` |
| Results | Recipient → Module breakdown |
| Click behavior | Navigate to module with filter |
| Totals row | Grand total footer |

### Day 6-7: Styling & Responsive

| Task | Details |
|------|---------|
| Consistent styling | shadcn/ui theme |
| Mobile responsive | Horizontal scroll, fixed first column |
| Loading states | Skeletons while fetching |
| Error states | User-friendly error messages |

**Week 4 Deliverables:**
- [ ] All 6 module pages working
- [ ] Integraal (cross-module) page working
- [ ] Consistent styling across all pages
- [ ] Mobile-friendly tables

---

## Week 5: Search + Navigation

**Goal:** Global search bar, autocomplete, navigation

### Day 1-2: Global Search Bar

| Feature | Details |
|---------|---------|
| Position | Header, always visible |
| Autocomplete | <50ms suggestions from Typesense |
| Results | Recipients across all modules |
| Click result | Navigate to relevant module with filter |

### Day 3-4: Header Navigation

| Element | Details |
|---------|---------|
| Logo | Link to Overzicht (logged in) or Home (logged out) |
| Nav items | Overzicht, Integraal, Modules dropdown |
| Modules dropdown | All 6 modules |
| Auth buttons | Login / Account |

### Day 5-7: Enhanced Filters

| Enhancement | Details |
|-------------|---------|
| URL state | Basic filter state in URL for sharing |
| Filter persistence | Remember last used filters (localStorage) |
| Quick filters | Common presets per module |
| CSV export button | Download visible results (max 500) |

**Week 5 Deliverables:**
- [ ] Global search with autocomplete
- [ ] Header navigation complete
- [ ] URL sharing (basic)
- [ ] CSV export working

---

## Week 6: Auth + Overzicht

**Goal:** Magic Link auth, user migration, Overzicht page

### Day 1-2: Supabase Auth Setup

| Task | Details |
|------|---------|
| Enable Magic Link | Supabase dashboard → Auth → Providers |
| Email templates | Customize login email (Dutch) |
| Session config | Set session duration |
| Protected routes | Middleware for `/app/*` routes |

### Day 3-4: User Migration

| Task | Details |
|------|---------|
| Export WordPress emails | 50 users from `4yi3uwye_users` |
| Import to Supabase | Auth → Users → Import |
| Test Magic Link | Send test login to yourself |
| Announcement email | Draft "Welcome to new platform" email |

### Day 5-7: Overzicht Page

| Feature | Details |
|---------|---------|
| Route | `/overzicht` |
| Module totals | All 6 modules with year columns |
| Sub-sources | Publiek (RVO/COA/NWO), Provincies, Gemeentes |
| Gemeentes | Top 10 + "Toon alle X gemeentes" |
| Grand total | Footer row |
| Click navigation | Module/sub-source → module page with filter |

**Week 6 Deliverables:**
- [ ] Magic Link authentication working
- [ ] 50 users migrated
- [ ] Overzicht page complete
- [ ] Protected routes enforced

---

## Week 7: Marketing Pages

**Goal:** All public pages live

### Day 1-2: Homepage

| Section | Details |
|---------|---------|
| Hero | Port from WordPress (same copy) |
| Value props | 3 cards |
| Sample data | Live table preview |
| Features grid | 6 features |
| Pricing | €150/month |
| CTA | Demo request |

### Day 3-4: Support Pages

| Page | Details |
|------|---------|
| `/support` | Index with search |
| `/support/[slug]` | Markdown articles |
| Content | Getting started, FAQ, Data sources, Export guide |

### Day 5-6: Other Pages

| Page | Details |
|------|---------|
| `/about` | Mission, data sources |
| `/contact` | Contact form (Resend/Postmark) |
| `/pricing` | Pricing details, FAQ |
| `/demo` | Calendly embed |
| `/terms`, `/privacy` | Legal pages |

### Day 7: Polish

| Task | Details |
|------|---------|
| SEO | Meta tags, Open Graph |
| Footer | Links, social, legal |
| 404 page | Custom not found |
| Favicon | Brand icon |

**Week 7 Deliverables:**
- [ ] Homepage live
- [ ] All support pages
- [ ] Contact form working
- [ ] All marketing pages complete

---

## Week 8: Launch

**Goal:** Go live with V1.0

### Day 1-2: Testing

| Test | Details |
|------|---------|
| Functional | All features work end-to-end |
| Performance | Search <100ms, page load <1s |
| Mobile | Test on phone/tablet |
| Auth flow | Magic Link complete flow |
| Edge cases | Empty results, long text, special characters |

### Day 3-4: Performance & Security

| Task | Details |
|------|---------|
| Lighthouse audit | Score >90 |
| Security review | RLS policies, no data leaks |
| Error tracking | Set up Sentry or similar |
| Analytics | Set up Plausible |

### Day 5-6: Customer Migration

| Task | Details |
|------|---------|
| Send announcement | Email to 50 users |
| Provide Magic Link | Login instructions |
| Support availability | Monitor for issues |
| Old site redirect | Plan for WordPress shutdown |

### Day 7: Go Live

| Task | Details |
|------|---------|
| DNS switch | Point domain to Railway |
| SSL verify | HTTPS working |
| Final smoke test | All critical paths |
| Celebrate | V1.0 shipped! |

**Week 8 Deliverables:**
- [ ] All tests passing
- [ ] Performance targets met
- [ ] 50 users notified and migrated
- [ ] V1.0 LIVE

---

## Daily Workflow

```
Morning (or whenever you start):
1. Claude: /startday → get today's tasks
2. You: Execute first task
3. Claude: Provide code/commands
4. You: Copy-paste, execute, report result
5. Repeat until done or blocked

End of session:
1. Claude: /closeday → update logs
2. Note any blockers for tomorrow
```

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Stuck on technical issue | Ask Claude for alternative approach |
| Data migration issues | Keep MySQL running until verified |
| Performance problems | Typesense handles search; optimize queries |
| User complaints | Have support email ready; respond quickly |
| Scope creep | Refer to this plan; add to backlog, not V1.0 |

---

## Post-Launch (Week 9+)

After V1.0 is stable:
1. Monitor for bugs (1-2 weeks)
2. Gather user feedback
3. Plan V2.0 Research Mode
4. Begin V2.0 development (+12 weeks)

---

## Success Criteria Reminder

| Metric | Target |
|--------|--------|
| Search response | <100ms |
| Autocomplete | <50ms |
| Page load | <1s |
| Infrastructure cost | <€180/month |
| All modules | 7 working |
| Users migrated | 50 |

---

**Document Version:** 1.0
**Last Updated:** 2026-01-20
