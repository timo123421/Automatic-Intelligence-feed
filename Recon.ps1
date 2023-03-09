#Automated News reader edit $urlstrings to put in your own sources
clear
Write-Host "
___________.__   .__   __              __   .__                             __                   ___.                    .__          __           .__   
\_   _____/|  |  |__|_/  |_   ____   _/  |_ |  |__ _______   ____  _____  _/  |_    ____  ___.__.\_ |__    ____ _______  |__|  ____ _/  |_   ____  |  |  
 |    __)_ |  |  |  |\   __\_/ __ \  \   __\|  |  \\_  __ \_/ __ \ \__  \ \   __\ _/ ___\<   |  | | __ \ _/ __ \\_  __ \ |  | /    \\   __\_/ __ \ |  |  
 |        \|  |__|  | |  |  \  ___/   |  |  |   Y  \|  | \/\  ___/  / __ \_|  |   \  \___ \___  | | \_\ \\  ___/ |  | \/ |  ||   |  \|  |  \  ___/ |  |__
/_______  /|____/|__| |__|   \___  >  |__|  |___|  /|__|    \___  >(____  /|__|    \___  >/ ____| |___  / \___  >|__|    |__||___|  /|__|   \___  >|____/
        \/                       \/              \/             \/      \/             \/ \/          \/      \/                  \/            \/                                                                                                                            \______/                                                                           
" -ForegroundColor green
$urlString = @(
    "https://www.cisa.gov/uscert/ncas/alerts.xml",
    "https://feeds.feedburner.com/TheHackersNews",
    "https://www.ncsc.gov.uk/api/1/services/v1/all-rss-feed"
    "https://www.bleepingcomputer.com/feed/",
    "https://gbhackers.com/feed/",
    'https://grahamcluley.com/feed/',
    'https://threatpost.com/feed/',
   'https://krebsonsecurity.com/feed/',
   'https://www.darkreading.com/rss.xml',
   'http://feeds.feedburner.com/eset/blog',
   'https://www.darktrace.com/blog/index.xml',
   'https://www.us-cert.gov/ncas/alerts.xml'

  
)

# Create an array to hold the titles of news items that have been displayed
$displayedTitles = @()

# Continuously monitor the RSS feeds for new news items
while (1) {
    # Loop through each feed URL in the $urlString array
    foreach ($url in $urlString) {
        # Load the RSS feed using the XmlDocument object
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($url)

        # Select the "item" elements from the RSS feed, which contain the individual news items
        $items = $xml.SelectNodes("//item")

        # Loop through each news item in the $items array
        foreach ($item in $items) {
            # Extract the news item's title, link, description, and publication date
            $title = $item.SelectSingleNode("title").InnerText -replace "<[^>]*>", ""
            $link = $item.SelectSingleNode("link").InnerText -replace "<[^>]*>", ""
            $description = $item.SelectSingleNode("description").InnerText -replace "<[^>]*>", ""
            $description = $description -replace "&nbsp;", ""
            $descriptionLines = $description -split "`n" | Select-Object -First 2
            $dateString = $item.SelectSingleNode("pubDate").InnerText
            
            try {
                $pubDate = [DateTime]::Parse($dateString)
            }
            catch [System.FormatException] {
                # handle the format exception
                continue
            }
            catch {
                # handle any other exception
                Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                continue
            }

            # Check if the news item's title has already been displayed
            if ($displayedTitles -contains $title) {
                # If the title has already been displayed, skip this news item
                continue
            }

            # Check if the news item's publication date is within the last 8 hours
            if ($pubDate -gt (Get-Date).AddHours(-8)) {
                # Display the news item's title, publication date, description, and source
                Write-Host ""
                Write-Host "Title: $title" -ForegroundColor Green
                Write-Host "Publish date: $pubDate" -ForegroundColor Yellow
                Write-Host "Description: $descriptionLines"
                Write-Host ""
                Write-Host ""
                Write-Host "Source: $link"

                # Add the news item's title to the list of displayed titles
                $displayedTitles += $title

                # Wait for 3 seconds before checking the next news item
                Start-Sleep -Seconds 3
            }
        }
    }
}
