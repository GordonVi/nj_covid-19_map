<?php 

# get the variable data

	$leader=($_GET["a"]);
	
			$rows = array_map('str_getcsv', file($leader.".csv"));
			$header = array_shift($rows);
			$csv = array();
			$counter=0;

			foreach ($rows as $row) {
			  $csv[$counter] = array_combine($header, $row);
			  $counter++;
			}

			# start fix CSV sort
			
				foreach ($csv as $key => $row) {
						$xmonth[$key]  = $row['month'];
						$xday[$key]  = $row['day'];
						$xyear[$key]  = $row['year'];
						$xcases[$key] = $row['cases'];
					}
					
				$xmonth  = array_column($csv, 'month');
				$xday  = array_column($csv, 'day');
				$xyear  = array_column($csv, 'year');
				$xcases  = array_column($csv, 'cases');
				
				array_multisort($xmonth, SORT_ASC, $xday, SORT_ASC, $xyear, SORT_ASC, $xcases, SORT_ASC,$csv);

			# end fix CSV sort

			
	# CSV to Array > https://gist.github.com/benbalter/3173096
	# CSV must be UTF-8 for PHP

	#$filepath="../".$datetag."_compiled_data.csv";
	$filepath="delta.csv";

$lines = explode( "\n", file_get_contents( $filepath ) );
$headers = str_getcsv( array_shift( $lines ) );
$data = array();
foreach ( $lines as $line ) {

	$row = array();

	foreach ( str_getcsv( $line ) as $key => $field )
		$row[ $headers[ $key ] ] = $field;

	$row = array_filter( $row );

	$data[] = $row;
	
	# Calculate Max Days

				$csvlen = count($csv);
				$counter=0;
				$max=0;
				$old=0;
				
				foreach ($csv as $line) {
					$counter++;
					$cases = $line["cases"];
					$temp = $cases-$old;
					if ($counter==1){$temp=0;}
					if ($max < $temp) {$max=$temp; $maxline=$old; $maxdaysago=$counter;}
					$old = $line["cases"];
				}

				$totaldays = $counter;

}


	# Array to HTML Table > https://www.daniweb.com/programming/web-development/threads/499809/generate-html-table-from-php-array
	
	
	foreach ($data as $theCurrentRow) {
		
		
		$town = $theCurrentRow['town'];
		$county = $theCurrentRow['county'];
		$cases = $theCurrentRow['cases'];
		$population = $theCurrentRow['population'];
		$percent = $theCurrentRow['percent'];
		
		
		if ($leader==str_replace(" ","_",$town)."_".$county) {break;}
		
		
		}
?><html>


<head>
	<script src="http://virasawmi.com/gordon/covid-19/town_graph/Chart.js/Chart.min.js"></script>
	<script src="http://virasawmi.com/gordon/covid-19/town_graph/Chart.js/samples/utils.js"></script>
	<style>
	canvas{
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none;
	}
	
	canvasb{
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none;
	}
	</style>
</head>

<body>

<h1><?php echo $town; ?> (<?php echo $county; ?>)</h1>
<hr>

<table border=0>
	<td>
	<table border=1>
			<tr>
				<td><b>Date</b></td><td><b>Cases</b></td>
			</tr>
<?php

		$last=0;
		
		foreach ($csv as $line) {
			
			$htmlcolor='';
			if ($last > $line["cases"]) { $htmlcolor=' bgcolor="#DDFFDD"';}
			if ($last < $line["cases"]) { $htmlcolor=' bgcolor="#FFEEEE"';}
			if ($last == $maxline) { $htmlcolor=' bgcolor="#FFAAAA"';}
			$last = $line["cases"];
			
			echo "	<tr>\n";
			echo "		<td>".$line["month"]."-".$line["day"]."-".$line["year"]."</td>\n";
			echo "		<td $htmlcolor>".$line["cases"]."</td>\n";
			echo "	</tr>\n";
			
			$month=$line["month"];
			$day=$line["day"];
			
			If ($month==3) {$month = "mar";}
			If ($month==4) {$month = "apr";}
			
			$datetag="$month-$day";
			
			
		}

?>
		</table>




	</td>
	<td valign="top">
		<a href="http://virasawmi.com/"><img src="http://virasawmi.com/gordon/covid-19/maps.jpg"></a><br>
		<table>
				<tr><td align="right"><b>Town:</b></td><td><?php echo $town; ?></td></tr>
				<tr><td align="right"><b>Date:</b></td><td><?php echo $datetag; ?></td></tr>
				<tr><td align="right"><b>County:</b></td><td><?php echo $county; ?></td></tr>
				<tr><td align="right"><b>Cases:</b></td><td><?php echo $cases; ?></td></tr>
				<tr><td align="right"><b>Population:</b></td><td><?php echo $population; ?></td></tr>
				<tr><td align="right"><b>Percent:</b></td><td><?php echo $percent; ?>%</td></tr>
				<tr><td align="right"><b>Start to Peak Days:</b></td><td><?php echo $maxdaysago; ?></td></tr>
				<tr><td align="right"><b>Peak to now Days:</b></td><td><?php echo $counter-$maxdaysago; ?></td></tr>
				<tr><td align="right" valign="top"><b>Total Days:</b></td><td><?php echo $totaldays; ?></td></tr>
				<tr><td align="right" valign="top"><b>CSV:</b></td><td><a href="<?php echo $leader.".csv"; ?>"><?php echo $leader.".csv"; ?></a><br><i>URL is static. Data is updated every day. You can link this to your scripts.</i></td></tr>
		</table>
		<title><?php echo $town; ?> (<?php echo $county; ?>)</title>
		<h2>Reddit Comment Paste:</h2>
		<textarea rows=12 cols=30>
<?php echo $town; ?> (<?php echo $county; ?>)  

- **Date:** [<?php echo $datetag; ?>](http://virasawmi.com/gordon/covid-19/maps.php?datetag=<?php echo $datetag; ?>#data)  
- **Cases:** [<?php echo $cases; ?>](http://virasawmi.com/gordon/covid-19/town_graph/graph.php?a=<?php echo str_replace(" ","_",$town)."_".$county; ?>) (<?php echo $percent; ?>%)    
- **Population:** <?php echo $population; ?>  

  
----  
  
[Today's Maps](http://virasawmi.com/)   

		</textarea>
	</td>



	<td valign="top" style="width:60%;">

			<div>
			
			<!--  Daily Change Table -->
			
			
				<center><b>Daily Change</b></center>

				<canvas id="canvas"></canvas>
				<script>
					var config = {
						type: 'line',
						data: {
							labels: [<?php



			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				
				foreach ($csv as $line) {
					$counter++;
					echo "'".$line["month"]."-".$line["day"]."'";
					if ($counter < $csvlen) {echo ',';}
				}

			?>],
							datasets: [{
								label: 'Daily Change',
								backgroundColor: window.chartColors.snow,
								borderColor: window.chartColors.purple,
								data: [<?php


			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				$old=0;
				
				foreach ($csv as $line) {
					$counter++;
					$temp = $line["cases"]-$old;
					if ($counter==1){$temp=0;}
					echo $temp;
					$old = $line["cases"];
					if ($counter < $csvlen) {echo ',';}
					$cases = $line["cases"];
				}

			?>],
								fill: true,
							},{
								label: '15 Day Average',
								backgroundColor: window.chartColors.red,
								borderColor: window.chartColors.red,
								data: [<?php


			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				$old=0;
				$dayspan=7; # rolling average span
				
				foreach ($csv as $line) {
					$counter++;
					$temp = $line["cases"]-$old;

					# Start rolling average calculator
					
						$counterb=0;
						$counterc=0;
						$summed=0;
						$oldb=0;

						foreach ($csv as $lineb) {

							$counterb++;
							
							$tempb = $lineb["cases"]-$oldb;
							

							if ($counterb > $counter-$dayspan and $counterb < $counter+$dayspan) {
								$summed=$summed+$tempb;
								$counterc++;
							}
							
								$oldb = $lineb["cases"];

						}
					
						$temp=round($summed/$counterc);
						
					# End rolling average calculator


					if ($counter==1){$temp=0;}
					if ($counter==$totaldays){$temp=$line["cases"]-$old;}

					echo $temp;
					$old = $line["cases"];
					if ($counter < $csvlen) {echo ',';}
					$cases = $line["cases"];
				}

			?>],
								fill: false,
							}]
						},
						options: {
								responsive: true,
								maintainAspectRatio: true,	
							title: {
								display: true,
								text: ''
							},
							tooltips: {
								mode: 'index',
								intersect: false,
							},
							hover: {
								mode: 'nearest',
								intersect: true
							},
							scales: {
								xAxes: [{
									display: true,
									scaleLabel: {
										display: true,
										labelString: 'Day'
									}
								}],
								yAxes: [{
									display: true,
									scaleLabel: {
										display: true,
										labelString: 'Cases'
									}
								}]
							}
						}
					};


				</script>
			</div>





<br><br><hr><br><br>




			
			<div>
			<!--  Cumulative Table -->
			
				
				<center><b>Cumulative</b></center>

				<canvas id="canvasb"></canvas>
				<script>
					var configb = {
						type: 'line',
						data: {
							labels: [<?php



			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				
				foreach ($csv as $line) {
					$counter++;
					echo "'".$line["month"]."-".$line["day"]."'";
					if ($counter < $csvlen) {echo ',';}
				}

			?>],
							datasets: [{
								label: 'Cases',
								backgroundColor: window.chartColors.blue,
								borderColor: window.chartColors.blue,
								data: [<?php


			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				$max=0;
				
				foreach ($csv as $line) {
					$counter++;
					echo $line["cases"];
					if ($counter < $csvlen) {echo ',';}
					$cases = $line["cases"];
					if ($max < $cases) {$max=$cases;}
				}

			?>],
								fill: false,
							},{
								label: 'Daily Change',
								backgroundColor: window.chartColors.purple,
								borderColor: window.chartColors.purple,
								data: [<?php


			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				$max=0;
				$old=0;
				
				foreach ($csv as $line) {
					$counter++;
					$temp = $line["cases"]-$old;
					if ($counter==1){$temp=0;}
					echo $temp;
					$old = $line["cases"];
					if ($counter < $csvlen) {echo ',';}
					$cases = $line["cases"];
					if ($max < $cases) {$max=$cases;}
				}

			?>],
								fill: false,
							},{
								label: 'Peak',
								backgroundColor: window.chartColors.whitesmoke,
								borderColor: window.chartColors.whitesmoke,
								data: [<?php




			# print_r($csv);

				$csvlen = count($csv);
				$counter=0;
				$max=0;
				$old=0;
				
				foreach ($csv as $line) {
					$counter++;
					$cases = $line["cases"];
					$temp = $cases-$old;
					if ($counter==1){$temp=0;}
					if ($max < $temp) {$max=$temp; $maxline=$old; $maxdaysago=$counter;}
					$old = $line["cases"];
				}

				$counter=0;

				foreach ($csv as $line) {
					$counter++;
					echo $max;
					if ($counter < $csvlen) {echo ',';}
				}

			?>],
								fill: true,
							}]
						},
						options: {
								responsive: true,
								maintainAspectRatio: true,	
							title: {
								display: true,
								text: ''
							},
							tooltips: {
								mode: 'index',
								intersect: false,
							},
							hover: {
								mode: 'nearest',
								intersect: true
							},
							scales: {
								xAxes: [{
									display: true,
									scaleLabel: {
										display: true,
										labelString: 'Day'
									}
								}],
								yAxes: [{
									display: true,
									scaleLabel: {
										display: true,
										labelString: 'Cases'
									}
								}]
							}
						}
					};

					window.onload = function() {

						var ctx = document.getElementById('canvas').getContext('2d');
						window.myLine = new Chart(ctx, config);

						var ctxb = document.getElementById('canvasb').getContext('2d');
						window.myLine = new Chart(ctxb, configb);
					};

				</script>
			</div>
			
	</td>

</table>

  </body>
</html>
