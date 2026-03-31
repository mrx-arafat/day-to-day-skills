<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Skills-blueviolet?style=for-the-badge&logo=anthropic&logoColor=white" alt="Claude Code Skills" />
  <img src="https://img.shields.io/badge/Author-Easin_Arafat-0d9488?style=for-the-badge" alt="Author" />
  <img src="https://img.shields.io/github/license/mrx-arafat/day-to-day-skills?style=for-the-badge" alt="License" />
</p>

<h1 align="center">🧠 Day-to-Day Skills</h1>

<p align="center">
  <strong>A curated collection of custom AI skills for <a href="https://docs.anthropic.com/en/docs/claude-code/overview">Claude Code</a></strong><br/>
  Supercharge your AI-assisted workflow with production-ready, reusable skill modules.
</p>

<p align="center">
  <a href="#-skills-included">Skills</a> •
  <a href="#-how-skills-work">How It Works</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-contributing">Contributing</a>
</p>

---

## 🤔 What Is This?

**Claude Code Skills** are structured instruction sets that extend what Claude Code can do. Instead of repeating complex prompts every time, you define a skill once — and Claude automatically picks it up whenever the context matches.

This repository is my personal toolkit of skills I use daily. Each skill is a self-contained module with instructions (`SKILL.md`) and any supporting assets (templates, scripts, etc.) that Claude reads and follows to produce consistent, high-quality output.

> Think of skills as **reusable prompt blueprints** — they turn vague requests into pixel-perfect, repeatable results.

---

## 📦 Skills Included

### 1. `medium-skill` — Medium-Style Article Generator

> **Path:** `blog/medium-skill/`

Generates **pixel-perfect, publication-ready blog articles** as standalone HTML files that replicate Medium's exact visual design. Give it a topic, raw notes, or an outline — and it produces a complete, self-contained `.html` file you can open in any browser.

**Triggers on:** `"blog"`, `"article"`, `"Medium"`, `"write-up"`, `"post"`, `"publish"`, `"deep-dive"`, `"technical breakdown"`, `"write about"`, `"create a post about"`

**What it covers:**

| Feature | Details |
|---|---|
| **Template** | Full HTML/CSS skeleton replicating Medium's typography, layout, and spacing |
| **Syntax Highlighting** | Color-coded code blocks with language labels (Bash, Python, YAML, etc.) |
| **Content Styles** | Callout boxes, section dividers, tables, inline code, and rich typography |
| **Topic Adaptability** | Security research, DevOps, tutorials, opinion pieces, tool reviews, personal posts |
| **Author Branding** | Auto-populated author identity with avatar, name, and portfolio link |
| **Reading Time** | Auto-calculated based on word count (~250 words/min) |

**Assets:**
- `assets/medium-template.html` — The complete HTML/CSS template with placeholder markers

---

### 2. `security-research-blog` — Security Research Blog Generator

> **Path:** `blog/security-research-blog/`

A specialized variant focused on **security research write-ups**. Tailored for incident analyses, vulnerability disclosures, threat intelligence reports, and security tooling deep-dives — all rendered as polished Medium-style HTML articles.

**Triggers on:** Same as `medium-skill` — optimized for security-focused content

**What it covers:**

| Feature | Details |
|---|---|
| **Security Focus** | IOC tables, detection commands, YARA/Snort rules, remediation steps |
| **Danger Callouts** | Red-bordered callout boxes for critical security warnings |
| **Structured Data** | Tables for IOC summaries, comparison matrices, attack timelines |
| **Narrative Style** | Story-driven — "What happened? Why does it matter? What should you do?" |

**Assets:**
- `assets/medium-template.html` — Same base template, security-context ready

---

## ⚙️ How Skills Work

Claude Code's skill system follows a simple convention:

```
skill-directory/
├── SKILL.md          # Instructions Claude reads and follows
└── assets/           # Supporting files (templates, scripts, images)
    └── template.html
```

1. **`SKILL.md`** — The brain of the skill. Contains YAML frontmatter (`name`, `description`) and detailed markdown instructions. The `description` field tells Claude *when* to activate the skill based on keyword triggers.

2. **`assets/`** — Any supporting files the skill references. Claude reads these at execution time to produce consistent output.

When you ask Claude Code something like *"write a blog post about Kubernetes security"*, it pattern-matches against skill descriptions and automatically loads the relevant `SKILL.md` — no manual intervention needed.

---

## 🚀 Installation

### Option 1: Clone into your project

```bash
# Clone into your project's skill directory
git clone https://github.com/mrx-arafat/day-to-day-skills.git .skills/
```

### Option 2: Add as a Git submodule

```bash
# Add as a submodule for easy updates
git submodule add https://github.com/mrx-arafat/day-to-day-skills.git .skills/
```

### Option 3: Cherry-pick individual skills

```bash
# Download just the skill you need
mkdir -p .skills/blog/medium-skill
curl -L https://raw.githubusercontent.com/mrx-arafat/day-to-day-skills/main/blog/medium-skill/SKILL.md \
  -o .skills/blog/medium-skill/SKILL.md

# Don't forget the assets
mkdir -p .skills/blog/medium-skill/assets
curl -L https://raw.githubusercontent.com/mrx-arafat/day-to-day-skills/main/blog/medium-skill/assets/medium-template.html \
  -o .skills/blog/medium-skill/assets/medium-template.html
```

> **Note:** Make sure the skills directory is accessible to Claude Code in your workspace. Claude automatically discovers `SKILL.md` files in your project tree.

---

## 💡 Usage

Once installed, just talk to Claude Code naturally. The skills activate automatically based on context.

### Example Prompts

```
📝 "Write a blog post about setting up GitOps with ArgoCD"
→ Activates medium-skill, produces a complete Medium-styled HTML article

🔒 "Write a security research article about the latest npm supply chain attack"
→ Activates security-research-blog, includes IOC tables and detection rules

📋 "Turn these raw notes into a polished article" + [paste notes]
→ Restructures your notes into narrative-driven, publication-ready HTML

🎨 "Create a deep-dive on Kubernetes RBAC best practices"
→ Generates a full technical tutorial with code blocks and callout boxes
```

### Output

Each skill produces a **single, self-contained `.html` file** with:
- All CSS inlined (no external dependencies except Google Fonts)
- Responsive design that looks great on any screen
- Proper syntax highlighting for code blocks
- Medium's signature typography and spacing

Just open the generated `.html` file in your browser — it's ready to publish.

---

## 📁 Repository Structure

```
day-to-day-skills/
├── README.md
└── blog/
    ├── medium-skill/
    │   ├── SKILL.md                    # General-purpose article generator
    │   └── assets/
    │       └── medium-template.html    # Medium-replica HTML template
    └── security-research-blog/
        ├── SKILL.md                    # Security-focused article generator
        └── assets/
            └── medium-template.html    # Medium-replica HTML template
```

---

## 🛠️ Creating Your Own Skills

Want to add a new skill? Follow this structure:

```markdown
---
name: your-skill-name
description: >
  A clear description of what the skill does and when it should activate.
  Include trigger keywords that Claude should match against.
---

# Skill Title

Detailed instructions for Claude to follow...
```

**Tips for writing great skills:**
- 🎯 **Be specific** — The more detailed your instructions, the more consistent the output
- 🔑 **Include trigger keywords** — List the words/phrases that should activate this skill in the `description`
- 📄 **Use templates** — Put reusable templates in `assets/` and reference them in your instructions
- ✅ **Add examples** — Show Claude exactly what the output should look like
- 🔄 **Iterate** — Test the skill, refine the instructions, repeat

---

## 🤝 Contributing

Contributions are welcome! If you have a useful skill you'd like to share:

1. **Fork** this repository
2. **Create** your skill directory with `SKILL.md` and any assets
3. **Test** it with Claude Code to make sure it works reliably
4. **Submit** a pull request with a description of what your skill does

---

## 👤 Author

**Easin Arafat**

- 🌐 Portfolio: [profile.arafatops.com](https://profile.arafatops.com)
- 🐙 GitHub: [@mrx-arafat](https://github.com/mrx-arafat)

---

<p align="center">
  <sub>Built with 🧠 for smarter AI-assisted workflows</sub>
</p>
