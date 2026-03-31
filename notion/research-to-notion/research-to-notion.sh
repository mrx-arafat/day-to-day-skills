#!/bin/bash

# Research to Notion - Automated Research Documentation
# Usage: ./research-to-notion.sh "Research Topic" "finding1|finding2|finding3"
#
# Prerequisites:
#   - NOTION_API_TOKEN environment variable set
#   - curl and jq installed
#
# Example:
#   ./research-to-notion.sh "React vs Vue" \
#     "Performance|Vue 3.5 shows 36% better DOM manipulation" \
#     "Learning Curve|Vue has gentler learning curve" \
#     "Ecosystem|React 42.6% adoption vs Vue 18.8%"

set -e

# Configuration
TOKEN="${NOTION_API_TOKEN}"
NOTION_VERSION="2022-06-28"
NOTION_API="https://api.notion.com/v1"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Validate inputs
if [ -z "$TOKEN" ]; then
    echo -e "${RED}Error: NOTION_API_TOKEN not set${NC}"
    exit 1
fi

if [ -z "$1" ]; then
    echo -e "${RED}Error: Research topic required${NC}"
    echo "Usage: $0 'Topic Name' 'category|detail' 'category|detail' ..."
    exit 1
fi

TOPIC="$1"
shift
FINDINGS=("$@")

if [ ${#FINDINGS[@]} -eq 0 ]; then
    echo -e "${RED}Error: At least one finding required${NC}"
    echo "Usage: $0 'Topic Name' 'category|detail' 'category|detail' ..."
    exit 1
fi

echo -e "${BLUE}🔍 Research to Notion Automation${NC}"
echo -e "${BLUE}Topic: $TOPIC${NC}"
echo ""

# Step 1: Find parent page
echo -e "${BLUE}Step 1: Finding parent page...${NC}"
SEARCH_RESPONSE=$(curl -s -X POST "$NOTION_API/search" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $NOTION_VERSION" \
    -d '{"filter": {"property": "object", "value": "page"}, "page_size": 1}')

PARENT_ID=$(echo "$SEARCH_RESPONSE" | jq -r '.results[0].id // empty')

if [ -z "$PARENT_ID" ]; then
    echo -e "${RED}Error: No parent page found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Parent page found: $PARENT_ID${NC}"

# Step 2: Create database
echo -e "${BLUE}Step 2: Creating Notion database...${NC}"

DB_RESPONSE=$(curl -s -X POST "$NOTION_API/databases" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -H "Notion-Version: $NOTION_VERSION" \
    -d @- << EOJSON
{
  "parent": {"type": "page_id", "page_id": "$PARENT_ID"},
  "title": [{"type": "text", "text": {"content": "$TOPIC Research"}}],
  "icon": {"type": "emoji", "emoji": "🔍"},
  "properties": {
    "Name": {"title": {}},
    "Category": {"rich_text": {}},
    "Details": {"rich_text": {}},
    "Status": {"select": {"options": [{"name": "Complete", "color": "green"}]}}
  }
}
EOJSON
)

DB_ID=$(echo "$DB_RESPONSE" | jq -r '.id // empty')

if [ -z "$DB_ID" ]; then
    echo -e "${RED}Error: Database creation failed${NC}"
    echo "$DB_RESPONSE" | jq '.'
    exit 1
fi

echo -e "${GREEN}✓ Database created: $DB_ID${NC}"

# Step 3: Add findings as pages
echo -e "${BLUE}Step 3: Adding research findings...${NC}"

for finding in "${FINDINGS[@]}"; do
    # Parse category and detail from "category|detail" format
    IFS='|' read -r category detail <<< "$finding"

    PAGE_RESPONSE=$(curl -s -X POST "$NOTION_API/pages" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -H "Notion-Version: $NOTION_VERSION" \
        -d @- << EOJSON
{
  "parent": {"type": "database_id", "database_id": "$DB_ID"},
  "properties": {
    "Name": {"title": [{"text": {"content": "$category"}}]},
    "Category": {"rich_text": [{"text": {"content": "$category"}}]},
    "Details": {"rich_text": [{"text": {"content": "$detail"}}]},
    "Status": {"select": {"name": "Complete"}}
  }
}
EOJSON
)

    PAGE_ID=$(echo "$PAGE_RESPONSE" | jq -r '.id // empty')
    if [ -n "$PAGE_ID" ]; then
        echo -e "${GREEN}  ✓ $category${NC}"
    else
        echo -e "${RED}  ✗ Failed to add $category${NC}"
    fi
done

# Step 4: Return database URL
echo ""
echo -e "${GREEN}✅ Complete!${NC}"
echo -e "${BLUE}Database URL:${NC} ${BLUE}https://www.notion.so/${DB_ID}${NC}"
echo ""
echo "Copy the URL above and open in your browser to view your research database."
