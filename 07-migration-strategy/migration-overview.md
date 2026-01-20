# Migration Strategy

**Last Updated:** 2026-01-20

## Overview

Migration details are integrated into the sprint plan for practical execution.

**See:** [`09-timelines/v1-sprint-plan.md`](../09-timelines/v1-sprint-plan.md)

## Key Migration Points

| Topic | Location |
|-------|----------|
| Data migration (MySQL → Supabase) | Sprint Plan, Week 1 |
| User migration (50 users, Magic Link) | Sprint Plan, Week 6 |
| Customer communication | Sprint Plan, Week 8 |
| Go-live cutover | Sprint Plan, Week 8 |

## Migration Summary

- **Data:** Export MySQL source tables → Import to Supabase
- **Users:** 50 emails imported → Magic Link authentication
- **Approach:** Clean cutover (no parallel run needed)
- **Rollback:** Keep MySQL running until Supabase verified

---

**Note:** Detailed migration scripts and commands will be created during Week 1 development.
