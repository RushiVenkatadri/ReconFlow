#!/bin/bash

# ==========================================
# ReconFlow - Beginner Recon Automation
# Author: Rushi Venkatadri
# ==========================================

# Colors
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m"

# Banner
echo -e "${CYAN}"
echo "======================================="
echo "         ReconFlow Framework"
echo "     Automated Recon Workflow"
echo "======================================="
echo -e "${NC}"

# Check target
if [ -z "$1" ]; then
    echo -e "${RED}Usage: ./reconflow.sh target.com${NC}"
    exit 1
fi

TARGET=$1

# Create folders
mkdir -p results/$TARGET

echo -e "${GREEN}[+] Target:${NC} $TARGET"

# ==========================================
# Subdomain Enumeration
# ==========================================

echo -e "${GREEN}[+] Running Subfinder...${NC}"

subfinder -d $TARGET -silent > results/$TARGET/subdomains.txt

echo -e "${GREEN}[+] Subdomains Saved:${NC} results/$TARGET/subdomains.txt"

# ==========================================
# Live Host Discovery
# ==========================================

echo -e "${GREEN}[+] Checking Live Hosts...${NC}"

cat results/$TARGET/subdomains.txt | httpx -silent > results/$TARGET/live.txt

echo -e "${GREEN}[+] Live Hosts Saved:${NC} results/$TARGET/live.txt"

# ==========================================
# URL Collection
# ==========================================

echo -e "${GREEN}[+] Collecting URLs using waybackurls...${NC}"

cat results/$TARGET/live.txt | waybackurls > results/$TARGET/urls.txt

echo -e "${GREEN}[+] URLs Saved:${NC} results/$TARGET/urls.txt"

# ==========================================
# JavaScript File Discovery
# ==========================================

echo -e "${GREEN}[+] Extracting JavaScript Files...${NC}"

grep "\.js" results/$TARGET/urls.txt > results/$TARGET/js-files.txt

echo -e "${GREEN}[+] JS Files Saved:${NC} results/$TARGET/js-files.txt"

# ==========================================
# Summary
# ==========================================

echo ""
echo -e "${CYAN}=========== Recon Summary ===========${NC}"

echo -e "${GREEN}Subdomains Found:${NC}"
wc -l results/$TARGET/subdomains.txt

echo -e "${GREEN}Live Hosts Found:${NC}"
wc -l results/$TARGET/live.txt

echo -e "${GREEN}URLs Collected:${NC}"
wc -l results/$TARGET/urls.txt

echo -e "${GREEN}JavaScript Files Found:${NC}"
wc -l results/$TARGET/js-files.txt

echo ""
echo -e "${CYAN}Results saved inside:${NC} results/$TARGET/"
echo -e "${GREEN}[✓] ReconFlow Scan Completed.${NC}"
