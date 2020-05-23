remove-item "*.csv"
remove-item "*.html"

& '.\split.ps1'
& '.\delta.ps1'