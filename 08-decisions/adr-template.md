# ADR-XXX: [Title]

**Status:** Proposed / Accepted / Deprecated / Superseded by [ADR-XXX]

**Date:** YYYY-MM-DD

**Deciders:** [List of people involved in the decision]

**Technical Story:** [Ticket/Issue URL if applicable]

## Context and Problem Statement

[Describe the context and problem statement in 2-3 sentences. What is the issue we're trying to solve?]

## Decision Drivers

- [Driver 1: e.g., Performance requirements]
- [Driver 2: e.g., Team expertise]
- [Driver 3: e.g., Cost constraints]
- [Driver 4: e.g., Scalability needs]

## Considered Options

- [Option 1]
- [Option 2]
- [Option 3]

## Decision Outcome

Chosen option: "[Option X]", because [justification. e.g., best fit for our requirements, balances cost and performance, etc.].

### Positive Consequences

- [e.g., improved performance]
- [e.g., better developer experience]
- [e.g., reduced complexity]

### Negative Consequences

- [e.g., increased infrastructure cost]
- [e.g., learning curve for team]
- [e.g., vendor lock-in]

## Pros and Cons of the Options

### [Option 1]

[Brief description of option 1]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

### [Option 2]

[Brief description of option 2]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

### [Option 3]

[Brief description of option 3]

**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

## Links

- [Link type] [Link to related documentation, ADRs, etc.]
- [Related ADR] [ADR-XXX: Title]
- [External Reference] [URL to relevant article, documentation, etc.]

---

## How to Use This Template

1. Copy this template and rename it to `ADR-XXX-short-title.md` where XXX is the next number
2. Fill in all sections
3. Update the status as the decision progresses
4. Link to this ADR from relevant documentation
5. Update the main README if this is a significant decision

## Examples of Good ADRs

### Good Context Statement
"We need to choose a database for our SaaS platform. The system needs to handle 10,000+ concurrent users, store structured user and subscription data, and support complex queries for reporting."

### Good Decision Drivers
- Must handle 10,000+ concurrent users
- Team has strong experience with relational databases
- Need ACID compliance for financial transactions
- Budget constraint: < $500/month for database hosting

### Good Decision Outcome
"Chosen option: PostgreSQL on AWS RDS, because it provides ACID compliance, excellent performance for our use case, strong ecosystem support, and the team has extensive PostgreSQL experience. While it's more expensive than some alternatives, the operational benefits and reduced risk justify the cost."
