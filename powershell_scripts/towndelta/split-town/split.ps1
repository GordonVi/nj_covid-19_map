$csv = import-csv "../combined.csv"
copy-item "../combined.csv" "combined.csv"

"Sorting csv"

foreach ($line in $csv) {
	#$line.month = [int]::Parse($line.month)
	#$line.day = [int]::Parse($line.day)
	$line.month = $line.month
	$line.day = $line.day
	}

$csv = $csv | Sort-Object Month,Day

"rendering town files"

foreach ($line in $csv) {

	$file=$($line.town+"_"+$line.county+".csv").replace(" ","_")
	
	if (-not $(Test-Path $file)) { "month,day,year,cases" | Out-File -encoding ASCII $file }
	
	$month = $line.month
	$day = $line.day
	
	#$month.tostring()+","+$day.tostring()+","+$line.year+","+$line.cases | Out-File -append -encoding ASCII $file
	$month+","+$day+","+$line.year+","+$line.cases | Out-File -append -encoding ASCII $file
	}

