# Get the last provided argument
foreach($i in $input)
{
    $num = $i
}

# Otherwise request input
if([string]::IsNullOrEmpty($num))
{
    $num = read-host
}

if($num -lt [math]::pow(2,10))
{
    write-output $num"B"
}
elseif($num -lt [math]::pow(2,20))
{
    write-output ([math]::round(($num/[math]::pow(2,10)),2))"KB"
}
elseif($num -lt [math]::pow(2,30))
{
    write-output ([math]::round(($num/[math]::pow(2,20)),2))"MB"
}
elseif($num -lt [math]::pow(2,40))
{
    write-output ([math]::round(($num/[math]::pow(2,30)),2))"GB"
}
