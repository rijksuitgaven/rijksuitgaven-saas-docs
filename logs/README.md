# Project Logs

This directory contains daily progress logs and session context for the Rijksuitgaven.nl SaaS migration project.

## Directory Structure

```
logs/
├── README.md                 # This file
├── SESSION-CONTEXT.md        # Current session state (always up-to-date)
└── daily/                    # Daily progress logs
    ├── 2026-01-14.md
    ├── 2026-01-15.md
    └── ...
```

## Files

### SESSION-CONTEXT.md
**Purpose:** Single source of truth for current project state.

**Contains:**
- Current project phase
- Active tasks and their status
- Pending decisions
- Blockers
- Quick links to recent work
- What to do next

**Usage:** Read this file at the start of each session to understand exactly where we left off.

---

### daily/YYYY-MM-DD.md
**Purpose:** Detailed log of daily activities.

**Contains:**
- Date and session duration
- Tasks completed
- Files created/modified
- Key decisions made
- Problems encountered and solutions
- Discussions and clarifications
- Next steps planned

**Usage:** Review these for historical context, progress tracking, and audit trail.

---

## Workflow

### Starting a Day
1. Read `SESSION-CONTEXT.md` to understand current state
2. Review yesterday's daily log if needed (context)

### During the Day
- Work on tasks
- Make decisions
- Create/modify files

### Ending the Day (`/closeday`)
1. Create daily log for today (`daily/YYYY-MM-DD.md`)
2. Update `SESSION-CONTEXT.md` with current state
3. Commit both to GitHub
4. Summary displayed

---

## Log Format

Daily logs follow a consistent structure for easy parsing and review. See any daily log file for the template.

---

## Notes

- All logs are version controlled in Git
- Logs are written in Markdown for readability
- Dates use ISO 8601 format (YYYY-MM-DD)
- Links use relative paths for portability
