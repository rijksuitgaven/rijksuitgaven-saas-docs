# Product Backlog

**Last Updated:** 2026-01-20

Items logged for future versions, not in V1.0 scope.

---

## Post-V1.0 Backlog

### Entity Resolution / Recipient Normalization

**Priority:** High (Post-V1.0)
**Added:** 2026-01-20

**Problem:**
Recipients are spelled differently across data sources:
- "politie", "Politie", "POLITIE" (casing)
- "Politie" vs "Korps Nationale Politie" (name variations)
- Same entity appears as multiple rows in aggregated views

**V1.0 Workaround:**
Case-insensitive grouping using `UPPER(Ontvanger)` in SQL queries.
- Solves: casing differences
- Does NOT solve: name variations, entity matching

**Future Solution (V2.0+):**
Build entity mapping table:
```
┌─────────────────────────┬──────────────────────┬───────────┐
│ variant                 │ canonical_name       │ kvk       │
├─────────────────────────┼──────────────────────┼───────────┤
│ politie                 │ Politie Nederland    │ 12345678  │
│ Korps Nationale Politie │ Politie Nederland    │ 12345678  │
└─────────────────────────┴──────────────────────┴───────────┘
```

**Approach:**
1. KvK-based matching where available
2. Fuzzy matching + manual review for rest
3. Maintain entity table for new data imports

**Effort:** Medium-High (data analysis + tooling + manual review)

---

### Download Screenshot Feature

**Priority:** Low
**Added:** 2026-01-20

Allow users to download a screenshot/image of current view for reports and presentations.

---

### Full URL State Restoration

**Priority:** Medium
**Added:** 2026-01-20

V1.0 has basic URL sharing (search term, module, key filters).
V2.0: Full state in URL including expanded rows, pagination position, all filter states.

---

### Inzichten / Self-Service BI

**Priority:** Medium
**Added:** 2026-01-20

Current "Inzichten BETA" shows pre-prepared analyses. Future: allow users to create their own analyses and dashboards.

---
