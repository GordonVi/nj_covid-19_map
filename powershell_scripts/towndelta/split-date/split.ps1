
Remove-Item -recurse *.csv

$csv = import-csv "..\combined.csv"

foreach ($line in $csv) {

	if ($line.month -eq 3) {$month = "mar"}
	if ($line.month -eq 4) {$month = "apr"}
	if ($line.month -eq 5) {$month = "may"}
	if ([int]$line.day -lt 10) { $line.day = "0"+$line.day }
	
	#$file=$line.month+"-"+$line.day+"-"+$line.year+".csv"
	
	$file="town_"+$month+"-"+$line.day+".csv"
	
	if (-not $(Test-Path $file)) { "town,county,cases" | Out-File -encoding ASCII $file }
	
	$line.town+","+$line.county+","+$line.cases | Out-File -append -encoding ASCII $file
	}

