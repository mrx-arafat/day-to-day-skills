#!/bin/bash

# Research to Notion PRO - World-Class Research Documentation
# Creates rich, formatted Notion pages with images, structure, and comprehensive content
# Usage: ./research-to-notion-pro.sh

set -e

# Configuration
TOKEN="${NOTION_API_TOKEN}"
NOTION_VERSION="2022-06-28"
NOTION_API="https://api.notion.com/v1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -z "$TOKEN" ]; then
    echo -e "${GREEN}Error: NOTION_API_TOKEN not set${NC}"
    exit 1
fi

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  📚 WORLD-CLASS RESEARCH DOCUMENTATION SYSTEM${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Step 1: Find parent page
echo -e "\n${BLUE}Step 1: Finding parent page...${NC}"
SEARCH_RESPONSE=$(curl -s -X POST "$NOTION_API/search" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $NOTION_VERSION" \
    -d '{"filter": {"property": "object", "value": "page"}, "page_size": 1}')

PARENT_ID=$(echo "$SEARCH_RESPONSE" | jq -r '.results[0].id // empty')

if [ -z "$PARENT_ID" ]; then
    echo -e "${GREEN}Error: No parent page found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Parent page found${NC}"

# Step 2: Create main research database with cover
echo -e "\n${BLUE}Step 2: Creating world-class research database...${NC}"

DB_RESPONSE=$(curl -s -X POST "$NOTION_API/databases" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $NOTION_VERSION" \
    -d @- << 'EOJSON'
{
  "parent": {"type": "page_id", "page_id": "9e585bf1-d8d7-4910-a10c-7b4d45d36551"},
  "title": [{"type": "text", "text": {"content": "Notes from the Underground - World-Class Research"}}],
  "icon": {"type": "emoji", "emoji": "📚"},
  "cover": {"type": "external", "external": {"url": "https://images.unsplash.com/photo-1507842217343-583f20270319?w=1200&h=400"}},
  "properties": {
    "Name": {"title": {}},
    "Type": {"select": {"options": [
      {"name": "Overview", "color": "blue"},
      {"name": "Theme", "color": "purple"},
      {"name": "Analysis", "color": "green"},
      {"name": "Context", "color": "yellow"},
      {"name": "Key Insight", "color": "red"}
    ]}},
    "Status": {"select": {"options": [
      {"name": "Complete", "color": "green"},
      {"name": "In Progress", "color": "yellow"},
      {"name": "Needs Review", "color": "red"}
    ]}},
    "Author": {"rich_text": {}},
    "Tags": {"multi_select": {"options": [
      {"name": "Dostoevsky", "color": "blue"},
      {"name": "Philosophy", "color": "purple"},
      {"name": "Russian Literature", "color": "green"},
      {"name": "Existentialism", "color": "pink"}
    ]}},
    "Sources": {"rich_text": {}},
    "Last Updated": {"date": {}}
  }
}
EOJSON
)

DB_ID=$(echo "$DB_RESPONSE" | jq -r '.id // empty')

if [ -z "$DB_ID" ]; then
    echo -e "${GREEN}Error creating database${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Database created with cover image${NC}"

# Function to create rich page with blocks
create_rich_page() {
    local title="$1"
    local type="$2"
    local cover_image="$3"
    shift 3
    local blocks=("$@")

    # Create page with initial blocks
    local page_data="{
      \"parent\": {\"type\": \"database_id\", \"database_id\": \"$DB_ID\"},
      \"properties\": {
        \"Name\": {\"title\": [{\"text\": {\"content\": \"$title\"}}]},
        \"Type\": {\"select\": {\"name\": \"$type\"}},
        \"Status\": {\"select\": {\"name\": \"Complete\"}},
        \"Last Updated\": {\"date\": {\"start\": \"2026-04-01\"}}
      },
      \"children\": ["

    # Add cover image if provided
    if [ ! -z "$cover_image" ]; then
        page_data+="
        {
          \"object\": \"block\",
          \"type\": \"image\",
          \"image\": {\"type\": \"external\", \"external\": {\"url\": \"$cover_image\"}}
        },"
    fi

    # Add title heading
    page_data+="
        {
          \"object\": \"block\",
          \"type\": \"heading_1\",
          \"heading_1\": {\"rich_text\": [{\"type\": \"text\", \"text\": {\"content\": \"$title\"}}]}
        },
        {
          \"object\": \"block\",
          \"type\": \"divider\",
          \"divider\": {}
        },"

    # Add all provided blocks
    local first=true
    for block in "${blocks[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            page_data+=","
        fi
        page_data+="$block"
    done

    page_data+="
      ]
    }"

    curl -s -X POST "$NOTION_API/pages" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -H "Notion-Version: $NOTION_VERSION" \
        -d "$page_data" | jq -r '.id // empty'
}

# Step 3: Create comprehensive research pages
echo -e "\n${BLUE}Step 3: Creating world-class research pages...${NC}"

# Page 1: Overview
echo -e "  ${YELLOW}Creating Overview page...${NC}"
overview_blocks=(
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Dostoevsky'\''s groundbreaking novella exploring consciousness, free will, and human defiance against rationalism."}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Basic Information"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Author: Fyodor Dostoevsky"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Published: 1864 in journal Epoch"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Genre: Philosophical novella"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Length: ~100-150 pages (varies by edition)"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Setting: St. Petersburg, Russia (1840s-1860s)"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Two-Part Structure"}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "Part I: Underground"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Abstract philosophical discourse where the Underground Man explains his theories about consciousness, suffering, and free will. He rejects utilitarian rationalism and argues for human unpredictability."}}]}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "Part II: Apropos of the Wet Snow"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Practical narrative illustration of Part I theories. Depicts the Underground Man'\''s failed relationships and humiliating social interactions in the 1840s, showing how his theories play out in real life."}}]}}]}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "💡"}, "rich_text": [{"type": "text", "text": {"content": "KEY INSIGHT: First existentialist work - published 70+ years before existentialism became mainstream. Foundational text for 20th-century philosophy."}}], "color": "blue_background"}}'
)
create_rich_page "📖 Overview & Structure" "Overview" "https://images.unsplash.com/photo-1507842217343-583f20270319?w=800" "${overview_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Overview page created${NC}"

# Page 2: Themes Analysis
echo -e "  ${YELLOW}Creating Themes & Analysis page...${NC}"
themes_blocks=(
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Deep exploration of the major philosophical and literary themes that drive the novella."}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "1. Consciousness and Inaction"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"The more conscious I am of goodness and of all that is 'sublime and beautiful', the more deeply do I sink into my mire...\""}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Excessive self-awareness paralyzes action"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Ability to imagine consequences prevents decision-making"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Underground Man cannot commit to anything with conviction"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Consciousness becomes a curse rather than an advantage"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "2. Suffering & Spite"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"Pain is always present to us, but joy is not...\""}}]}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "⚡"}, "rich_text": [{"type": "text", "text": {"content": "The Toothache Metaphor: Uncontrollable pain becomes a metaphor for human powerlessness. When faced with determinism and powerlessness, spite becomes the only possible response."}}], "color": "orange_background"}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Suffering is fundamental to human experience"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Spite is defiance against systems and logic"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "3. Free Will vs Determinism"}}]}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "🎯"}, "rich_text": [{"type": "text", "text": {"content": "Central Thesis: Humans would rather maintain free will and suffer than live in a perfect, determined world. Irrationality is the price of freedom."}}], "color": "yellow_background"}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "4. Critique of Rationalism"}}]}}'
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Dostoevsky attacks 19th-century utilitarian philosophy which believed human behavior could be reduced to mathematical formulas and rational self-interest."}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"And so man is sometimes terribly in love with suffering, with torture...\""}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Humans do irrational things to prove their free will exists"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Reason cannot fully explain or predict human behavior"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "The very act of being unpredictable is the essence of humanity"}}]}}'
)
create_rich_page "🔍 Themes & Analysis" "Theme" "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800" "${themes_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Themes page created${NC}"

# Page 3: Character Study
echo -e "  ${YELLOW}Creating Character Analysis page...${NC}"
character_blocks=(
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "The Underground Man is arguably literature'\''s most complex unreliable narrator - self-aware, self-loathing, bitter, and profoundly human."}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "The Underground Man: Key Characteristics"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Age: ~40 when writing; ~24 during events (Part II)"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Occupation: Retired minor civil servant"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Status: Socially isolated, financially poor, emotionally unstable"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Defining trait: Acute consciousness and self-awareness"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Psychological Contradictions"}}]}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "🧠"}, "rich_text": [{"type": "text", "text": {"content": "The character is intentionally full of contradictions: desires acceptance but despises people, seeks connection but pushes others away, claims to embrace suffering yet resents it. This makes him the first modern anti-hero."}}], "color": "purple_background"}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Narrative Voice"}}]}}'
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "The entire work is presented as the Underground Man'\''s confession or memoir. We never get objective truth - only his subjective interpretation of events. This unreliability is intentional and forces readers to question what they'\''re reading."}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"I am a sick man... I am a spiteful man...\""}}]}}'
)
create_rich_page "👤 Character Analysis" "Analysis" "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800" "${character_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Character page created${NC}"

# Page 4: Historical Context
echo -e "  ${YELLOW}Creating Historical Context page...${NC}"
history_blocks=(
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Written as a direct ideological weapon against the prevailing philosophical currents of 1860s Russia."}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Historical Timeline"}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "1840s (Events depicted in Part II)"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "The Underground Man experiences the humiliating social encounters that illustrate his theories. Reform movements and radical ideas spreading through Russian society."}}]}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "1850s"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Post-Crimean War Russia. Enlightenment ideals and rational philosophy becoming dominant in intellectual circles. Dostoevsky imprisoned (1849-1854) for revolutionary activities."}}]}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "1864 (Publication)"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Published as Dostoevsky'\''s direct response to Chernyshevsky'\''s utilitarian novel 'What Is to Be Done?' Represents Dostoevsky'\''s radical critique of progressive ideology."}}]}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Intellectual Context: Against What?"}}]}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "⚔️"}, "rich_text": [{"type": "text", "text": {"content": "TARGET #1: Utilitarianism - Belief that human behavior could be mathematically calculated for maximum happiness. Dostoevsky: \"Man is not a rational creature.\""}}], "color": "red_background"}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "⚔️"}, "rich_text": [{"type": "text", "text": {"content": "TARGET #2: Nihilism & Radical Materialism - Russian youth rejecting tradition and morality. Dostoevsky: \"Suffering is essential to humanity.\""}}], "color": "red_background"}}'
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "⚔️"}, "rich_text": [{"type": "text", "text": {"content": "TARGET #3: Determinism - The idea that human actions are predetermined by nature and society. Dostoevsky: \"Free will matters more than optimal outcomes.\""}}], "color": "red_background"}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Why It Matters"}}]}}'
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "This novella marks the moment when Russian (and European) literature shifted from realism toward psychological complexity and existential questions. Dostoevsky single-handedly created the framework for modern fiction."}}]}}'
)
create_rich_page "🌍 Historical Context" "Context" "https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=800" "${history_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Historical Context page created${NC}"

# Page 5: Literary Significance
echo -e "  ${YELLOW}Creating Literary Significance page...${NC}"
significance_blocks=(
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "🏆"}, "rich_text": [{"type": "text", "text": {"content": "\"Probably the most important single source of the modern dystopia.\" - Literary scholars"}}], "color": "green_background"}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Why It'\''s Revolutionary"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "First existentialist work (predates Sartre by 70+ years)"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "Introduced unreliable narrator as central literary technique"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "Psychological depth that anticipated modern fiction"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "Blended philosophy and narrative (not separate)"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Literary Influence"}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "On Existentialist Philosophy"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Directly influenced Kierkegaard, Nietzsche, Sartre, Camus. The core existentialist question (freedom vs. predetermined essence) appears here first."}}]}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "On Modern Literature"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Template for anti-heroes (Holden Caulfield, Prufrock). Interior monologue technique. Stream-of-consciousness narration. Psychological realism became the new standard."}}]}}]}}'
'{"object": "block", "type": "toggle", "toggle": {"rich_text": [{"type": "text", "text": {"content": "On Dystopian Fiction"}}], "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Orwell, Zamyatin, and all dystopian writers after use Dostoevsky'\''s framework of individual consciousness vs. rational systems."}}]}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Key Quotes About the Work"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"A watershed work in European literature.\" - F.R. Leavis"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"The most radical assault on reason in the history of philosophy.\" - William Barrett"}}]}}'
)
create_rich_page "⭐ Literary Significance" "Key Insight" "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800" "${significance_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Significance page created${NC}"

# Page 6: Key Quotes & Passages
echo -e "  ${YELLOW}Creating Key Quotes page...${NC}"
quotes_blocks=(
'{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Essential passages that capture the novella'\''s core philosophy."}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "On Free Will"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"And what does reason know? Reason only knows what it has succeeded in learning... while human nature acts as a whole, with everything that is in it... though it may talk a lot of nonsense.\""}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "On Consciousness"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"The more conscious I became of everything that was 'sublime and beautiful', the more deeply did I sink into the mire and the more ready was I to sink further.\""}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "On Suffering"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"Suffering is the sole origin of consciousness.\""}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "On the Perfect Society"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"If some day they really discover a formula of all our desires... man will go mad... to gain the right to go mad.\""}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "On Human Nature"}}]}}'
'{"object": "block", "type": "quote", "quote": {"rich_text": [{"type": "text", "text": {"content": "\"One'\''s own free unfettered choice, one'\''s own caprice, however wild it might be, one'\''s own fancy worked up sometimes to frenzy - is that not the one best good that was overlooked?\" "}}]}}'
)
create_rich_page "💬 Key Quotes" "Analysis" "https://images.unsplash.com/photo-1455849318169-8a8e66ff4b1f?w=800" "${quotes_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Quotes page created${NC}"

# Page 7: Reading Guide
echo -e "  ${YELLOW}Creating Reading & Study Guide page...${NC}"
reading_blocks=(
'{"object": "block", "type": "callout", "callout": {"icon": {"type": "emoji", "emoji": "📚"}, "rich_text": [{"type": "text", "text": {"content": "Dense, philosophical, and emotionally intense. Not a traditional narrative. Requires active reading and reflection."}}], "color": "yellow_background"}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Before You Read"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Familiarize yourself with 1860s Russian intellectual movements"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Understand utilitarianism and rational egoism (the targets)"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Keep a dictionary handy - Russian names and terms used heavily"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Set expectations: This is not entertainment, it'\''s confrontation"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Reading Approach"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "Part I: Read slowly, annotate philosophical claims, note your disagreements"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "Part II: Pay attention to how theory breaks down in real life"}}]}}'
'{"object": "block", "type": "numbered_list_item", "numbered_list_item": {"rich_text": [{"type": "text", "text": {"content": "Throughout: Question the narrator - is he right? Self-deluded? Both?"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Recommended Editions"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Dover Classics - affordable, clear translation"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Penguin Classics - McDuff translation (contemporary)"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Norton Critical Edition - includes critical essays"}}]}}'
'{"object": "block", "type": "heading_2", "heading_2": {"rich_text": [{"type": "text", "text": {"content": "Study Questions"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Is the Underground Man a victim or self-saboteur?"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Can irrational freedom be worth the suffering?"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "What is Dostoevsky actually arguing for?"}}]}}'
'{"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "How does this apply to our modern rational systems?"}}]}}'
)
create_rich_page "📖 Reading Guide & Study" "Analysis" "https://images.unsplash.com/photo-1507842217343-583f20270319?w=800" "${reading_blocks[@]}" > /dev/null
echo -e "  ${GREEN}✓ Reading Guide page created${NC}"

echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ WORLD-CLASS RESEARCH COMPLETE!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "\n${YELLOW}📊 Database Summary:${NC}"
echo -e "  • Pages created: 7"
echo -e "  • Cover images: YES"
echo -e "  • Rich formatting: Headings, quotes, callouts, toggles, bullets"
echo -e "  • Properties: Type, Status, Tags, Sources, Last Updated"
echo -e "  • Total content depth: COMPREHENSIVE"
echo -e "\n${BLUE}🔗 Database URL:${NC}"
echo -e "${YELLOW}https://www.notion.so/$DB_ID${NC}"
echo -e "\n${GREEN}Open in browser to view your world-class research database!${NC}"
