#!/bin/bash

# Auto-commit script for internship attestation project
# This script will commit each changed file individually with descriptive commit messages

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting auto-commit process...${NC}"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Not in a git repository!${NC}"
    exit 1
fi

# Array of files with their commit messages
declare -A file_commits=(
    ["css/lmt.css"]="feat: enhance certificate styling with modern animations and responsive design

- Add comprehensive CSS variables for consistent theming
- Implement smooth animations (fadeInUp, slideInScale, shimmer)
- Enhance typography with better font hierarchy
- Add responsive design breakpoints for mobile/tablet
- Improve print styles for better PDF output
- Add hover effects and visual feedback
- Modernize layout with CSS Grid and Flexbox"

    ["css/main.css"]="feat: redesign landing page with enhanced UI/UX and animations

- Implement modern gradient backgrounds with floating particles
- Add comprehensive animation system (fadeInUp, slideInLeft, etc.)
- Enhance form styling with focus states and validation feedback
- Improve button designs with hover effects and loading states
- Add responsive design for all screen sizes
- Implement modern color scheme with CSS custom properties
- Enhance footer with gradient styling and decorative elements"

    ["index.html"]="feat: enhance registration form with modern UX and validation

- Add enhanced form validation with visual feedback
- Implement loading states and smooth animations
- Improve error handling with custom alert system
- Add modern footer with enhanced styling
- Enhance accessibility with proper meta tags
- Implement Google Fonts for better typography
- Add shake animation for validation errors
- Improve placeholder text formatting"

    ["LSS.html"]="feat: create stellar certificate design with professional PDF optimization

- Implement complete certificate redesign with decorative borders
- Add corner decorations and gradient styling
- Create professional layout with proper spacing for PDF
- Implement responsive grid system for student details
- Add print-optimized CSS with exact color reproduction
- Create horizontal footer layout for better space utilization
- Add side-by-side logo positioning
- Implement notification hiding for clean print output
- Add professional typography with Playfair Display and Inter fonts"

    ["LSS_backup.html"]="feat: create backup certificate version with enhanced error handling

- Implement fallback certificate design using enhanced lmt.css
- Add robust error handling with graceful degradation
- Create user-friendly error messages with redirect functionality
- Implement progressive data population with fallback values
- Add print preparation with animation cleanup
- Enhance debugging with comprehensive console logging
- Add smooth page load animations"

    ["LSS_new.html"]="feat: create modern certificate template with major spacing optimizations

- Implement professional certificate design with decorative elements
- Add major header and footer positioning adjustments
- Optimize content padding for better visual balance
- Create modern grid-based layout for student information
- Add enhanced typography with Google Fonts integration
- Implement comprehensive print styles for PDF optimization
- Add responsive design for multiple screen sizes
- Create smooth animation system for data population"
)

# Function to commit a single file
commit_file() {
    local file="$1"
    local commit_msg="$2"
    
    echo -e "${YELLOW}📝 Processing: ${file}${NC}"
    
    # Check if file exists and has changes
    if [[ -f "$file" ]]; then
        # Check if file has changes
        if git diff --quiet "$file" && git diff --cached --quiet "$file"; then
            echo -e "${YELLOW}⚠️  No changes detected in ${file}, skipping...${NC}"
            return
        fi
        
        # Add the file
        git add "$file"
        
        # Commit the file
        if git commit -m "$commit_msg"; then
            echo -e "${GREEN}✅ Successfully committed: ${file}${NC}"
        else
            echo -e "${RED}❌ Failed to commit: ${file}${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ File not found: ${file}${NC}"
        return 1
    fi
}

# Counter for successful commits
successful_commits=0
total_files=${#file_commits[@]}

echo -e "${BLUE}📋 Found ${total_files} files to process${NC}"

# Process each file
for file in "${!file_commits[@]}"; do
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    if commit_file "$file" "${file_commits[$file]}"; then
        ((successful_commits++))
    fi
done

# Summary
echo -e "\n${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 Commit Summary:${NC}"
echo -e "${GREEN}✅ Successfully committed: ${successful_commits}/${total_files} files${NC}"

if [[ $successful_commits -eq $total_files ]]; then
    echo -e "${GREEN}🚀 All files committed successfully!${NC}"
    
    # Ask if user wants to push
    echo -e "\n${YELLOW}🔄 Would you like to push to remote repository? (y/n)${NC}"
    read -r push_choice
    
    if [[ $push_choice =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}📤 Pushing to remote repository...${NC}"
        if git push; then
            echo -e "${GREEN}✅ Successfully pushed to remote repository!${NC}"
        else
            echo -e "${RED}❌ Failed to push to remote repository${NC}"
        fi
    else
        echo -e "${YELLOW}ℹ️  Commits are ready to push when you're ready${NC}"
    fi
else
    echo -e "${RED}⚠️  Some files could not be committed. Please check the errors above.${NC}"
fi

echo -e "\n${BLUE}🏁 Auto-commit process completed!${NC}"
