# Security Guidelines

## ⚠️ NEVER Commit Your Notion API Token

This is a **critical security issue**. Your Notion API token grants full access to your Notion workspace.

### What NOT to Do

❌ **DO NOT** hardcode your token in any files  
❌ **DO NOT** commit `.env` files to git  
❌ **DO NOT** share your token in issues, PRs, or discussions  
❌ **DO NOT** paste your actual token in code examples  

### What TO Do

✅ **DO** use environment variables: `$NOTION_API_TOKEN`  
✅ **DO** set token in your shell profile: `~/.zshrc`, `~/.bashrc`  
✅ **DO** use `.env.example` as a template  
✅ **DO** add `.env` to `.gitignore` (already done)  
✅ **DO** regenerate token if accidentally exposed  

---

## Setup for Safe Use

### 1. Set Environment Variable (Recommended for Daily Use)

Add to your shell profile (~/.zshrc or ~/.bashrc):

```bash
export NOTION_API_TOKEN="ntn_your_actual_token_here"
```

Then reload:
```bash
source ~/.zshrc
```

### 2. Create Local .env File (Optional, for Project-Specific Use)

```bash
cp .env.example .env
# Edit .env and add your actual token
# This file is in .gitignore - safe to commit repository
```

Then in your script:
```bash
if [ -f .env ]; then
  source .env
fi
TOKEN="$NOTION_API_TOKEN"
```

---

## If Your Token is Exposed

**Immediately regenerate it:**

1. Go to https://www.notion.so/my-integrations
2. Find your integration
3. Click "Regenerate" on the token
4. Update your environment variable with the new token

**Old token is now invalid and cannot be used.**

---

## Files That Reference Token Handling

- **SKILL.md** - Shows ✓ safe usage, ✗ unsafe usage
- **research-to-notion.sh** - Uses `$NOTION_API_TOKEN` environment variable
- **.gitignore** - Prevents accidental commits
- **.env.example** - Template (safe to commit, no actual token)

---

## For GitHub/Public Repositories

**Before pushing:**

```bash
# Verify no tokens are in files
grep -r "ntn_" . --exclude-dir=.git

# Verify .gitignore exists and includes .env files
cat .gitignore | grep "^\.env"
```

If you accidentally commit a token:

```bash
# Remove from git history
git filter-branch --tree-filter 'rm -f .env' HEAD

# Force push (dangerous - use with caution)
git push --force-with-lease origin main
```

**Better:** Regenerate the token immediately and use a new one.

---

## Checking This Skill is Secure

```bash
# Should show NO actual tokens (only placeholders)
grep -E "ntn_[a-zA-Z0-9]{20,}" /Users/easinarafat/AI/day-to-day-skills/notion/research-to-notion/*

# Should show environment variable usage
grep "NOTION_API_TOKEN" /Users/easinarafat/AI/day-to-day-skills/notion/research-to-notion/*.sh
```

---

## Safe Example Commands

✅ **Safe** - Uses environment variable:
```bash
export NOTION_API_TOKEN="ntn_actual_token_here"
./research-to-notion.sh "Topic" "Category|Details"
```

❌ **Unsafe** - Token in command:
```bash
NOTION_API_TOKEN="ntn_actual_token_here" ./research-to-notion.sh "Topic" "Category|Details"
```

---

## Questions?

- Token not working? Check expiration at https://www.notion.so/my-integrations
- Need a new token? Regenerate from integrations page
- Token leaked? Regenerate immediately (old one is invalidated)

---

**Remember:** Your Notion API token = full access to your workspace. Treat it like a password.
