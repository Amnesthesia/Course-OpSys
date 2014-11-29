# Get the last provided argument
foreach($i in $input)
{
    $num = $i
}

if([string]::IsNullOrEmpty($num))
{
    $num = read-host
}

if($num -lt [math]::pow(10,3))
{
    write-output $num "ns"
}
elseif($num -lt [math]::pow(10,6))
{
    write-output ([math]::round(($num/[math]::pow(10,3)),2))"µs"
}
elseif($num -lt [math]::pow(10,9))
{
    write-output ([math]::round(($num/[math]::pow(10,6)),2))"ms"
}
else
{
    write-output ([math]::round(($num/[math]::pow(10,9)),2))"seconds"
}
