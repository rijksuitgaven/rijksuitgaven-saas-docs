# Database Export Commands

This document contains copy-paste commands for exporting database schema and sample data from the current MySQL database.

---

## Prerequisites

You'll need:
- Access to your MySQL database server
- MySQL username and password
- Database name
- Terminal/command line access

---

## Export 1: Database Schema Only (No Data)

This exports the complete database structure without any actual data.

### Command:

```bash
mysqldump -u [USERNAME] -p --no-data --skip-comments [DATABASE_NAME] > rijksuitgaven_schema.sql
```

**Replace:**
- `[USERNAME]` - Your MySQL username
- `[DATABASE_NAME]` - Your database name

**What this does:**
- Exports all table structures
- Exports indexes and constraints
- Does NOT include actual data
- Creates a file called `rijksuitgaven_schema.sql`

**Expected output:**
- You'll be prompted for password
- File will be created in current directory
- File size: typically 10-100 KB for schema only

**To verify:**
```bash
ls -lh rijksuitgaven_schema.sql
head -50 rijksuitgaven_schema.sql
```

---

## Export 2: Table List with Row Counts

Get a list of all tables and how many rows each contains.

### Command:

```bash
mysql -u [USERNAME] -p [DATABASE_NAME] -e "SELECT table_name, table_rows FROM information_schema.tables WHERE table_schema = '[DATABASE_NAME]' ORDER BY table_rows DESC;"
```

**Replace:**
- `[USERNAME]` - Your MySQL username
- `[DATABASE_NAME]` - Your database name (appears twice!)

**What this does:**
- Lists all tables in the database
- Shows row count for each table
- Sorted by size (largest first)

**Expected output:**
```
+---------------------------+------------+
| table_name                | table_rows |
+---------------------------+------------+
| wp_financiele_instrumenten| 45000      |
| wp_apparaatsuitgaven      | 32000      |
...
```

---

## Export 3: Sample Data from Each Table

Export just the first 100 rows from each table to see data structure.

### For a specific table:

```bash
mysqldump -u [USERNAME] -p [DATABASE_NAME] [TABLE_NAME] --where="1 limit 100" > sample_[TABLE_NAME].sql
```

**Replace:**
- `[USERNAME]` - Your MySQL username
- `[DATABASE_NAME]` - Your database name
- `[TABLE_NAME]` - The table name (e.g., wp_financiele_instrumenten)

**Example for Financial Instruments table:**
```bash
mysqldump -u myuser -p rijksuitgaven_db wp_financiele_instrumenten --where="1 limit 100" > sample_financiele_instrumenten.sql
```

**What this does:**
- Exports table structure
- Exports first 100 rows only
- Safe for sharing (limited data)

---

## Export 4: Complete Database Structure Report

Get detailed information about database structure.

### Command:

```bash
mysql -u [USERNAME] -p [DATABASE_NAME] -e "SHOW TABLES;" > table_list.txt
```

**What this does:**
- Lists all tables in plain text
- Easy to review and share

---

## Export 5: WordPress Plugin List

If you can access the WordPress admin or database directly:

### Via Database:

```bash
mysql -u [USERNAME] -p [DATABASE_NAME] -e "SELECT option_value FROM wp_options WHERE option_name = 'active_plugins';"
```

### Or manually:

Simply list the plugins from WordPress Admin → Plugins page and save to a text file.

---

## Alternative: Using SequelAce

Since you mentioned using SequelAce, here's how to export from there:

### Export Schema:
1. Open your database in SequelAce
2. File → Export
3. Select all tables
4. Format: SQL
5. Check "Structure" only (uncheck "Content")
6. Save as `rijksuitgaven_schema.sql`

### Export Sample Data:
1. File → Export
2. Select specific table
3. Check both "Structure" and "Content"
4. In Advanced options, add: `LIMIT 100`
5. Save as `sample_[tablename].sql`

---

## What to Share

Please export and share:

1. ✓ **Complete database schema** (`rijksuitgaven_schema.sql`)
2. ✓ **Table list with row counts** (copy terminal output)
3. ✓ **Sample data from main tables:**
   - Financiële Instrumenten (100 rows)
   - Apparaatsuitgaven (100 rows)
   - One of the pivot/aggregated tables (100 rows)
4. ✓ **WordPress plugin list** (from admin panel or text file)

---

## Security Notes

- Schema file is safe to share (no sensitive data)
- Sample data (100 rows) should be fine but check for any sensitive info
- Don't share full database dumps with passwords or personal data
- If needed, we can anonymize the sample data

---

## How to Share Files

Options:
1. Upload to GitHub repository in a private branch
2. Share via secure file transfer
3. Email if files are small (< 5 MB)
4. Add to our documentation repo in `/03-current-state/exports/` folder

---

## Next Steps After Export

Once I receive these files, I will:

1. **Analyze database schema**
   - Understand table structures
   - Identify relationships
   - Document data model

2. **Review sample data**
   - Understand data formats
   - Identify data quality issues
   - Plan data access patterns

3. **Design new architecture**
   - Plan how to connect to existing database
   - Design API layer
   - Plan search indexing strategy

4. **Create migration plan**
   - Document Phase 1 approach
   - Identify any data structure improvements for Phase 2
   - Plan user/subscription migration

---

## Questions During Export

If you encounter any issues:
- Error messages → Copy full error text
- Permission issues → Let me know
- Uncertain about database name → Run: `SHOW DATABASES;`
- Need to find table names → Run: `SHOW TABLES;`

Just share the error or question and I'll provide the fix!
