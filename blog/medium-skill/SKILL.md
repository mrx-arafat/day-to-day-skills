---
name: medium-skill
description: >
  Generate pixel-perfect Medium-styled technical blog articles as standalone HTML files.
  Use this skill whenever the user asks for a blog post, Medium article, technical write-up,
  research article, deep-dive, or any long-form content meant for publishing. Trigger on
  mentions of "blog", "article", "Medium", "write-up", "post", "publish", "deep-dive",
  "technical breakdown", or when the user provides raw research/notes and wants them turned
  into a polished publishable piece. Also trigger when the user says "write about",
  "create a post about", or references their portfolio/website in the context of content creation.
---

# Medium-Style Article Generator

You produce publication-ready blog articles as **standalone HTML files** that replicate Medium's exact visual design. The output should look indistinguishable from a real Medium article when opened in a browser. This covers all topics — security research, DevOps deep-dives, cloud infrastructure, daily reflections, tutorials, opinion pieces, and anything else meant for publishing.

## Author Information

Every article uses this author identity:

- **Name:** Easin Arafat
- **Initials:** EA
- **Portfolio:** https://profile.arafatops.com
- **Avatar:** Gradient circle (teal-to-indigo: `linear-gradient(135deg, #0d9488, #6366f1)`) with white "EA" initials

This information appears in three places: the top navigation bar, the author block below the title, and the "Written by" footer at the bottom of the article.

## Output Format

Always produce a **single self-contained `.html` file** with all CSS inlined in a `<style>` block. No external stylesheets other than Google Fonts. Save the file to the outputs directory.

## How to Build the Article

### Step 1: Read the HTML Template

Read the template file at:
```
<skill-directory>/assets/medium-template.html
```

This template contains the complete CSS, structural HTML skeleton, and placeholder markers. It is the single source of truth for the visual design — use it exactly as provided. Do not improvise the CSS or layout from memory.

### Step 2: Populate the Template

Replace the placeholder markers in the template with actual content:

| Placeholder | Replace with |
|---|---|
| `{{ARTICLE_TITLE}}` | The article's H1 title |
| `{{ARTICLE_SUBTITLE}}` | One-sentence italic subtitle summarizing the piece |
| `{{READ_TIME}}` | Estimated reading time (calculate ~250 words/minute) |
| `{{PUBLISH_DATE}}` | Current date formatted as "Mon DD, YYYY" (e.g., "Mar 31, 2026") |
| `{{ARTICLE_BODY}}` | The full HTML body content (see content rules below) |
| `{{ARTICLE_TAGS}}` | Tag pills — one `<a href="#" class="tag">TagName</a>` per topic |

### Step 3: Write the Article Body Content

The body goes inside the `<article>` element between the top clap bar and the bottom tags. Follow these content rules:

#### Structure & Rhythm

- Open with 2-3 paragraphs that hook the reader — set the stakes, establish the "what" and "why it matters" before diving into detail.
- Use `<h2>` for major sections and `<h3>` for subsections.
- Separate major sections with the Medium three-dot divider:
  ```html
  <div class="section-break">&middot;&middot;&middot;</div>
  ```
- Write in flowing prose paragraphs. Use bullet lists (`<ul>`) and numbered lists (`<ol>`) only when listing distinct items (steps, tools, comparisons). Body explanations should be paragraphs, not bullet cascades.

#### Adapting to Topic Type

The template works for any topic. Adapt the content style to match:

- **Security research / incident analysis** — Lead with timeline and impact. Include IOC tables, detection commands, YARA/Snort rules, and remediation steps. Use `callout-danger` for critical warnings.
- **Technical tutorials / how-to guides** — Lead with what the reader will build. Use numbered steps, code blocks at each stage, and expected output after each command.
- **DevOps / infrastructure deep-dives** — Lead with the problem being solved. Include architecture decisions, config snippets, and performance comparisons via tables.
- **Opinion pieces / reflections** — Lead with a provocative observation or personal anecdote. Fewer code blocks, more narrative flow. Use callout boxes for key arguments.
- **Tool comparisons / reviews** — Lead with the problem space. Use tables for feature matrices. Include install/setup code for each tool discussed.
- **Daily writing / personal posts** — Lead with a story. Lighter formatting, fewer technical elements. Still use section breaks for pacing.

#### Code Blocks

For technical articles, code blocks are essential. Use the two-part pattern — a language label div on top, then the `<pre><code>` block:

```html
<div class="code-label">Bash</div>
<pre><code>your code here</code></pre>
```

Apply syntax highlighting with these span classes:
- `.cm` — comments (green: `#6a9955`)
- `.kw` — keywords/rule names (purple: `#c586c0`)
- `.str` — strings (orange: `#ce9178`)
- `.fn` — function/command names (yellow: `#dcdcaa`)
- `.num` — numbers (light green: `#b5cea8`)
- `.flag` — flags/parameters (blue: `#9cdcfe`)

Example:
```html
<span class="fn">curl</span> <span class="flag">-s</span> <span class="str">"https://example.com"</span> <span class="cm"># fetch the page</span>
```

Highlight thoughtfully — commands, flags, strings, and comments are the priorities. Don't highlight every single token; readability matters more than completeness.

For non-technical articles, code blocks may be minimal or absent — that's fine. The template handles both gracefully.

#### Inline Code

Use `<code>` for inline technical terms: package names, file paths, CLI commands, config keys, version numbers, function names. For non-technical articles, use it sparingly for tool names or specific terms that benefit from monospace distinction.

#### Tables

Use HTML `<table>` for structured data like comparison matrices, parameter references, timelines, or feature lists. The template CSS handles styling — just use `<thead>` with `<th>` for headers and `<tbody>` with `<td>` for data.

#### Callout Boxes

For critical warnings, key takeaways, or highlighted quotes, use:
```html
<div class="callout">Normal callout (green left border) — use for key takeaways and tips</div>
<div class="callout callout-danger">Danger callout (red left border) — use for warnings and critical info</div>
```

#### Typography Details

- Use HTML entities for special characters: `&mdash;` for em-dashes, `&rsquo;` for apostrophes, `&rarr;` for arrows, `&middot;` for middle dots.
- Bold key terms with `<strong>` on first introduction or for emphasis in lists.
- Use `<em>` sparingly for genuine emphasis, not for every technical term.

### Step 4: Estimate Reading Time

Count the total words in the article body (excluding code blocks) and divide by 250. Round to the nearest whole number. Format as "N min read".

### Step 5: Generate Relevant Tags

Add 6-8 topic tags as pill-shaped links at the bottom. Choose tags that a Medium reader would actually search for. Mix broad tags (e.g., "Security", "JavaScript", "Productivity") with specific ones (e.g., "Supply Chain", "Kubernetes", "Remote Work").

## Writing Style Guide

The voice should be:

- **Authoritative but accessible** — You're a practitioner writing for peers, not an academic writing a paper. Explain the "why" behind decisions and opinions.
- **Narrative-driven** — Every article should tell a story, even deeply technical ones. What happened? Why does it matter? What should the reader do or think differently?
- **Concrete over abstract** — For technical pieces, show real commands, real file paths, real outputs. For opinion pieces, use specific examples and anecdotes rather than vague generalities.
- **Paced with breathing room** — Alternate between dense sections and higher-level analysis. After a block of code or a complex argument, pause and explain why it matters before moving forward.

For long articles (10+ min read), close with a "Lessons and Takeaways", "Final Thoughts", or equivalent section that distills the practical implications. End with a short italic call-to-action encouraging sharing or discussion.

## Handling Different Input Types

The user may provide content in various forms:

- **Raw notes/report** — Restructure into narrative form. Don't just reformat; rewrite for a reading audience.
- **A topic prompt** — Research (using web search if available) and write from scratch.
- **An existing article to restyle** — Preserve the content but apply this template and writing style.
- **Bullet points or outline** — Expand each point into full prose sections.
- **A conversation or thread** — Distill the key insights into a cohesive article.

In all cases, the output is a complete, publication-ready HTML file.
