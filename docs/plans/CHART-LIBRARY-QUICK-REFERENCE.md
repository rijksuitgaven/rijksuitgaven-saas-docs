# Chart Library Quick Reference

**Project Decision:** Recharts ✅
**Date:** 2026-01-26
**Status:** Implementation starts Week 2

---

## At-a-Glance Comparison

```
                React 19   Bundle   Line   Bar   Area   Sankey   Treemap   Heatmap
Recharts        ✅         50KB     ✅     ✅    ✅     ✅       ❌        ❌
Nivo            ✅         80KB     ✅     ✅    ✅     ✅       ✅        ✅
Chart.js        ⚠️         25KB     ✅     ✅    ✅     ❌       ❌        ❌
Victory         ✅         60KB     ✅     ✅    ✅     ✅       ⚠️        ❌
Tremor          ❌         95KB     ✅     ✅    ✅     ✅       ✅        ✅
```

---

## Recommendation Table (Detailed)

| Library | React 19 | V1.0 | V2.0 | Size | Effort | Notes |
|---------|----------|------|------|------|--------|-------|
| **Recharts** ⭐ | ✅ | ✅✅✅ | ✅✅ | 50KB | Low | **SELECTED.** Perfect for V1, Sankey built-in, add Nivo for treemap |
| Nivo | ✅ | ✅✅ | ✅✅✅ | 80KB | Med | Excellent for V2, overkill for V1. Use if V2 prioritized |
| Chart.js | ⚠️ | ✅✅ | ❌ | 25KB | Low | Too limited for V2 roadmap. No Sankey/Treemap |
| Victory | ✅ | ✅✅ | ✅✅ | 60KB | Med | Good alternative, but larger than Recharts |
| **Tremor** ❌ | ❌ | ✅✅ | ✅✅ | 95KB | - | BLOCKED: React 19 incompatible. Cannot use. |

---

## Implementation Checklist

- [ ] **Week 2 Monday:** `npm install recharts`
- [ ] Remove Tremor from package.json if installed
- [ ] Create `components/ui/charts/` wrapper library
- [ ] Test Line, Bar, Area chart components
- [ ] Apply brand colors (#E62D75, #0E3261, #436FA3)
- [ ] Document in LOCAL-SETUP.md
- [ ] Integrate with Overzicht page wireframe
- [ ] Verify responsive behavior
- [ ] Deploy to Railway

---

## Code Examples

### Basic Line Chart (Recharts)

```tsx
import { LineChart, Line, XAxis, YAxis, ResponsiveContainer, Tooltip, Legend } from 'recharts';

export function SpendingTrendChart({ data }: { data: Array<{ year: number; bedrag: number }> }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <LineChart data={data}>
        <XAxis dataKey="year" />
        <YAxis />
        <Tooltip formatter={(value) => `€${value.toLocaleString()}`} />
        <Legend />
        <Line
          type="monotone"
          dataKey="bedrag"
          stroke="#E62D75"
          strokeWidth={2}
          dot={{ fill: '#E62D75', r: 4 }}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

### Basic Bar Chart (Recharts)

```tsx
import { BarChart, Bar, XAxis, YAxis, ResponsiveContainer } from 'recharts';

export function ModuleComparisonChart({ data }: { data: Array<{ module: string; total: number }> }) {
  return (
    <ResponsiveContainer width="100%" height={300}>
      <BarChart data={data}>
        <XAxis dataKey="module" />
        <YAxis />
        <Bar dataKey="total" fill="#436FA3" />
      </BarChart>
    </ResponsiveContainer>
  );
}
```

### Sankey Diagram (Recharts - V2.0)

```tsx
import { Sankey, Sink, Source, Link, Node, NodeTypes } from 'recharts';

export function MoneyFlowSankey({ data }: { data: any }) {
  return (
    <ResponsiveContainer width="100%" height={500}>
      <Sankey
        width={500}
        height={400}
        data={data}
        node={<Node />}
        link={<Link stroke="rgba(230, 45, 117, 0.3)" />}
        nodePadding={50}
      >
        <Tooltip />
      </Sankey>
    </ResponsiveContainer>
  );
}
```

---

## V2.0 Timeline: Adding Advanced Viz

**When treemap/heatmap needed (Week 13+):**

```bash
# Add Nivo for advanced visualizations
npm install @nivo/core @nivo/treemap @nivo/heatmap

# Expected bundle impact: +80KB gzipped (one-time)
```

**Cost-benefit:**
- Start V1 lean: 50KB
- Add V2 features selectively: +80KB only when needed
- Total V2 bundle: ~130KB (still reasonable)

---

## Troubleshooting

### "Recharts not responding to clicks"
- Recharts components are not interactive by default
- Use `onClick` handlers on `<Shape>` elements or wrap in custom component
- Solution: Add `dot` props with custom click handlers

### "Charts not sizing properly"
- Always wrap in `<ResponsiveContainer>` for responsive sizing
- Specify height on ResponsiveContainer: `height={300}`
- Don't set height on chart component itself

### "Tooltip text cut off"
- Use `wrapperStyle={{ outline: 'none' }}` on Tooltip
- Position tooltip with `position={{ x: 0, y: 0 }}`
- Or use custom Tooltip component

### "Performance slow with large datasets (10K+ rows)"
- Recharts handles well up to 5K points
- For 10K+, consider aggregating data before charting
- Use `isAnimationActive={false}` to disable animations (saves 30% rendering time)

---

## Decision References

- **Full analysis:** `docs/plans/2026-01-26-chart-library-evaluation.md`
- **Tech stack:** `04-target-architecture/RECOMMENDED-TECH-STACK.md` (updated)
- **Session context:** `logs/SESSION-CONTEXT.md`

---

## Questions Before Week 2?

Ask before implementing:
1. Do you prefer Recharts simplicity or Nivo upfront completeness?
2. Should chart components be wrapped in shadcn/ui style (recommended) or used directly?
3. Any specific chart interactions needed for V1.0 Overzicht page?

**Ready to proceed with Recharts in Week 2.**
