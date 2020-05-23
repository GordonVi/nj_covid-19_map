############################################################
#Project : Reading XML files with PowerShell
#Developer : Thiyagu S (dotnet-helpers.com)
#Tools : PowerShell 5.1.15063.1155 
#E-Mail : mail2thiyaguji@gmail.com 
#URL: https://dotnet-helpers.com/powershell/reading-xml-files-with-powershell/
############################################################

# Modified by u/gordonv for Covid-19 NJ_Map - 4-8-2020
# URL: reddit.com/r/newjersey

$datetag = "may-22"

$sensitivity_scale=.8


$csv=Import-CSV -Path "./towndelta/split-town/delta.csv"
#copy-item "./towndelta/town_$datetag.csv" "town_$datetag.csv"
$maxcase=0
$non_listed_towns=@()
$NonListedTownPath=$datetag+"_non_listed_towns.csv"
$xmlblurb=@()


# https://gist.github.com/vors/6a5fb848476f20db6228
function Convert-XmlElementToString
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $xml
    )

    $sw = [System.IO.StringWriter]::new()
    $xmlSettings = [System.Xml.XmlWriterSettings]::new()
    $xmlSettings.ConformanceLevel = [System.Xml.ConformanceLevel]::Fragment
    $xmlSettings.Indent = $true
    $xw = [System.Xml.XmlWriter]::Create($sw, $xmlSettings)
    $xml.WriteTo($xw)
    $xw.Close()
    return $sw.ToString()
}

foreach($line in $csv){
	$casestr=$($line.cases)
	$cases=[int]$casestr
	if ($cases -gt $maxcase) {$maxcase=$cases}
	}

$sensitivity=$maxcase*$sensitivity_scale

# number to hex - https://www.powershellmagazine.com/2012/10/12/pstip-converting-numbers-to-hex/
# '{0:x2}' -f 174


$XMLfile = 'Map_of_New_Jersey_municipalities.svg'
[XML]$MapDetails = Get-Content $XMLfile

	$flag_background=0
	$flag_County_Border=0

 
foreach($MapDetail in $MapDetails.svg.path){
 

#	Write-Host "    d :" $MapDetail.d
#	Write-Host "   Id :" $MapDetail.id
#	Write-Host "Style :" $MapDetail.style
#	Write-Host ''

	$check_town_exists=0
	
	
	foreach($line in $csv){
		$town=$($line.town).Trim()
		$maptext = $town
		$town=$town -replace ' ', '_'
		$casestr=$($line.cases)
		$maptext = "$maptext - $casestr"
		$cases=[int]$casestr
		$county=$($line.county)

		if (($town -eq $MapDetail.id) -or ($("$town"+"_"+$county) -eq $MapDetail.id)) {
		
			$intensity=($cases/($maxcase-$sensitivity))
			if ($intensity -gt 1) {$intensity=1}
			if ($intensity -lt 0) {$intensity=0}
			
			$colornum=[int]$([math]::Round([int]$($intensity*255)))
			$colornum=255-$colornum
			$color=$('{0:x2}' -f $colornum)
			$oppositecolor=$('{0:x2}' -f (255-$colornum))
			$color="#$oppositecolor"+"77$color;"
			
			$town+" - "+$color+" - "+$colornum
			
			$MapDetail.style = $MapDetail.style -replace '#ffffff;',$color

			$child = $MapDetails.CreateElement("title")
			$child.InnerXml = $maptext
			$MapDetail.AppendChild($child) | Out-Null
			
			$check_town_exists=1

			#prependchild
			
			
			#$temp

			$temp = $(Convert-XmlElementToString $MapDetail)
			
			$temp = $temp.replace("<path",'<a href="http://virasawmi.com/gordon/covid-19/town_graph/graph.php?a='+$town+'_'+$county+'"><path')
			$temp = $temp.replace("</path>","</path></a>")
			
			$xmlblurb+=$temp
			
			
			} else {

				
				if (($MapDetail.id -eq "Background") -and ($flag_background -eq 0)) {
				
					$flag_background = 1
					" -- " + $MapDetail.id
					
					$temp = $(Convert-XmlElementToString $MapDetail)
					$xmlblurb+=$temp
					}

				if (($MapDetail.id -eq "County_Border") -and ($flag_county_border -eq 0)) {
				
					$flag_county_border = 1
					" -- " + $MapDetail.id
					
					$temp = $(Convert-XmlElementToString $MapDetail)
					$xmlblurb+=$temp
					}

			
			}
		} 
		
		
		
		
		if ($check_town_exists -eq 0) {

			#$MapDetail.id
			$non_listed_towns+=$MapDetail.id
			$town = $MapDetail.id
			
			$child = $MapDetails.CreateElement("title")
			$child.InnerXml = "$town - No Data"
			$MapDetail.AppendChild($child) | Out-Null

			}
	 
	}



$non_listed_towns | out-file $NonListedTownPath


$ChildNodes = $MapDetails.svg.path

foreach($Child in $ChildNodes){
    [void]$Child.ParentNode.RemoveChild($Child)
}


 $URL="$($(get-location).path)\$($datetag)_cases_NJ_covid-19.svg"
 
$MapDetails.save($URL)

$xmlblurb += '<defs id="defs5"><linearGradient id="Gradient" gradientTransform="rotate(90)"><stop offset="0%"  stop-color="#FF7700" /><stop offset="100%" stop-color="#0077FF" /></linearGradient></defs> <rect x="7" y="697" rx="15" ry="15" width="56" height="506" fill="black"/><rect x="10" y="700" rx="15" ry="15" width="50" height="500" fill="url(#Gradient)"/><text x="70" y="720"  font-size="30" fill="black">'
$xmlblurb += $maxcase
$xmlblurb += '</text><text x="70" y="1200"  font-size="30" fill="black">0</text>'

$xmlblurb += "</svg>"

(gc $URL -Raw) -replace '</svg>',$xmlblurb | out-file $URL

(gc $URL -Raw) -replace 'xmlns=""','' | out-file $URL
(gc $URL -Raw) -replace 'Date:',"Date: $datetag" | out-file $URL
(gc $URL -Raw) -replace 'Max Cases:',"Max Cases: $maxcase" | out-file $URL
