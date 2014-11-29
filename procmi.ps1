# Iterate through arguments
foreach($i in $input)
{
    $name = $(get-process -id $i |sort vm | select name,vm).Name
    $virtualMemory = (write-output $(get-process -id $i |sort vm | select name,vm).VM  | .\human-readable-bytes.ps1)
    $workingSet = (write-output $(get-process -id $i).WorkingSet | .\human-readable-bytes.ps1)
   
    $out = "******** Minne info om prosess med PID $i *********"
    $out += ([Environment]::NewLine)
    $out += "Total bruk av virtuelt minne: $virtualMemory"
    $out += ([Environment]::NewLine)
    $out += "Størrelse på Working Set: $workingSet"
    
    $filename = "$i--$(Get-Date -format yyyyMMdd-HHmmss).meminfo"
    
    write-output $out | out-file $filename
    
    
}