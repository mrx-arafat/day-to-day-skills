# Research to Notion - Quick Start Card

## 30-Second Setup

```bash
# 1. Set token (one time)
export NOTION_API_TOKEN="your_notion_api_token_here"

# 2. Make script executable
chmod +x ~/.claude/skills/research-to-notion/research-to-notion.sh

# 3. Use it!
~/.claude/skills/research-to-notion/research-to-notion.sh "Your Topic" \
  "Category|Details about category" \
  "Category|More details"
```

## Basic Usage

```bash
research-to-notion.sh "Topic Name" \
  "Finding 1|Details" \
  "Finding 2|Details" \
  "Finding 3|Details"
```

## Real Example

```bash
research-to-notion.sh "React vs Vue" \
  "Performance|Vue 3.5 is 36% faster at DOM manipulation" \
  "Learning Curve|Vue is gentler, React is steeper" \
  "Ecosystem|React 42.6% adoption, Vue 18.8%" \
  "Mobile|React Native exists, Vue doesn't"
```

**Result:**
```
✅ Complete!
Database URL: https://www.notion.so/33404f91-f50e-81b9-af46-f226efc22dd1
```

## In Claude Code

Just ask:
```
research [topic] and document findings in Notion
```

Claude will handle everything automatically.

## Format Rule

Each finding is: `"Category|Details"`

- **Category:** One-line title (becomes page title)
- **Details:** Full description (becomes page content)
- Use `|` to separate them

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Token not set | `export NOTION_API_TOKEN="..."` |
| No pages found | Create a page in Notion first |
| Command not found | `chmod +x research-to-notion.sh` |
| API error | Check token is still valid |

## File Locations

```
~/.claude/skills/research-to-notion/          # Symlink to Claude Code
/Users/easinarafat/AI/day-to-day-skills/notion/research-to-notion/  # Main location
  ├── SKILL.md                               # Full documentation
  ├── research-to-notion.sh                  # Executable script
  └── README.md                              # Examples
```

## What Gets Created

- ✅ New Notion database titled "[Topic] Research"
- ✅ Properties: Name, Category, Details, Status
- ✅ One page per finding
- ✅ All marked "Complete"
- ✅ Organized and searchable

## Next Steps

1. **Try it:** Run one example above
2. **Customize:** Add your own findings
3. **Share:** The Notion URL works for anyone
4. **Iterate:** Claude Code can improve existing databases

## Pro Tips

- **Batch research:** Create 3+ databases about related topics
- **Comparison:** Use for "Option A vs Option B vs Option C"
- **Market research:** Document competitor analysis
- **Competitive intelligence:** Track changes over time
- **Decision records:** Document why you chose X over Y

---

For full documentation, see `SKILL.md`
