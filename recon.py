import feedparser
import time
import datetime
import logging

logging.basicConfig(filename='C:/logs/my-script.log', level=logging.INFO)

print("""
___________.__   .__   __              __   .__                             __                   ___.                    .__          __           .__   
\_   _____/|  |  |__|_/  |_   ____   _/  |_ |  |__ _______   ____  _____  _/  |_    ____  ___.__.\_ |__    ____ _______  |__|  ____ _/  |_   ____  |  |  
 |    __)_ |  |  |  |\   __\_/ __ \  \   __\|  |  \\_  __ \_/ __ \ \__  \ \   __\ _/ ___\<   |  | | __ \ _/ __ \\_  __ \ |  | /    \\   __\_/ __ \ |  |  
 |        \|  |__|  | |  |  \  ___/   |  |  |   Y  \|  | \/\  ___/  / __ \_|  |   \  \___ \___  | | \_\ \\  ___/ |  | \/ |  ||   |  \|  |  \  ___/ |  |__
/_______  /|____/|__| |__|   \___  >  |__|  |___|  /|__|    \___  >(____  /|__|    \___  >/ ____| |___  / \___  >|__|    |__||___|  /|__|   \___  >|____/
        \/                       \/              \/             \/      \/             \/ \/          \/      \/                  \/            \/     
""")
print("------------------------")
print("")
print("")
print("")

urlString = [
    'https://www.cisa.gov/uscert/ncas/alerts.xml',
    'https://feeds.feedburner.com/TheHackersNews',
    'https://www.ncsc.gov.uk/api/1/services/v1/all-rss-feed',
    'https://www.bleepingcomputer.com/feed/',
    'https://gbhackers.com/feed/',
    'https://grahamcluley.com/feed/',
    'https://threatpost.com/feed/',
    'https://krebsonsecurity.com/feed/',
    'https://www.darkreading.com/rss.xml',
    'http://feeds.feedburner.com/eset/blog',
    'https://www.darktrace.com/blog/index.xml',
    'https://www.security.nl/rss/headlines.xml'
]

displayedTitles = []
allItems = []
totalUrls = len(urlString)
counter = 1

while True:
    print("Loading RSS feeds... please wait")
    for index in range(totalUrls):
        url = urlString[index]
        feed = feedparser.parse(url)
        for entry in feed.entries:
            pubDate = datetime.datetime.strptime(entry.published, '%a, %d %b %Y %H:%M:%S %Z')
            if pubDate > datetime.datetime.now() - datetime.timedelta(hours=12):
                allItems.append({
                    "Title": entry.title,
                    "Link": entry.link,
                    "Description": entry.description,
                    "PubDate": pubDate
                })

    allItems.sort(key=lambda x: x['PubDate'])

    for item in allItems:
        title = item['Title']
        link = item['Link']
        description = item['Description'].replace("&nbsp;", "")
        descriptionLines = '\n'.join(description.split('\n')[:5])
        pubDate = item['PubDate']
        if title in displayedTitles:
            continue
        if pubDate > datetime.datetime.now() - datetime.timedelta(hours=12):
            print("")
            print(f"[{counter}] Title: {title}")
            print(f"Publish date: {pubDate}")
            print(f"Description: {descriptionLines}")
            print("")
            print(f"Source: {link}\n")
            displayedTitles.append(title)
            counter += 1
            time.sleep(3)
