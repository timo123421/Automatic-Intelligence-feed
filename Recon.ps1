Start-Transcript -Path "C:\logs\my-script.log"
clear
Write-Host "
___________.__   .__   __              __   .__                             __                   ___.                    .__          __           .__   
\_   _____/|  |  |__|_/  |_   ____   _/  |_ |  |__ _______   ____  _____  _/  |_    ____  ___.__.\_ |__    ____ _______  |__|  ____ _/  |_   ____  |  |  
 |    __)_ |  |  |  |\   __\_/ __ \  \   __\|  |  \\_  __ \_/ __ \ \__  \ \   __\ _/ ___\<   |  | | __ \ _/ __ \\_  __ \ |  | /    \\   __\_/ __ \ |  |  
 |        \|  |__|  | |  |  \  ___/   |  |  |   Y  \|  | \/\  ___/  / __ \_|  |   \  \___ \___  | | \_\ \\  ___/ |  | \/ |  ||   |  \|  |  \  ___/ |  |__
/_______  /|____/|__| |__|   \___  >  |__|  |___|  /|__|    \___  >(____  /|__|    \___  >/ ____| |___  / \___  >|__|    |__||___|  /|__|   \___  >|____/
        \/                       \/              \/             \/      \/             \/ \/          \/      \/                  \/            \/                                                                                                                                       
"
write-host "------------------------"
write-host ""
write-host ""
write-host ""


#Automated News reader edit $urlstrings to put in your own sources
$outputFile = "C:\output.txt"


$urlString = @(
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

$displayedTitles = @()
$allItems = @()
$totalUrls = $urlString.Length
While(1){

try {
} catch {}
    # suppress the error message
Write-Host "Loading RSS feeds... please wait" -ForegroundColor yellow

foreach ($index in 0..($totalUrls - 1)) {
    $url = $urlString[$index]
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($url)
        $items = $xml.SelectNodes("//item")

        # Define an array of date formats that may be used in the pubDate element
        $dateFormats = @("ddd, dd MMM yyyy HH:mm:ss zzz", "yyyy-MM-ddTHH:mm:sszzz", "yyyy-MM-ddTHH:mm:ss.fffZ")

        foreach ($item in $items) {
            $pubDate = $null
            foreach ($format in $dateFormats) {
                try {
                    $pubDate = [DateTime]::ParseExact($item.pubDate, $format, [System.Globalization.CultureInfo]::InvariantCulture)
                    break
                }
                catch {
                    continue
                }
            }
            if ($pubDate -gt (Get-Date).AddHours(-12)) {
                $allItems += [pscustomobject]@{
                    Title = $item.SelectSingleNode("title").InnerText -replace "<[^>]*>", ""
                    Link = $item.SelectSingleNode("link").InnerText -replace "<[^>]*>", ""
                    Description = $item.SelectSingleNode("description").InnerText -replace "<[^>]*>", ""
                    PubDate = $pubDate
                }
            }
        }
    }
    catch [System.Net.WebException] {
        continue
    }
    catch {
        continue
    }
}

# Sort the items by their pubDate in ascending order
$allItems = $allItems | Sort-Object -Property PubDate

$counter = 1
foreach ($item in $allItems) {
    $title = $item.Title
    $link = $item.Link
    $description = $item.Description -replace "&nbsp;", ""
    $descriptionLines = $description -split "`n" | Select-Object -First 5
    $pubDate = $item.PubDate
    if ($displayedTitles -contains $title) {
        continue
    }
    if ($pubDate -gt (Get-Date).AddHours(-12)) {
        Write-Host ""
        Write-Host "[$counter] Title: $title" -ForegroundColor Green
        Write-Host "Publish date: $pubDate" -ForegroundColor Yellow
        Write-Host "Description: $descriptionLines"
        Write-Host ""
        Write-Host "Source: $link     
        "
        $displayedTitles += $title
        $counter++

        #edit here how quickly
        Start-Sleep -Seconds 3
    }


}


}
stop-transcript
