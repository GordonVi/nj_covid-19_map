
$FileNames = Get-ChildItem -Name '*.html' -File

foreach ($filename in $filenames) {

	$datetag = $filename.replace(".html","")

	$InputPath = "$datetag.html"
	$OutputPath = "town_$datetag.csv"

	if (-not $(Test-Path $OutputPath)) {

	write-host -foregroundcolor "yellow" $datetag

		#$Lines = (type $InputPath | select-string "•") -replace('•','') -replace(":",'"	"')
		$Lines = (type $InputPath | Select-String -Pattern "•", "COUNTY" -SimpleMatch) -replace('•','') -replace(",","") -replace(":",'","')



		Write-Output '"town","cases","county"' | Out-File -encoding ASCII $OutputPath

		foreach ($Line in $Lines) {
		$Line = $line.Insert(0,'"')
		$Line = $Line.replace('" ','"')
		$Line += '"'
		Write-Output $Line | Out-File $OutputPath -Append -encoding ASCII
		}

		$csv = import-csv $OutputPath
		$old_county=""
		$count=0

		foreach ($line in $csv) {

			If ($line.town -like "*county*") {
			
					$s = $line.town -split " "
					$line.county = $s[0]
					$line.town = ""
					$count++
					
					if ($count -eq 1) {
						$county=$s[0]
						$textInfo = (Get-Culture).TextInfo
						if ($county -eq "Cape") {$county = "Cape May"}
						$county=$TextInfo.ToTitleCase($county.ToLower())
						}
					
				} else {
				
					$count=0
					$line.county = $county
					}
						
				

					#$old_county=$line.county
			
			$a=0
			If ($line.cases -like "*(*") { $a=1 }
			If ($line.cases -like "*and*") { $a=1 }
			If ($line.cases -like "*with*") { $a=1 }
			If ($line.cases -like "*case*") { $a=1 }
			If ($line.cases -like "*death*") { $a=1 }
			If ($line.cases -like "*including*") { $a=1 }
			If ($line.cases -like "* *") { $a=1 }

			if ($a -eq 1) {
			
				$s = $line.cases -split " "
				$line.cases = $s[0]
				}
				
		
			}


		$csv | where {$_.town -ne ""} | Export-Csv -NoTypeInformation $OutputPath
		
		$csv = Import-Csv $OutputPath
		Foreach($line in $csv) {
					$line.town | Foreach-Object {$_ = $_.Trim()}
					$line.town =$($line.town).replace("* ","")
					$line.town =$($line.town).replace("*","")
					$line.county | Foreach-Object {$_ = $_.Trim()}
					
				}

		$csv | Export-Csv -NoTypeInformation -encoding ASCII -path $OutputPath

			
			} else { $datetag }

	}
