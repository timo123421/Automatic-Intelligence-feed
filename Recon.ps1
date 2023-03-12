Start-Transcript -Path "C:\logs\my-script.log"
clear
Write-Host "



___________.__   .__   __              __   .__                             __                   ___.                    .__          __           .__   
\_   _____/|  |  |__|_/  |_   ____   _/  |_ |  |__ _______   ____  _____  _/  |_    ____  ___.__.\_ |__    ____ _______  |__|  ____ _/  |_   ____  |  |  
 |    __)_ |  |  |  |\   __\_/ __ \  \   __\|  |  \\_  __ \_/ __ \ \__  \ \   __\ _/ ___\<   |  | | __ \ _/ __ \\_  __ \ |  | /    \\   __\_/ __ \ |  |  
 |        \|  |__|  | |  |  \  ___/   |  |  |   Y  \|  | \/\  ___/  / __ \_|  |   \  \___ \___  | | \_\ \\  ___/ |  | \/ |  ||   |  \|  |  \  ___/ |  |__
/_______  /|____/|__| |__|   \___  >  |__|  |___|  /|__|    \___  >(____  /|__|    \___  >/ ____| |___  / \___  >|__|    |__||___|  /|__|   \___  >|____/
        \/                       \/              \/             \/      \/             \/ \/          \/      \/                  \/            \/                                                                                                                                       
" -ForegroundColor yellow



#Automated News reader edit $urlstrings to put in your own sources
$outputFile = "C:\output.txt"


$urlString = @(
"https://www.cisa.gov/uscert/ncas/alerts.xml",
"https://feeds.feedburner.com/TheHackersNews",
"https://www.ncsc.gov.uk/api/1/services/v1/all-rss-feed",
"https://www.bleepingcomputer.com/feed/",
"https://gbhackers.com/feed/",
'https://grahamcluley.com/feed/',
'https://threatpost.com/feed/',
'https://krebsonsecurity.com/feed/',
'https://www.darkreading.com/rss.xml',
'http://feeds.feedburner.com/eset/blog',
'https://www.darktrace.com/blog/index.xml',
'https://www.us-cert.gov/ncas/alerts.xml'
'http://www.exploit-monday.com/feeds/posts/default',
'http://ianduffy.ie/index.xml',
'https://www.swordshield.com/feed/',
'http://www.mathyvanhoef.com/feeds/posts/default',
'http://colesec.inventedtheinternet.com/feed/',
'http://blog.portswigger.net/feeds/posts/default',
'https://www.secureworks.com/rss?feed=research',
'http://www.us-cert.gov/channels/techalerts.rdf',
'https://labsblog.f-secure.com/feed/',
'http://taosecurity.blogspot.com/atom.xml',
'http://www.thespanner.co.uk/feed/',
'http://sysadmincasts.com/feed.rss',
'https://www.coalfire.com/Solutions/Coalfire-Labs/The-Coalfire-LABS-Blog?rss=blogs',
'https://d.uijn.nl/feed/',
'https://www.optiv.com/resources/blog/feed',
'https://ctus.io/rss/',
'http://artsploit.blogspot.com/feeds/posts/default?alt=rss',
'http://blog.0x3a.com/rss',
'http://blog.logrhythm.com/feed/',
'https://room362.com/post/index.xml',
'http://www.rvrsh3ll.net/blog/feed/',
'http://feeds.feedburner.com/NetspiBlog',
'https://www.n00py.io/feed/',
'http://www.fireeye.com/blog/feed',
'http://feeds.feedburner.com/GdsSecurityBlog',
'http://www.arneswinnen.net/feed/',
'https://blog.skullsecurity.org/feed',
'http://www.dawgyg.com/rss/',
'http://labofapenetrationtester.blogspot.com/feeds/posts/default',
'http://carnal0wnage.attackresearch.com/rss.xml',
'http://reverse.put.as/feed/',
'http://adsecurity.org/?feed=rss2',
'http://foxglovesecurity.com/feed/',
'http://www.acunetix.com/blog/feed/',
'http://stephensclafani.com/feed/',
'http://feeds.feedburner.com/n0where',
'http://malwaremustdie.blogspot.com/feeds/posts/default',
'http://feeds.feedburner.com/IrongeeksSecuritySite',
'http://www.sixdub.net/?feed=rss2',
'http://r00tsec.blogspot.com/feeds/posts/default',
'http://www.contextis.com/resources/blog/blog.xml',
'http://feeds.trendmicro.com/Anti-MalwareBlog/',
'http://feeds.feedburner.com/OjsRants',
'http://www.sans.org/rr/rss/',
'http://w00tsec.blogspot.com/feeds/posts/default',
'http://www.blackhillsinfosec.com/?feed=rss2',
'http://blog.didierstevens.com/feed/',
'https://warroom.securestate.com/feed/',
'http://sakurity.com/blog/feed.xml',
'http://randywestergren.com/feed/',
'http://bufferovernoah.com/feed/',
'http://sethsec.blogspot.com/feeds/posts/default',
'http://malware.dontneedcoffee.com/feeds/posts/default',
'http://derflounder.wordpress.com/feed/',
'http://www.unix-ninja.com/feed/rss/',
'https://trustfoundry.net/feed/',
'http://www.f-secure.com/weblog/weblog.rdf',
'http://feeds.feedburner.com/SucuriSecurity',
'http://enigma0x3.wordpress.com/feed/',
'https://blog.g0tmi1k.com/atom.xml',
'http://www.viruslist.com/en/rss/weblog',
'https://www.wired.com/category/security/feed/',
'https://feeds.feedburner.com/fortinet/blogs/security-research',
'http://isc.sans.org/rssfeed.xml',
'http://www.bluecoat.com/security/rss',
'http://feeds.feedburner.com/CyberArms'
'https://www.grepular.com/rss',
'http://feeds.feedburner.com/PentestTools',
'http://websec.ca/blog_posts/index.rss',
'http://thinkingmaliciously.blogspot.com/feeds/posts/default',
'https://www.trustedsec.com/feed/',
'http://community.websense.com/blogs/securitylabs/rss.aspx',
'http://g-laurent.blogspot.com/feeds/posts/default',
'https://objective-see.com/rss.xml',
'http://x42.obscurechannel.com/?feed=rss2',
'http://www.harmj0y.net/blog/feed/',
'http://krebsonsecurity.com/feed/',
'http://vrt-sourcefire.blogspot.com/feeds/posts/default',
'http://infamoussecurity.com/?feed=rss2',
'http://www.darkoperator.com/blog/rss.xml',
'http://www.cert.org/blogs/rss.xml',
'http://silentbreaksecurity.com/feed/',
'https://fin1te.net/feed.xml',
'http://googleonlinesecurity.blogspot.com/atom.xml',
'http://erratasec.blogspot.com/feeds/posts/default',
'http://barracudalabs.com/feed/',
'http://www.secureworks.com/rss/threat-analysis.xml',
'http://www.sensepost.com/blog/index.rss',
'https://whitton.io/feed.xml',
'https://sensepost.com/rss.xm',
'https://www.youtube.com/feeds/videos.xml?playlist_id=UU9Qa_gXarSmObPX3ooIQZrg',
'https://www.reddit.com/r/netsec/.rss',
'https://advisories.ncsc.nl/rss/advisories',
'https://feeds.ncsc.nl/nieuws.rss',
'https://research.checkpoint.com/category/threat-research/feed/',
'https://securityintelligence.com/category/x-force/feed/',
'https://www.netskope.com/blog/category/netskope-threat-labs/feed',
'https://blogs.juniper.net/threat-research/feed',
'https://www.fireeye.com/blog/threat-research/_jcr_content.feed?format=xml',
'https://feeds.feedburner.com/fortinet/blog/threat-research',
'https://www.securonix.com/resource-type/threat-research/feed/',
'https://www.recordedfuture.com/category/cyber/feed/',
'https://www.mcafee.com/blogs/tag/advanced-threat-research/feed',
'https://blog.paloaltonetworks.com/category/threat-research/feed/',
'https://www.kaspersky.co.in/blog/tag/threat-intelligence/feed/'
)

$displayedTitles = @()
$allItems = @()
$totalUrls = $urlString.Length
While(1){

try {
    $progressBar = [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {}
    # suppress the error message
Write-Host "Loading RSS feeds... please wait" -ForegroundColor yellow
Write-Progress -Activity "Loading RSS feeds...please wait" -PercentComplete 0

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
    $percentComplete = (($index + 1) / $totalUrls) * 100
    Write-Progress -Activity "Loading RSS feeds..." -PercentComplete $percentComplete -Status "$index/$totalUrls completed"
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
