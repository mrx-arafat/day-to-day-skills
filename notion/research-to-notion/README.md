# Research to Notion Skill

Automate the entire workflow of researching a topic and creating a structured Notion database with findings.

## Quick Start

### 1. Set Your Notion API Token

```bash
export NOTION_API_TOKEN="ntn_your_token_here"
```

Or add to your `.zshrc` permanently:
```bash
echo 'export NOTION_API_TOKEN="ntn_your_token_here"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Use the Helper Script

```bash
./research-to-notion.sh "React vs Vue" \
  "Performance|Vue 3.5 shows 36% better DOM manipulation" \
  "Learning Curve|Vue has gentler learning curve, React steeper" \
  "Market Adoption|React 42.6% vs Vue 18.8% adoption" \
  "Mobile|React Native available, Vue no official solution"
```

**Output:**
```
✓ Parent page found
✓ Database created
  ✓ Performance
  ✓ Learning Curve
  ✓ Market Adoption
  ✓ Mobile

✅ Complete!
Database URL: https://www.notion.so/33404f91-f50e-81b9-af46-f226efc22dd1
```

### 3. From Claude Code

In Claude Code, invoke the skill:

```
research React vs Vue frameworks and document in Notion
```

Claude will:
1. Conduct web research
2. Organize findings
3. Call the helper script
4. Return database URL

## How It Works

### The Automation Flow

```
Research Topic
  ↓
Conduct Web Research (WebSearch/WebFetch)
  ↓
Find Parent Page (via Notion API search)
  ↓
Create Database (POST to /databases)
  ↓
Parse & Organize Findings
  ↓
Add Pages (POST to /pages for each finding)
  ↓
Return Database URL
```

### What Gets Created

**In Notion:**
- New database titled "[Topic] Research"
- Properties: Name, Category, Details, Status
- One page per finding
- All pages marked "Complete"

## File Structure

```
research-to-notion/
  ├── SKILL.md                 # Full skill reference (read this)
  ├── research-to-notion.sh    # Executable helper script
  └── README.md                # This file
```

## Usage Examples

### Example 1: Technology Comparison

```bash
./research-to-notion.sh "GraphQL vs REST APIs" \
  "Query Flexibility|GraphQL allows clients to request specific fields" \
  "Learning Curve|REST simpler, GraphQL steeper learning curve" \
  "Caching|REST leverages HTTP caching, GraphQL requires custom solutions" \
  "Ecosystem|REST more mature, GraphQL rapidly growing"
```

### Example 2: Market Research

```bash
./research-to-notion.sh "AI Model Providers 2026" \
  "OpenAI|ChatGPT, most mature, ~50% market share" \
  "Anthropic|Claude, strong on reasoning, ~20% market share" \
  "Google|Gemini, integrated with ecosystem, ~15% market share" \
  "Open Source|Llama, Mixtral, cost-effective alternatives" \
  "Recommendations|Claude for reasoning, GPT for scale"
```

### Example 3: Framework Evaluation

```bash
./research-to-notion.sh "Frontend Frameworks" \
  "React|Most popular, large ecosystem, steeper learning curve" \
  "Vue|Smaller but growing, gentle learning curve, rapid development" \
  "Svelte|Compiler-first, smallest bundle, smallest community" \
  "Decision|React for scale, Vue for speed, Svelte for performance"
```

## Format: Category | Details

The script expects findings in `"category|detail"` format:

```
"Performance|Vue 3.5 shows 36% faster DOM manipulation"
 └─ category      └─ detail (what you learned)
```

The detail can be as long as needed - it becomes the page content in Notion.

## Troubleshooting

### "NOTION_API_TOKEN not set"
```bash
export NOTION_API_TOKEN="your_token"
```

### "No parent page found"
Your Notion workspace has no pages. Create a page first:
1. Go to https://www.notion.so
2. Create a new page
3. Try again

### "Database creation failed"
Check the error:
```bash
curl -s -X POST "https://api.notion.com/v1/databases" \
  -H "Authorization: Bearer $NOTION_API_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '...' | jq '.'
```

Common issues:
- Invalid token (check expiration)
- Token not shared with required databases
- Workspace limits exceeded

### Database created but URL not shown
```bash
# Manually construct URL
echo "https://www.notion.so/$DB_ID"
```

## Integration with Claude Code

### Auto-Invoke in Claude Code

When you ask Claude to research and document in Notion:

```
Research [topic] and document in Notion
```

Claude Code will:
1. Run WebSearch/WebFetch
2. Parse findings into categories
3. Call `research-to-notion.sh` with findings
4. Return the database URL

### Manual Invocation

```bash
/research-to-notion "React vs Vue" \
  "Performance|Details" \
  "Ecosystem|Details"
```

## Advanced Usage

### Batch Processing

Research multiple topics:

```bash
topics=("React vs Vue" "GraphQL vs REST" "PostgreSQL vs MongoDB")

for topic in "${topics[@]}"; do
  # Conduct research and build findings array
  ./research-to-notion.sh "$topic" "${findings[@]}"
done
```

### Piping Research Results

```bash
# Research, parse, then document
research_output=$(curl -s "research-api.example.com/topic=React")
findings=$(echo "$research_output" | jq -r '.findings[] | "\(.category)|\(.detail)"')
./research-to-notion.sh "React Research" $findings
```

### With Claude Code Integration

In Claude Code, the skill can accept structured input:

```bash
# From Claude Code
notion-research "React vs Vue" \
  --findings "performance|Vue 36% faster DOM" \
  --findings "ecosystem|React 42.6% adoption" \
  --findings "mobile|React Native available"
```

## Notion API Reference

For manual API calls, see the SKILL.md file:
- Database creation: POST `/v1/databases`
- Add pages: POST `/v1/pages`
- Update pages: PATCH `/v1/pages/{page_id}`
- Search: POST `/v1/search`

## Contributing

Found improvements? Add them:
1. Edit `SKILL.md` for documentation
2. Update `research-to-notion.sh` for implementation
3. Test with pressure scenarios
4. Commit and push

## License

Same as parent skill repository
