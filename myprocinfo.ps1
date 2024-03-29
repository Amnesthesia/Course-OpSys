$stats = get-wmiobject -class "Win32_PerfFormattedData_PerfOS_System" -computer .

function whoami
{
  $file = Get-ChildItem $MyInvocation.ScriptName
  write-host "Hi I'm" $file.Name
}

function uptime
{
    $lastBootTime = (Get-WmiObject -Class Win32_OperatingSystem -computername localhost).LastBootUpTime
    $systemUpTime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($lastBootTime)
    
    write-host "Uptime since last boot: " $systemUpTime.days "days " $systemUpTime.hours "hours " $systemUpTime.minutes "minutes" $systemUpTime.seconds "seconds"
}

function nProcThreads
{
    $processes = get-process | measure
    $threads = get-process | %{$_.Name;$_.Threads | %{"`t{0}" -f $_.ID}} | measure
    
    write-host "Currently," $processes.Count "processes running with" $threads.Count "threads"
}

function nContextSwitchesLastSec
{
    write-host "Context switches per second:" $stats.ContextSwitchesPersec.tostring("###,##.0.0")
}

function cpuModeUsage
{
    # Okay seriously this is just ridiculous -- counters have _language specific_ names?
    # Apparently, since I made the mistake of installing Winblow$ in my native language,
    # counters aren't named in english. What incompetent software clown came up with this craptastic idea?
    $privilegedTime = $($(Get-Counter -Counter "\Processor(_Total)\privilegierad tid i procent" -SampleInterval 1 -MaxSamples 1).countersamples).cookedvalue
    $userTime = $($(Get-Counter -Counter "\Processor(_Total)\användartid i procent" -SampleInterval 1 -MaxSamples 1).countersamples).cookedvalue
    #$privilegedTime = $($(Get-Counter -Counter "\Processor(_Total)\%Privileged Time" -SampleInterval 1 -MaxSamples 1).countersamples).cookedvalue
    #$userTime = $($(Get-Counter -Counter "\Processor(_Total)\%User Time" -SampleInterval 1 -MaxSamples 1).countersamples).cookedvalue
    write-host $privilegedTime "% of time in kernel mode"
    write-host $userTime "% of time in user mode"
}

function nInterruptsLastSec
{
    # write-host $($(Get-Counter -Counter "\Processor(_Total)\interrupts/sec" -SampleInterval 1 -MaxSamples 1).countersamples).cookedvalue "interrupts per second"
    write-host $($(Get-Counter -Counter "\Processor(_Total)\avbrott per sekund" -SampleInterval 1 -MaxSamples 1).countersamples).cookedvalue "interrupts per second"
}



# Set up array with all options
$menuOptions = @("What's the name of this script?", "How long since last boot?", "How many threads and processes are running?", "How many context switches per second?", "How much time has the CPU spent in kernel/user mode per second?","How many interrupts per second?", "Exit")
# And keep count for listing
$menuCount = 1

write-host "What I don't understand is why anybody who misses the terminal on Windows so much they use PowerShell, is still using Windows?"

# List all options in array
foreach($menuOption in $menuOptions)
{
    write-host $menuCount "-" $menuOption
    
    # And increase count. Increase by two if its the last one.
    $menuCount++
    if($menuCount -eq $menuOptions.Count)
    {
        $menuCount = $menuCount + 2
    }
}

switch(read-host "wat do: ")
{
    1{ whoami }
    2{ uptime }
    3{ nProcThreads }
    4{ nContextSwitchesLastSec }
    5{ cpuModeUsage }
    6{ nInterruptsLastSec }
    9{ exit }
}

