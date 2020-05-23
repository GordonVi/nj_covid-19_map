$prop1 = @{Expression='month'; Descending=$true }
$prop2 = @{Expression='day'; Descending=$true }
$prop3 = @{Expression='county'; Ascending=$true }
$prop4 = @{Expression='town'; Ascending=$true }

$csv = import-csv "../combined.csv" | sort-object $prop1, $prop2, $prop3, $prop4
$popcsv = import-csv "../../population.csv"

$month = $csv[0].month
$day = $csv[0].day

# https://stackoverflow.com/questions/31343752/how-can-you-select-unique-objects-based-on-two-properties-of-an-object-in-powers

$just_towns = $csv | Group-Object 'town','county' | %{ $_.Group | Select 'town','county' -First 1} | Sort-object $prop3, $prop4
  
  
#$csv | Out-GridView
#$just_towns | Out-GridView

$output_array=@()

$counter=0

foreach ($line in $just_towns) {

	$focus = $csv | where {($_.town -eq $line.town -and $_.county -eq $line.county)} | sort-object $prop1, $prop2, $prop3, $prop4


	$counter++
	"Calculate Delta  - " + $counter.tostring() + " - " + $line.town + ", " + $line.county

	# if ($counter -gt 10) {break}
	$flag=0

	
	foreach ($date in $focus) {

			# add population column

			foreach($popline in $popcsv){
				$poptown = $($popline.town).replace("_"," ")
				$popcounty = $($popline.county).replace("_"," ")

				if (($poptown -eq $date.town) -and ($popcounty -eq $date.county)) {
					$population=$popline.population
					break
				} else {
					$population = "N/A"
				}
			}
			
			Add-Member -InputObject $date -MemberType NoteProperty -Name "population" -Value $population -Force

			# add current per capita percentage
			
			if ($population -ne "N/A") {
			
				$percent = $($focus[0].cases)/$population
				$percent_temp = 100*$percent
				if ($maxpercent -lt $percent_temp) {$maxpercent=$percent_temp}
				$percent_temp = % { '{0:0.##}' -f $percent_temp }

				Add-Member -InputObject $date -MemberType NoteProperty -Name "percent" -Value $percent_temp -Force
			} else {
				Add-Member -InputObject $date -MemberType NoteProperty -Name "percent" -Value "N/A" -Force
			}
			
			$delta_entry=1
			
			if ($focus.length -gt $delta_entry) {
					$value = $focus[0].cases - $focus[$delta_entry].cases
				} else {
					$value = "N/A"
				}

				Add-Member -InputObject $date -MemberType NoteProperty -Name $($delta_entry.tostring()+"_entry_delta") -Value $value -Force

			foreach ($delta_entry in 3,7,14,21,28,35) {
			
				if ($focus.length -gt $delta_entry) {
						$value = $focus[0].cases - $focus[$delta_entry-1].cases
					} else {
						$value = ""
					}

					Add-Member -InputObject $date -MemberType NoteProperty -Name $($delta_entry.tostring()+"_entry_delta") -Value $value -Force
				}
				
		
		}

# -----------------------------------------

			$counterb=0
			$old=0
			
			for ($ia=$focus.length-1; $ia -ge 0 ; $ia--) {
			

				$difference = $focus[$ia].cases-$old

				
				if ($difference -lt 6){
						$counterb++
						#$tempcolor="green"
					} else {
						$counterb=0
					}

				# "$ia : $counterb : $($focus[$ia].cases) - $old = $difference"

				$old = $focus[$ia].cases
				}

			
			Add-Member -InputObject $focus[0] -MemberType NoteProperty -Name "consecutive" -Value $counterb -Force
			
# -----------------------------------------



		$output_array += $focus[0]

	}

#$output_array | Out-gridview
#$line | Out-gridview

"Writing delta.csv"

$output_array | Export-CSV -encoding ASCII -path "$($month)-$($day)_delta.csv"
copy-item "$($month)-$($day)_delta.csv" "delta.csv"

$htmltable=@()

$htmltable+='<table class="sortable" border="1">'
$htmltable+="		<thead>"
$htmltable+="			<tr>"
$htmltable+="				<th>"
$htmltable+="					<b>Date</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>Town</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>County</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>Cases</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>Population</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>Percent</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>Days/Redux Trend</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					Delta/Data Points:"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>1</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>3</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>7</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>14</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>21</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>28</b>"
$htmltable+="				</th>"
$htmltable+="				<th>"
$htmltable+="					<b>35</b>"
$htmltable+="				</th>"
$htmltable+="			</tr>"
$htmltable+="		</thead>"
$htmltable+="		<tbody>"


$counter=0

foreach ($line in $output_array) {

	$counter++
	"Render HTML -  $counter - "+$line.town+", "+$line.county
	
	$htmltable+="			<tr>"
	
	$htmltable+="				<td>"
	$htmltable+="					"+$($line.month)+"-"+$($line.day)
	$htmltable+="				</td>"
	$htmltable+="				<td>"
	$htmltable+='					<a href="http://virasawmi.com/gordon/covid-19/town_graph/graph.php?a='+$($($line.town).replace(" ","_"))+"_"+$($($line.county).replace(" ","_"))+'">'+$($line.town)+"</a>"
	$htmltable+="				</td>"
	$htmltable+="				<td>"
	$htmltable+="					"+$($line.county)
	$htmltable+="				</td>"
	$htmltable+="				<td>"
	$htmltable+="					"+$($line.cases)
	$htmltable+="				</td>"

	if ($line.population -eq "N/A") {
		$htmltable+='				<td bgcolor="grey">'
		} else {
		$htmltable+="				<td>"
		}

	$htmltable+="					"+$($line.population)
	$htmltable+="				</td>"

	# percent
	if ($line.percent -eq "N/A") {
		$htmltable+='				<td bgcolor="grey">'
		} else {
		$htmltable+="				<td>"
		}

	$htmltable+="					"+$($line.percent)
	$htmltable+="				</td>"

	# consecutive
	if ($line.consecutive -ge 14) {
		$htmltable+='				<td bgcolor="#2e6940">'
		} else {
		$htmltable+="				<td>"
		}

	$htmltable+="					"+$($line.consecutive)
	$htmltable+="				</td>"
	
	$htmltable+='				<td bgcolor="black">'
	$htmltable+="				</td>"

	$maxcell=0
	$mincell=0
	
	foreach ($delta_entry in 1,3,7,14,21,28,35)
		{
			$number=$($line."$($delta_entry)_entry_delta")
			if ($number -ge $maxcell) {$maxcell = $number}
			if ($number -lt $mincell) {$mincell = $number}
		}
		
	foreach ($delta_entry in 1,3,7,14,21,28,35)
		{
			$number=$($line."$($delta_entry)_entry_delta")
			
			If ($number -eq 0 ) {
					$htmltable+="				<td>0</td>"
				} elseif ($number -eq "") {
					$htmltable+='				<td bgcolor="grey"></td>'
				} elseif ($number -gt 0) {
					if ($maxcell -eq 0 ) {$maxcellx = 1} else {$maxcellx = $maxcell}
					$shader = [int]$([math]::Round([int](255-($number/$maxcellx)*221))) #255-221
					$colorx=$('{0:x2}' -f $shader)
					$htmltable+='				<td bgcolor="#ff'+$colorx+$colorx+'" style="color:black">'
					$htmltable+="					"+$number
					$htmltable+="				</td>"
				} elseif ($number -lt 0) {
					$htmltable+='				<td bgcolor="#aaffaa" style="color:black">'
					$htmltable+="					"+$number
					$htmltable+="				</td>"
				}
				
		}

	}

$htmltable+="		</tbody>"
$htmltable+="<table>"

"Writing HTML file"

$htmltable | out-file -encoding ASCII -force -path "$($month)-$($day)_delta.html"
copy-item "$($month)-$($day)_delta.html" "delta.html"
