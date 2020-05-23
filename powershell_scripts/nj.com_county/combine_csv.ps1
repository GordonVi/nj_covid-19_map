$outputPath = "town_$(Get-Date -UFormat "%b-%d").csv".tolower()


if (Test-Path $OutputPath) { remove-item $outputPath}


$FileNames = Get-ChildItem -Name 'data\*.csv' -File

$data=@()
$data+="month,day,year,town,county,cases"

foreach ($filename in $filenames) {


	$csv = import-csv "data\$filename"
	
	$filename
	$county = $filename.replace(".csv","")
	
	foreach ($line in $csv) {
	
		$temp = $line."TOTAL CASES"
		$temp = $temp.replace(",","")
		
		$y=$line.LOCATION+","+$county+","+$temp
		$data+=$(Get-Date -UFormat "%m,%d,%Y,")+$y
		}
	
	}

$data | Out-File -encoding ASCII $OutputPath

		$csv = Import-Csv $OutputPath
		Foreach($line in $csv) {
					$line.town = $($line.town).Trim()
					$line.county = $($line.county).Trim()
					
				}

		$csv | Export-Csv -NoTypeInformation -encoding ASCII -path $OutputPath

$data = import-csv $OutputPath


$prop1 = @{Expression='month'; Descending=$true }
$prop2 = @{Expression='day'; Descending=$true }
$prop3 = @{Expression='county'; Ascending=$true }
$prop4 = @{Expression='town'; Ascending=$true }


$data = $data | Where-Object { $_.cases -ne 'NA' }
$data = $data | Where-Object { $_.town -ne 'TOTAL' }

foreach ($line in $data){ 

							if ($line.town -eq 'Barnegat Twp.') {$line.town = "Barnegat"}
							if ($line.town -eq 'Bass River Twp.') {$line.town = "Bass River"}
							if ($line.town -eq 'Berlin Boro') {$line.town = "Berlin Borough"}
							if ($line.town -eq 'Berlin Twp') {$line.town = "Berlin Township"}
							if ($line.town -eq 'Bernards Twp.') {$line.town = "Bernards"}
							if ($line.town -eq 'Beverly City') {$line.town = "Beverly"}
							if ($line.town -eq 'Boonton Twp') {$line.town = "Boonton Township"}
							if ($line.town -eq 'Bordentown Twp.') {$line.town = "Bordentown Township"}
							if ($line.town -eq 'Buena Vista') {$line.town = "Buena Vista Township"}
							if ($line.town -eq 'Burlington Twp.') {$line.town = "Burlington Township"}
							if ($line.town -eq 'Cape May City') {$line.town = "Cape May"}
							if ($line.town -eq 'Chatham Twp') {$line.town = "Chatham Township"}
							if ($line.town -eq 'Chester Twp') {$line.town = "Chester Township"}
							if ($line.town -eq 'Clayton') {$line.town = "Gloucester"; $line.county = "Essex"}
							if ($line.town -eq 'Clinton Twp.') {$line.town = "Clinton Township"}
							if ($line.town -eq 'Commercial Twp.') {$line.town = "Commercial"}
							if ($line.town -eq 'Deerfield Twp.') {$line.town = "Deerfield"}
							if ($line.town -eq 'Dennis Township') {$line.town = "Dennis"}
							if ($line.town -eq 'Downe Twp.') {$line.town = "Downe"}
							if ($line.town -eq 'Egg Harbor Twp.') {$line.town = "Egg Harbor Township"}
							if ($line.town -eq 'Fairfield Twp.') {$line.town = "Fairfield"}
							if ($line.town -eq 'Franklin Borough') {$line.town = "Franklin"}
							if ($line.town -eq 'Franklin Twp') {$line.town = "Franklin"}
							if ($line.town -eq 'Franklin Twp.') {$line.town = "Franklin"}
							if ($line.town -eq 'Franklin Twp.') {$line.town = "Franklin"}
							if ($line.town -eq 'Freylinghuysen') {$line.town = "Frelinghuysen"}
							if ($line.town -eq 'Gloucester Twp') {$line.town = "Gloucester Township"}
							if ($line.town -eq 'Greenwich Twp.') {$line.town = "Greenwich"}
							if ($line.town -eq 'Haddon Twp') {$line.town = "Haddon Township"}
							if ($line.town -eq 'Hopewell Twp') {$line.town = "Hopewell Township"}
							if ($line.town -eq 'Hopewell Twp.') {$line.town = "Hopewell"}
							if ($line.town -eq 'Jefferson Twp') {$line.town = "Jefferson"}
							if ($line.town -eq 'Lawrence Twp.') {$line.town = "Lawrence"}
							if ($line.town -eq 'Lebanon Boro') {$line.town = "Lebanon Borough"}
							if ($line.town -eq 'Lebanon Twp') {$line.town = "Lebanon Township"}
							if ($line.town -eq 'Long Hill Twp') {$line.town = "Long Hill"}
							if ($line.town -eq 'Medford Twp.') {$line.town = "Medford Township"}
							if ($line.town -eq 'Mendham Twp') {$line.town = "Mendham Township"}
							if ($line.town -eq 'Monroe Twp.') {$line.town = "Monroe"}
							if ($line.town -eq 'Morris Twp') {$line.town = "Morris Township"}
							if ($line.town -eq 'Ocean Twp.-Waretown') {$line.town = "Ocean Township"}
							if ($line.town -eq 'Oldmans') {$line.town = "Oldsman"}
							if ($line.town -eq 'Pemberton Twp.') {$line.town = "Pemberton Township"}
							if ($line.town -eq 'Pemberton Twp.') {$line.town = "Pemberton Township"}
							if ($line.town -eq 'Raritan Twp') {$line.town = "Raritan Township"}
							if ($line.town -eq 'Rockaway') {$line.town = "Rockaway Borough"}
							if ($line.town -eq 'Rockaway Twp.') {$line.town = "Rockaway Township"}
							if ($line.town -eq 'Shrewsbury Twp.') {$line.town = "Shrewsbury Township"}
							if ($line.town -eq 'Union Twp.') {$line.town = "Union"}
							if ($line.town -eq 'Union Twp.') {$line.town = "Union"}
							if ($line.town -eq 'Warren Twp.') {$line.town = "Warren"}
							if ($line.town -eq 'Washington Boro') {$line.town = "Washington Borough"}
							if ($line.town -eq 'Washington Twp') {$line.town = "Washington Township"}
							if ($line.town -eq 'Washington Twp') {$line.town = "Washington Township"}
							if ($line.town -eq 'Washington Twp.') {$line.town = "Washington Township"}
							if ($line.town -eq 'White Twp') {$line.town = "White"}
							if ($line.town -eq 'Woodlyne') {$line.town = "Woodlynne"}
						}


$data | sort-object $prop1, $prop2, $prop3, $prop4 | export-csv -NoTypeInformation -encoding ASCII -path $OutputPath

(gc $OutputPath -Raw) -replace ' "','"' | out-file -encoding ASCII -Force $OutputPath