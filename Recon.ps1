#Automated News reader edit $urlstrings to put in your own sources

$urlString = @(
    "https://www.cisa.gov/uscert/ncas/alerts.xml",
    "https://feeds.feedburner.com/TheHackersNews",
    "https://www.ncsc.gov.uk/api/1/services/v1/all-rss-feed",
    "https://www.bleepingcomputer.com/feed/",
    "https://gbhackers.com/feed/",
    "https://threatpost.com/feed/",
    "http://feeds.feedburner.com/securityweek",
    "https://www.darkreading.com/rss.xml"
)

# Use the .NET Framework's XmlDocument class to parse the RSS feed
$xml = New-Object System.Xml.XmlDocument

# Create an array to hold the titles of news items that have been displayed
$displayedTitles = @()

while(1) {
    # Loop through each feed URL in the $urlString array
    foreach($url in $urlString) {
        # Load the RSS feed using the XmlDocument object
        $xml.Load($url)

        # Select the "item" elements from the RSS feed, which contain the individual news items
        $items = $xml.SelectNodes("//item")

        # Loop through each news item in the $items array
        foreach($item in $items) {
            $title = $item.SelectSingleNode("title").InnerText -replace "<[^>]*>", ""
            $link = $item.SelectSingleNode("link").InnerText -replace "<[^>]*>", ""
            $description = $item.SelectSingleNode("description").InnerText -replace "<[^>]*>", ""
            $description = $description -replace "&nbsp;", ""
            $descriptionLines = $description -split "`n" | Select-Object -First 2
            $pubDate = [DateTime]::Parse($item.SelectSingleNode("pubDate").InnerText)
            

            # Check if the news item's title has already been displayed
            if ($displayedTitles -contains $title) {
                # If the title has already been displayed, skip this news item
                continue
            }

            # Check if the news item's publication date is within the last 36 hours
            if ($pubDate -gt (Get-Date).AddHours(-48)) {
                Write-Host ""
                Write-Host Title:" $title" -ForegroundColor green
                write-host Publish date: $pubDate -ForegroundColor yellow
                Write-Host Description: $descriptionLines
                Write-Host ""
                Write-Host ""

                Write-Host "Source: $link"

                # Add the news item's title to the list of displayed titles
                $displayedTitles += $title

                Start-Sleep -Seconds 1
            }
        }
    } 
}
