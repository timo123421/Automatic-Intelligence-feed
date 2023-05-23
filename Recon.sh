#!/bin/bash

echo "___________.__   .__   __              __   .__                             __                   ___.                    .__          __           .__   
\_   _____/|  |  |__|_/  |_   ____   _/  |_ |  |__ _______   ____  _____  _/  |_    ____  ___.__.\_ |__    ____ _______  |__|  ____ _/  |_   ____  |  |  
 |    __)_ |  |  |  |\   __\_/ __ \  \   __\|  |  \\_  __ \_/ __ \ \__  \ \   __\ _/ ___\<   |  | | __ \ _/ __ \\_  __ \ |  | /    \\   __\_/ __ \ |  |  
 |        \|  |__|  | |  |  \  ___/   |  |  |   Y  \|  | \/\  ___/  / __ \_|  |   \  \___ \___  | | \_\ \\  ___/ |  | \/ |  ||   |  \|  |  \  ___/ |  |__
/_______  /|____/|__| |__|   \___  >  |__|  |___|  /|__|    \___  >(____  /|__|    \___  >/ ____| |___  / \___  >|__|    |__||___|  /|__|   \___  >|____/
        \/                       \/              \/             \/      \/             \/ \/          \/      \/                  \/            \/"

echo "------------------------"
echo ""
echo ""
echo ""

urls=(
    'https://www.cisa.gov/uscert/ncas/alerts.xml'
    'https://feeds.feedburner.com/TheHackersNews'
    'https://www.ncsc.gov.uk/api/1/services/v1/all-rss-feed'
    'https://www.bleepingcomputer.com/feed/'
    'https://gbhackers.com/feed/'
    'https://grahamcluley.com/feed/'
    'https://threatpost.com/feed/'
    'https://krebsonsecurity.com/feed/'
    'https://www.darkreading.com/rss.xml'
    'http://feeds.feedburner.com/eset/blog'
    'https://www.darktrace.com/blog/index.xml'
    'https://www.security.nl/rss/headlines.xml'
)

displayedTitles=()
allItems=()
counter=1

echo "Loading RSS feeds... please wait"

for url in ${urls[@]}; do
    curl -s $url | xmlstarlet sel -t -m "//item" -v "title" -n -v "link" -n -v "description" -n -v "pubDate" -n -o "-----" -n 2> /dev/null | while read -r line; do
        title=$(echo $line)
        read -r link
        read -r description
        read -r pubDate

        pubDate=$(date -d"$pubDate" +%s)
        nowMinus12Hours=$(date -d"12 hours ago" +%s)

        if [[ $pubDate -gt $nowMinus12Hours ]]; then
            if [[ ! " ${displayedTitles[@]} " =~ " ${title} " ]]; then
                displayedTitles+=("$title")

                echo ""
                echo "[$counter] Title: $title"
                echo "Publish date: $(date -d@$pubDate)"
                echo "Description: $(echo $description | head -n5)"
                echo ""
                echo "Source: $link"
                echo ""

                counter=$((counter+1))

                sleep 3
            fi
        fi
    done
done
