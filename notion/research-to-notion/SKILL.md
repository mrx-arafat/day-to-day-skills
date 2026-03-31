---
name: research-to-notion
description: Use when you need to research a topic and automatically document findings in Notion without manual setup or database creation
---

# Research to Notion

## Overview

**Research to Notion** automates the entire workflow of researching a topic and creating a structured Notion database with findings. Instead of manually researching, creating databases, and copying content, this skill orchestrates web research, database creation via Notion API, and populates findings as organized pages.

**Core principle:** Notion API + curl + structured research = zero-friction knowledge capture

## When to Use

**Use this skill when:**
- Researching a topic (technology, competitor analysis, market research) and want it in Notion immediately
- Need to compare options (React vs Vue, different approaches) with organized findings
- Building knowledge bases from research sessions
- Documenting decisions with sourced information
- Creating competitive analysis or literature reviews
- Comparing frameworks, tools, or methodologies

**When NOT to use:**
- Organizing existing Notion content (use Notion UI)
- Ad-hoc notes (just write directly in Notion)
- Simple one-page research (copy-paste is faster)

## Core Pattern

```
Research Topic → Web Research → Create Database → Parse Findings → Add Pages → Return URL
```

### Step 1: Conduct Web Research
Search for the topic using WebSearch, WebFetch, or specialized research tools. Gather:
- Performance comparisons
- Pros/cons for each option
- Use cases
- Ecosystem information
- Community size/adoption
- Recommendations

### Step 2: Find/Validate Parent Page
Notion databases must live inside pages. Use API to find an existing page:

```bash
curl -s -X POST "https://api.notion.com/v1/search" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '{"filter": {"property": "object", "value": "page"}}'
```

Extract first page ID from results.

### Step 3: Create Database
POST to Notion API to create database with structured properties:

```bash
curl -X POST "https://api.notion.com/v1/databases" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "parent": {"type": "page_id", "page_id": "$PARENT_ID"},
    "title": [{"type": "text", "text": {"content": "Your Topic"}}],
    "properties": {
      "Name": {"title": {}},
      "Category": {"rich_text": {}},
      "Details": {"rich_text": {}},
      "Status": {"select": {"options": [
        {"name": "Complete", "color": "green"}
      ]}}
    }
  }'
```

Save the returned `id` - this is your database ID.

### Step 4: Organize Research Findings
Group research into logical categories:
- Performance metrics
- Learning curve
- Ecosystem/community
- Use cases
- Recommendations

### Step 5: Add Pages to Database
For each finding, POST a new page:

```bash
curl -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "parent": {"type": "database_id", "database_id": "$DB_ID"},
    "properties": {
      "Name": {"title": [{"text": {"content": "Finding Title"}}]},
      "Category": {"rich_text": [{"text": {"content": "Category"}}]},
      "Details": {"rich_text": [{"text": {"content": "Details..."}}]},
      "Status": {"select": {"name": "Complete"}}
    }
  }'
```

### Step 6: Return Database URL
```
https://www.notion.so/[DATABASE_ID]
```

## Quick Reference

### Notion API Endpoints

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Find pages | POST | `/v1/search` |
| Create database | POST | `/v1/databases` |
| Create page | POST | `/v1/pages` |
| Update page | PATCH | `/v1/pages/{page_id}` |

### Required Headers

```bash
-H "Authorization: Bearer $TOKEN"
-H "Content-Type: application/json"
-H "Notion-Version: 2022-06-28"
```

### Property Types in Notion

| Property | Type | Example |
|----------|------|---------|
| Title | `"title"` | `{"title": {"title": [{"text": {"content": "..."}}]}}` |
| Rich Text | `"rich_text"` | `{"rich_text": [{"text": {"content": "..."}}]}` |
| Select | `"select"` | `{"select": {"name": "Option"}}` |
| Date | `"date"` | `{"date": {"start": "2026-04-01"}}` |

## Implementation

### Prerequisites
- **Notion API Token:** `$NOTION_API_TOKEN` environment variable set
- **curl:** For API requests
- **jq:** For JSON parsing (optional but recommended)
- **Web research tools:** WebSearch, WebFetch, or specialized tools

### Complete Workflow Example

```bash
#!/bin/bash

TOKEN="$NOTION_API_TOKEN"
TOPIC="React vs Vue"

# Step 1: Conduct research (using WebSearch/WebFetch)
# [Research results stored in variable]

# Step 2: Find parent page
PARENT_ID=$(curl -s -X POST "https://api.notion.com/v1/search" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '{"filter": {"property": "object", "value": "page"}}' \
  | jq -r '.results[0].id')

# Step 3: Create database
DB=$(curl -s -X POST "https://api.notion.com/v1/databases" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d @- << EOJSON
{
  "parent": {"type": "page_id", "page_id": "$PARENT_ID"},
  "title": [{"type": "text", "text": {"content": "$TOPIC Research"}}],
  "icon": {"type": "emoji", "emoji": "🔍"},
  "properties": {
    "Name": {"title": {}},
    "Category": {"rich_text": {}},
    "Findings": {"rich_text": {}},
    "Status": {"select": {"options": [{"name": "Complete", "color": "green"}]}}
  }
}
EOJSON
)

DB_ID=$(echo "$DB" | jq -r '.id')
echo "Database created: https://www.notion.so/$DB_ID"

# Step 4-5: Add research findings as pages
# For each finding category:
curl -s -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d @- << EOJSON > /dev/null
{
  "parent": {"type": "database_id", "database_id": "$DB_ID"},
  "properties": {
    "Name": {"title": [{"text": {"content": "Performance Comparison"}}]},
    "Category": {"rich_text": [{"text": {"content": "Performance"}}]},
    "Findings": {"rich_text": [{"text": {"content": "Vue 3.5 shows 36% better DOM manipulation..."}}]},
    "Status": {"select": {"name": "Complete"}}
  }
}
EOJSON

echo "✓ Research documented in Notion"
```

### Key Bash Patterns

**Extract JSON values:**
```bash
ID=$(echo "$RESPONSE" | jq -r '.id')
TITLE=$(echo "$RESPONSE" | jq -r '.properties.title.title[0].text.content')
```

**Heredoc for multi-line JSON:**
```bash
curl -X POST "endpoint" -d @- << EOJSON
{ "json": "content" }
EOJSON
```

**Loop over findings:**
```bash
for finding in "${findings[@]}"; do
  curl -X POST "https://api.notion.com/v1/pages" -d "..."
done
```

## Common Mistakes

### ❌ Wrong Parent Type
```bash
"parent": {"workspace": true}  # ❌ Creates orphaned database
"parent": {"type": "page_id", "page_id": "$ID"}  # ✅ Correct
```
**Fix:** Always use `page_id` parent, not workspace.

### ❌ Missing Required Headers
```bash
curl -X POST "endpoint" -d '...'  # ❌ No headers
curl -X POST "endpoint" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Notion-Version: 2022-06-28" \
  -d '...'  # ✅ Correct
```
**Fix:** Always include Authorization and Notion-Version headers.

### ❌ JSON Parsing Errors
```bash
echo "$RESPONSE" | grep "id"  # ❌ Fragile
echo "$RESPONSE" | jq -r '.id'  # ✅ Reliable
```
**Fix:** Use jq for JSON parsing, not grep.

### ❌ No Error Handling
```bash
DB_ID=$(echo "$DB" | jq -r '.id')  # ❌ Ignores API errors
DB_ID=$(echo "$DB" | jq -r '.id // empty')  # ✅ Checks for null
```
**Fix:** Check for null responses before using values.

### ❌ Hardcoding Token
```bash
TOKEN="ntn_xxxxx..."  # ❌ Never hardcode secrets
TOKEN="$NOTION_API_TOKEN"  # ✅ Use environment variable
```
**Fix:** Always use environment variables for secrets. NEVER commit tokens to git.

### ❌ Forgetting to Save Database ID
Research database created but ID lost → can't add pages.
**Fix:** Save ID to variable or file immediately after creation.

### ❌ Wrong Property Structure
```bash
"Name": [{"text": {"content": "..."}}]  # ❌ Wrong
"Name": {"title": [{"text": {"content": "..."}}]}  # ✅ Correct
```
**Fix:** Wrap property values in their type container (title, rich_text, select, etc.).

## Step-by-Step for Automation

1. **Take topic as input** from user
2. **Conduct research** using WebSearch/WebFetch
3. **Set TOKEN variable** from environment
4. **Find parent page** via search API
5. **Create database** with proper structure
6. **Parse findings** into categories
7. **Add pages** with findings and sources
8. **Return URL** for user to visit

## References

- [Notion API Documentation](https://developers.notion.com)
- [Notion Database Properties](https://developers.notion.com/reference/database#database-properties)
- [Notion Page Creation](https://developers.notion.com/reference/post-page)

## Related Skills

- **WebSearch** - Research gathering
- **WebFetch** - Detailed content extraction
- **Systematic Debugging** - Troubleshooting API errors
