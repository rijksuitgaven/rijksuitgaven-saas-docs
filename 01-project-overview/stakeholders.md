# Stakeholders

## Overview

This is a **solo founder project**. One person handles all roles: development, design, product, marketing, and operations. AI (Claude Code) serves as the primary development partner across multiple roles.

---

## Solo Founder

| Aspect | Detail |
|--------|--------|
| **Role** | Founder / Everything |
| **Background** | Marketing savvy with tech background |
| **Experience** | Co-founder of AI company (successfully sold) |
| **Working style** | Visual preference, values speed |
| **Decision authority** | Full authority on all decisions |

### Responsibilities

| Area | Tasks |
|------|-------|
| **Product** | Requirements, priorities, feature decisions |
| **Technical** | Architecture approvals, final sign-off, deployments |
| **Business** | Pricing, marketing, customer relationships |
| **Operations** | Infrastructure, monitoring, support |

### Working Preferences

| Preference | Detail |
|------------|--------|
| Communication | English |
| Approach | Stay factual, ask 3+ questions when unclear |
| Speed | Critical - avoid unnecessary delays |
| Tooling | Minimal - each new tool needs strong justification |
| Content | Can edit code/components directly (no CMS needed) |

---

## AI Development Partner (Claude Code)

See [development-methodology.md](./development-methodology.md) for the complete AI collaboration model.

### AI Roles

| Role | Responsibilities |
|------|------------------|
| **Solution Architect** | Architecture design, ADRs, tech evaluation |
| **Full-Stack Developer** | Frontend, backend, database, tests |
| **DevOps Engineer** | CI/CD, infrastructure, monitoring |
| **Product Manager** | Specs, user stories, backlog management |
| **QA Engineer** | Test design, code review, quality assurance |
| **Technical Writer** | Documentation, API docs, guides |
| **Security Specialist** | Security review, auth design, best practices |

### Copy-Paste Execution Model

AI provides ready-to-execute commands; human maintains all production access:
- AI never stores credentials
- Human reviews before execution
- Human executes all production commands
- Audit trail maintained

---

## External Stakeholders

### Current Customers

| Metric | Value |
|--------|-------|
| Current subscribers | ~10-20 (estimate) |
| Customer type | Professionals needing government data |
| Key requirement | Continuity during migration |

### Future Customers (V2.0 Target)

| Segment | Description |
|---------|-------------|
| **Political parties** | Budget for research, high willingness to pay |
| **Well-funded media** | Investigative journalism teams |
| **Consultancies** | Policy research firms |

### Partners/Vendors

| Vendor | Type | Role |
|--------|------|------|
| Supabase | Database/Auth provider | Core infrastructure |
| Railway | Hosting provider | Application hosting |
| Typesense | Search engine | Self-hosted search |
| Anthropic (Claude) | AI provider | Development partner, V2.0 features |

---

## Communication Plan

### Solo Founder Context
With a single person handling all roles, communication is simplified:

| Activity | Frequency | Method |
|----------|-----------|--------|
| AI progress updates | Per session | Claude Code output |
| Customer updates | As needed | Email |
| Documentation | Continuous | GitHub repository |

### Documentation as Communication
All decisions, progress, and context captured in:
- `logs/SESSION-CONTEXT.md` - Current state
- `logs/daily/*.md` - Daily logs
- `08-decisions/ADR-*.md` - Architecture decisions

---

## Decision Authority

### Single Decision Maker
Solo founder has full authority on all decisions. AI provides recommendations with clear rationale.

### Decision Framework

| Decision Type | Process |
|---------------|---------|
| Strategic direction | Founder decides |
| Product features | Founder decides (AI recommends) |
| Technical architecture | ADR process, founder approves |
| Implementation details | AI implements, founder reviews |
| Production deployments | Founder executes |

### Decision Documentation
All significant decisions documented as Architecture Decision Records (ADRs) in `/08-decisions/`.

---

## RACI Matrix

| Activity | Founder | AI |
|----------|---------|-----|
| Requirements gathering | A | R |
| Architecture design | A | R |
| Code implementation | I | R |
| Code review | R | C |
| Testing | R | C |
| Documentation | A | R |
| Deployment | R | C |
| Customer communication | R | - |
| Budget decisions | R | C |

**Legend:** R = Responsible, A = Accountable, C = Consulted, I = Informed

---

**Document Version:** 1.0
**Last Updated:** 2026-01-20
