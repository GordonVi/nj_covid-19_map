# nj_covid-19_map
  
## Scraping data from NJ.com

- Goto nj.com and copy the list of towns and cases from "Atlantic County" to the town named "White."  (ex: https://www.nj.com/coronavirus/2020/05/where-is-the-coronavirus-in-nj-latest-map-update-on-county-by-county-cases-may-20-2020.html)
- Paste that into a month-day.html file in the "towndelta" folder.  
- run "all_towns_csv.ps1"
- Open the new CSV and review for errors.  
- After the new CSV is reviewed and fixed, run "combine_csv.ps1" - this will combine all CSVs into a single combined.csv

### Converting scraped data into formatted data
- go into \towndelta\split-town in powershell
- run .\main.ps1 in powershell, this reads from combined.csv
This will create a lot of CSVs and an HTML table file.  

#### Converting formatted data into clickable SVG maps.
- goto the root
- edit the 5 ps1 files so the variable name matches the first segment of the "month-day" you set before.  
- run all 5 ps1 files. you can do this at the same time. These read from \towndelta\split-town\delta.csv
- This will create an SVG for each file.

##### What I do with this  
  
After all this, I upload to my website and manually make some snapshots and write a title. I then post on r/newjersey. 
