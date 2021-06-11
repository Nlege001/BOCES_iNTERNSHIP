Import-Module ActiveDirectory
# Set amount of time in days to determine inactivity then subtract that from current days date
$daysinactive = 90
$time = (Get-Date).Adddays(-($daysinactive))

# Scan AD for computers but filter to only show computers older than inactivity date
# Set disabled OU path to be used later
$ad = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Searchbase "OU=_Workstations,DC=fpcsd,DC=local" -Properties *
$disabledou = "OU=Disabled Computers,DC=fpcsd,DC=local"

# Log newly disabled computers to file
$log = "C:\Users\gabriel.cirtwell\Desktop\disable_computers.log"

foreach($c in $ad)
{
    # Set description of when device was disabled
    # Move computer to disabled OU and disable
    Set-ADComputer $($c.Name) -Description "Disabled on $(Get-Date -Format "MM/dd/yyy") due to inactivity"
    Move-ADObject -Identity $($c.DistinguishedName) -TargetPath $disabledou 
    Disable-ADAccount -Identity $($c.sAMAccountName)
    #write-host $($c.Name)

    # Capture actions in log file
    Add-Content $log -Value "Computer:  $($c.Name) moved & disabled on $(Get-Date -Format "MM/dd/yyy")"
}