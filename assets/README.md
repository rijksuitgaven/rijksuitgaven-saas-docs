# Assets Directory

This directory contains all visual assets for the documentation including screenshots, diagrams, wireframes, and mockups.

## Directory Structure

### `/screenshots/current-ui/`
Screenshots of the **current platform** UI before migration.

**Naming convention:** `[section]-[feature]-[optional-detail].png`

**Examples:**
- `homepage-logged-out.png`
- `dashboard-user-view.png`
- `subscription-management-page.png`
- `content-browser-category-view.png`
- `admin-dashboard.png`
- `payment-history-page.png`

**Reference in docs:** `![Description](../assets/screenshots/current-ui/filename.png)`

---

### `/screenshots/new-ui/`
Screenshots of the **new platform** UI during and after development.

**Naming convention:** Same as current-ui

---

### `/diagrams/architecture/`
Architecture diagrams including system, infrastructure, data, security, and integration architecture.

**Suggested files:**
- `current-system-architecture.png` - Current platform architecture
- `target-system-architecture.png` - New platform architecture
- `infrastructure-diagram.png` - Infrastructure setup
- `data-flow-diagram.png` - Data flow between components
- `security-architecture.png` - Security layer design
- `integration-diagram.png` - External integrations

**Tools:** draw.io, Lucidchart, Mermaid, etc.

**Reference in docs:** `![Description](../assets/diagrams/architecture/filename.png)`

---

### `/diagrams/user-flows/`
User flow diagrams showing step-by-step user journeys.

**Suggested files:**
- `user-registration-flow.png`
- `subscription-purchase-flow.png`
- `content-access-flow.png`
- `payment-flow.png`
- `password-reset-flow.png`

**Reference in docs:** `![Description](../assets/diagrams/user-flows/filename.png)`

---

### `/diagrams/data-models/`
Database schemas, ER diagrams, and data models.

**Suggested files:**
- `current-er-diagram.png` - Current database schema
- `target-er-diagram.png` - New database schema
- `data-migration-mapping.png` - How data maps from old to new

**Reference in docs:** `![Description](../assets/diagrams/data-models/filename.png)`

---

### `/wireframes/`
Low-fidelity wireframes for new UI designs.

**Naming convention:** `[page-name]-wireframe.png`

**Examples:**
- `homepage-wireframe.png`
- `dashboard-wireframe.png`
- `subscription-page-wireframe.png`

**Reference in docs:** `![Description](../assets/wireframes/filename.png)`

---

### `/design-mockups/`
High-fidelity design mockups and visual designs.

**Naming convention:** `[page-name]-mockup.png`

**Examples:**
- `homepage-mockup.png`
- `dashboard-mockup.png`
- `mobile-view-mockup.png`

**Reference in docs:** `![Description](../assets/design-mockups/filename.png)`

---

## File Formats

### Recommended Formats
- **Screenshots:** PNG (for UI screenshots with text)
- **Diagrams:** PNG or SVG (SVG preferred for scalability)
- **Photos:** JPG
- **Wireframes:** PNG or PDF
- **Mockups:** PNG

### File Size
- Keep individual files under 2MB when possible
- Optimize images before uploading
- Use appropriate compression

## Adding Images to Documentation

### Markdown Syntax
```markdown
![Alt text describing the image](../assets/screenshots/current-ui/filename.png)
```

### With Caption
```markdown
![Dashboard view](../assets/screenshots/current-ui/dashboard.png)
*Figure 1: Current user dashboard showing subscription status*
```

### Relative Paths
From documentation files, use relative paths:
- From root level docs: `./assets/...`
- From 01-project-overview: `../assets/...`
- From 03-current-state: `../assets/...`

## Best Practices

1. **Use descriptive filenames** - Makes it easy to find images later
2. **Include alt text** - Helps with accessibility and context
3. **Optimize file sizes** - Keeps the repository lean
4. **Organize by category** - Use the appropriate subdirectory
5. **Version important diagrams** - e.g., `architecture-v1.png`, `architecture-v2.png`
6. **Keep originals** - Store editable source files (e.g., .drawio, .fig) if possible

## Tools for Creating Diagrams

### Architecture Diagrams
- **draw.io** (diagrams.net) - Free, open-source
- **Lucidchart** - Professional diagramming
- **Mermaid** - Text-based diagrams
- **PlantUML** - Code-based UML diagrams

### User Flows
- **Whimsical** - Easy flow diagrams
- **Figma** - Design and flow tool
- **Miro** - Collaborative whiteboard

### Wireframes & Mockups
- **Figma** - Industry standard
- **Sketch** - Mac-based design tool
- **Adobe XD** - Adobe's design tool
- **Balsamiq** - Quick wireframes

## Quick Start: Adding Current UI Screenshots

1. Take screenshots of your current platform
2. Save them to `/assets/screenshots/current-ui/`
3. Use descriptive names (e.g., `homepage-logged-in.png`)
4. Reference in the documentation:
   - In `03-current-state/current-features.md`
   - In `05-design/` files when showing before/after

## Example Usage

In `03-current-state/current-features.md`:
```markdown
## User Dashboard

![Current user dashboard](../assets/screenshots/current-ui/dashboard-user-view.png)
*Current dashboard showing subscription status and recent activity*

### Features Visible:
- Subscription tier display
- Recent content accessed
- Payment history link
- Account settings button
```
