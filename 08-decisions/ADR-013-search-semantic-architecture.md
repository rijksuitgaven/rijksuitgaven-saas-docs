# ADR-013: Search and Semantic Architecture

**Status:** Accepted

**Date:** 2026-01-20

**Deciders:** Product Owner, Technical Lead (AI Assistant)

## Context and Problem Statement

The platform needs to support both traditional keyword search (V1.0) and semantic search capabilities (V2.0). With 500,000+ recipients, we need an architecture that:
1. Delivers <100ms keyword search with autocomplete
2. Supports semantic queries like "show me defense-related spending"
3. Enables Regeling → Wet matching for wetten.overheid.nl integration
4. Stays within €180/month budget
5. Is easy to deploy and maintain (copy/paste infrastructure preference)

## Decision Drivers

- **Performance:** <50ms autocomplete, <100ms keyword search required
- **Cost:** €180/month budget constraint, minimize AI API costs
- **Scale:** 500,000+ recipients, ~2,000 Regelingen
- **Semantics:** Need semantic understanding without expensive per-query AI calls
- **Simplicity:** Team prefers easy-to-deploy infrastructure

## Considered Options

1. **Typesense only** - Use Typesense for all search, rely on Claude for semantics
2. **Vector search for all 500K recipients** - Embed all recipients in vector database
3. **IBOS classification + selective vector search** - Domain lookup + vectors for edge cases only
4. **Full RAG architecture** - Retrieval-Augmented Generation for all queries

## Decision Outcome

Chosen option: **"IBOS classification + selective vector search"** (Option 3), because it minimizes costs while meeting all requirements. IBOS domain lookup handles most semantic queries for free, vector search is limited to ~2-5K vectors, and Claude is used sparingly for complex reasoning only.

### Architecture Summary

| Component | Purpose | V1.0 | V2.0 |
|-----------|---------|------|------|
| Typesense | Keyword search, autocomplete | Yes | Yes |
| Supabase PostgreSQL | Data storage, auth | Yes | Yes |
| pgvector (Supabase) | Vector search (~2-5K vectors) | No | Yes |
| IBOS domain lookup | Semantic classification | No | Yes |
| Claude | Complex reasoning only | No | Sparingly |

### Positive Consequences

- Cost-effective: ~€97-150/month total (within budget)
- Scalable: IBOS lookup handles 500K recipients without vector overhead
- Fast: Keyword search <100ms, semantic lookup <100ms
- Simple: No dedicated vector database service needed
- Future-proof: pgvector available for expansion if needed

### Negative Consequences

- IBOS classification effort: 500K recipients need domain codes (V2.0 task)
- Some edge cases won't work perfectly with domain lookup
- pgvector has limits if vector needs grow beyond ~100K

## Pros and Cons of the Options

### Option 1: Typesense Only + Claude for Semantics

Rely on Typesense for search, route all semantic queries to Claude.

**Pros:**
- Simplest architecture (one search engine)
- No vector database needed

**Cons:**
- Every semantic query hits Claude API = €0.01-0.03 per query
- At 5000 queries/month = €50-150 just for semantics
- Slow for semantic queries (API latency)

### Option 2: Vector Search for All 500K Recipients

Embed all recipients in a vector database (Qdrant, Pinecone, or pgvector).

**Pros:**
- True semantic search for all recipients
- "Find similar recipients" works natively

**Cons:**
- 500K vectors = slow queries in pgvector, expensive in Pinecone
- Embedding generation cost (~€50-100 one-time)
- Extra infrastructure to manage
- Overkill when IBOS classification handles 90% of cases

### Option 3: IBOS Classification + Selective Vectors (CHOSEN)

Pre-classify recipients into 30 IBOS domains. Use domain lookup for semantics. Only embed ~2-5K items for edge cases.

**Pros:**
- Domain lookup is free and fast (<100ms)
- Only ~2-5K vectors needed (pgvector handles easily)
- Claude used sparingly = low cost
- Fits in Supabase (no extra service)

**Cons:**
- IBOS classification effort required (V2.0)
- Some nuanced queries may not map cleanly to domains
- Requires synonym/mapping maintenance

### Option 4: Full RAG Architecture

Embed all data, use RAG for every query with Claude.

**Pros:**
- Most sophisticated semantic understanding
- Best for natural language queries

**Cons:**
- Most expensive (every query hits AI)
- Most complex infrastructure
- Overkill for structured financial data
- Budget would be exceeded

## Technical Details

### IBOS Domain Classification Flow

```
User: "defense spending"
         │
         ▼
Synonym lookup: "defense" → ["Defensie", "Krijgsmacht"]
         │
         ▼
IBOS mapping: → Code "03" (Defensie)
         │
         ▼
SQL: SELECT * FROM recipients WHERE ibos_code = '03'
         │
         ▼
Result: All defense recipients (FREE, <100ms)
```

### Vector Search Scope (V2.0)

| Use Case | Vectors Needed |
|----------|---------------|
| Regeling → Wet matching | ~2,000 |
| "Similar recipients" feature | ~2,000 (top recipients only) |
| Ambiguous query fallback | Reuse above |
| **Total** | **~2,000-5,000** |

### Data Sync Strategy

- Nightly rebuild: Supabase → Typesense index
- Triggered by cron after data imports
- Simple, fits monthly government data update cycle

## Links

- [Search Requirements](../02-requirements/search-requirements.md) - Full search specification
- [Recommended Tech Stack](../04-target-architecture/RECOMMENDED-TECH-STACK.md) - Updated architecture
- [Session Context](../logs/SESSION-CONTEXT.md) - Decision history
