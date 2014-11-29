# If full path, save. Else, append path of current working dir
if($args[0] -Match "\\")
{
   $dir = $args[0]
}
else
{
   $dir = $MyInvocation.MyCommand.Path | split-path
   $dir += "\$args"
}

$disk = $dir | split-path
$disk = $disk[0]
$disk += ":"
write-host $disk

write-host "Directory $dir"
$space = Get-WmiObject Win32_LogicalDisk -ComputerName localhost -Filter "DeviceID='$disk'" | Select-Object Size,FreeSpace
$used = 100-(100/($space.Size/$space.FreeSpace))

$files = (get-childitem .\Adobe -rec |where {!$_PSIsContainer} | select-object FullName, Length | sort Length -Descending)

$fileStats = ($files | measure Length -ave -max -min)
$largestFile = $files[0].FullName
$largestFileSize = (write-output $files[0].Length | .\human-readable-bytes.ps1)
$averageFileSize = (write-output $fileStats.Average | .\human-readable-bytes.ps1)


write-host "Partisjonen $args befinner seg på er $used% full"
write-host "Det finnes "($fileStats.Count)" filer."
write-host "Den største er $largestFile som er $largestFileSize stor"
write-host "Gjennomsnittlig filstørrelse er $averageFileSize"


