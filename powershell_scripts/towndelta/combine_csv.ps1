$outputPath = "combined.csv"

if (Test-Path $OutputPath) { remove-item $outputPath}


$FileNames = Get-ChildItem -Name '*.csv' -File

$data=@()
$data+="month,day,year,town,county,cases"

foreach ($filename in $filenames) {

	$x = $filename.replace(".csv",",2020")
	$x = $x.replace("town_may-","5,")
	$x = $x.replace("town_apr-","4,")
	$x = $x.replace("town_mar-","3,")
	
	$csv = import-csv $filename
	
	$filename
	
	foreach ($line in $csv) {
	
		$y=$line.town+","+$line.county+","+$line.cases
		$data+=$x+","+$y
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



$data | sort-object $prop1, $prop2, $prop3, $prop4 | export-csv -NoTypeInformation -encoding ASCII -path $OutputPath

(gc $OutputPath -Raw) -replace ' "','"' | out-file -encoding ASCII -Force $OutputPath