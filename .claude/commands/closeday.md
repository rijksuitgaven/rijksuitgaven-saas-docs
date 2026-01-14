Create a comprehensive daily log for today and update session context. Follow this process:

1. **Create Daily Log** (`logs/daily/YYYY-MM-DD.md`):
   - Summary of day's work
   - All tasks completed with checkmarks
   - Files created/modified with links
   - Key decisions made (reference ADRs if applicable)
   - Problems encountered and solutions
   - Discussions and clarifications with user
   - Metrics (files created, lines written, etc.)
   - Current blockers (if any)
   - Next steps (priority order)
   - Notes for next session
   - Commits made today

2. **Update Session Context** (`logs/SESSION-CONTEXT.md`):
   - Update "Last Updated" date
   - Update "Current Status" section
   - Update "Active Tasks" table
   - Add any new files to "Recent Work" (keep only last 3)
   - Add any new decisions to "Key Decisions Made"
   - Update "Pending Decisions" (remove resolved, add new)
   - Update "Blockers" section
   - Update "Next Steps" with priority order
   - Update "Last Session" note at bottom

3. **Commit to GitHub**:
   - Add both files: `git add logs/`
   - Commit with message: "Daily log YYYY-MM-DD: [brief summary]"
   - Push to GitHub: `git push`

4. **Output Summary**:
   Display a concise summary showing:
   - Date of log created
   - Number of tasks completed today
   - Number of files created/modified
   - Key decisions made
   - Current blockers (if any)
   - Top 3 next steps
   - Commit hash and link to GitHub

Use the daily log template format from `logs/daily/2026-01-14.md` as reference for structure and detail level.
