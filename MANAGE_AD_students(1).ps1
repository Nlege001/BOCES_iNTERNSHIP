############### DECLARATION OF GLOBAL VARIABLES ###############
# Import AD module and create variable to hold users in AD
Import-Module ActiveDirectory
$ad = Get-ADUser -Filter * -SearchBase "OU=Students,OU=_UserAccounts,DC=fpcsd,DC=local" -Properties *

# Import CSV file from eSchool and the Mod file that will be used after the first function
$eSchool = Import-Csv C:\Exports\eSchool.csv

# LOG FILES
$logyear = "H:\PS Scripts\TEST\LOG_year.log"
$logou = "H:\PS Scripts\TEST\LOG_ou_check.log"
$logcompare = "H:\PS Scripts\TEST\LOG_compare.log"
$logcreate = "H:\PS Scripts\TEST\LOG_create.log"
$loggroups = "H:\PS Scripts\TEST\LOG_groups.log"

# Variables for the Root OU and the Disabled OU
$rou = "OU=Students,OU=_UserAccounts,DC=fpcsd,DC=local"
$dou = "OU=Disabled,OU=Students,OU=_UserAccounts,DC=fpcsd,DC=local"

# Variables to hold AD groups and members in those groups
$filterGroup = "M86 Students"
$filterGroupMem = Get-ADGroupMember -Identity $filterGroup -Recursive | Select -ExpandProperty Name
$esGroup = "HH Students"
$esGroupMem = Get-ADGroupMember -Identity $esGroup -Recursive | Select -ExpandProperty Name
$hsGroup = "HS Students"
$hsGroupMem = Get-ADGroupMember -Identity $hsGroup -Recursive | Select -ExpandProperty Name

############### END OF GLOBAL VAIABLE DECLARATION ###############



############### DECLARATION OF ESCHOOL FUNCTION ###############
function ModifyeSchoolData
{
    foreach($e in $eSchool)
    {
        # Create the full OU column.  Sets Value to the Grade level
        Add-Member -Input $e -MemberType NoteProperty -Name 'OU' -Value $e."Grade Level"

        # Create the class of OU column.  Sets Value to the Grade level
        Add-Member -Input $e -MemberType NoteProperty -Name 'Class Of' -Value $e."Grade Level"

        # Create the Description column.  Sets Value to the Grade level
        Add-Member -Input $e -MemberType NoteProperty -Name 'Description' -Value $e."Grade Level"

        # Create the Email column.  Sets Value to the Grade level
        Add-Member -Input $e -MemberType NoteProperty -Name 'Email' -Value "$($e.'Student ID')@fortplain.org"

        # Test if the graduation year is not set
        # This is important because the OU's rely on the graduation year
        if([string]::IsNullOrEmpty($e."Projected Graduation Year"))
        {
            # Graduation year not set.  Add to content log
            Add-Content $logyear -Value "SET year for $($e.'Student ID'), $($e.'First Name') $($e.'Last Name')"
            # Check what the grade level is then set grad year variable to incremented four digit year
            if($e."Grade Level" -eq "12") { $gy = Get-Date -UFormat %Y}
            elseif($e."Grade Level" -eq "11") { $gy = (Get-Date).AddYears(1) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "10") { $gy = (Get-Date).AddYears(2) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "9") { $gy = (Get-Date).AddYears(3) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "8") { $gy = (Get-Date).AddYears(4) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "7") { $gy = (Get-Date).AddYears(5) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "6") { $gy = (Get-Date).AddYears(6) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "5") { $gy = (Get-Date).AddYears(7) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "4") { $gy = (Get-Date).AddYears(8) | Get-Date -UFormat %Y }
            elseif($e."Grade Level" -eq "3") { $gy = (Get-Date).AddYears(9) | Get-Date -UFormat %Y }
        }
        else 
        {
            # Variable to hold the graduation year.
            # not necessary because we can do $($e."Projected Graduation Year") but saves space later
            $gy = $e."Projected Graduation Year"
        }

        # Variable to hold last two digits of calendar year "small year"
        # Create the Password column.  Sets Value
        $Year = Get-Date -UFormat %y
        Add-Member -Input $e -MemberType NoteProperty -Name 'Password' -Value "NewStu$Year"

        # Modify required columns with switch statements
        # Modify the Class Of column to CO + grad year variable
        Switch($e."Class Of")
        {
            12 { $e."Class Of" = "CO$gy" }
            11 { $e."Class Of" = "CO$gy" }
            10 { $e."Class Of" = "CO$gy" }
            9 { $e."Class Of" = "CO$gy" }
            8 { $e."Class Of" = "CO$gy" }
            7 { $e."Class Of" = "CO$gy" }
            6 { $e."Class Of" = "CO$gy" }
            5 { $e."Class Of" = "CO$gy" }
            4 { $e."Class Of" = "CO$gy" }
            3 { $e."Class Of" = "CO$gy" }
        } # End of Class of Switch statement

        # Modify the Description column to Class of + grad year variable
        Switch($e."Description")
        {
            12 { $e."Description" = "Class of $gy" }
            11 { $e."Description" = "Class of $gy" }
            10 { $e."Description" = "Class of $gy" }
            9 { $e."Description" = "Class of $gy" }
            8 { $e."Description" = "Class of $gy" }
            7 { $e."Description" = "Class of $gy" }
            6 { $e."Description" = "Class of $gy" }
            5 { $e."Description" = "Class of $gy" }
            4 { $e."Description" = "Class of $gy" }
            3 { $e."Description" = "Class of $gy" }
        } # End of Description Switch statement

        # Modify the OU column to CO + grad year variable + root ou variable
        Switch($e."OU")
        {
            12 { $e."OU" = "OU=CO$gy,$rou" }
            11 { $e."OU" = "OU=CO$gy,$rou" }
            10 { $e."OU" = "OU=CO$gy,$rou" }
            9 { $e."OU" = "OU=CO$gy,$rou" }
            8 { $e."OU" = "OU=CO$gy,$rou" }
            7 { $e."OU" = "OU=CO$gy,$rou" }
            6 { $e."OU" = "OU=CO$gy,$rou" }
            5 { $e."OU" = "OU=CO$gy,$rou" }
            4 { $e."OU" = "OU=CO$gy,$rou" }
            3 { $e."OU" = "OU=CO$gy,$rou" }
        } # End of OU Switch statement
    } # End of foreach

    # Exports as a new CSV file
    $eSchool | Export-Csv 'C:\Exports\eSchoolMod.csv' -Delimiter ',' -NoTypeInformation
} # End of ModifyeSchoolData function
############### END OF ESCHOOL FUNCTION ###############



############### DECLARATION OF CHECKOU FUNCTION ###############
function CheckOU
{
    foreach($e in $eSchoolMod)
    {
        # Error checking to see if the OU does NOT exist
        # Creates OU if it does not exist
        #$OUcheck = [ADSI]::Exists("LDAP://$OU")

        if(!([ADSI]::Exists("LDAP://$($e.OU)")))
        {
            # Writes out what OU does not exist then creates it
            Add-Content $logou -Value "OU - $($e.OU) does not exist - creating for $($e.'Student ID')"
            New-ADOrganizationalUnit -Name $($e.'Class of') -Path $rou
        }
        else { <# OU exists. Do nothing#> } # End of if statment 
    } # End of foreach
} # End of CheckOU function
############### END OF CHECKOU FUNCTION ###############



############### DECLARATION OF COMPARE FUNCTION ###############
function CompareADtoCSV
{
    foreach($u in $ad)
    {
        # Check to see if user account is in eSchool
        if($eSchoolMod.'Student ID' -contains $($u.SamAccountName))
        {
            # Account is in eSchool.  check if enabled, if not then enable
            if( Get-ADUser -Identity $($u.SamAccountName) | where {$_.Enabled -eq $false})
            {
                # Account not enabled, enable it
                Add-Content $logcompare -Value "ENABLE - $($u.SamAccountName), $($u.DisplayName)"
                Set-ADUser -Identity $($u.SamAccountName) -Enabled $true
            } 
            else { <# Account exists and is enabled. Do nothing #> } # End of if
        } 
        else
        {
            # Check if account is already in the Disabled folder - no need to write about it
            if(!($u.DistinguishedName -like "*Disabled*"))
            {
                # Account not in eSchool.  Disable and move
                Add-Content $logcompare -Value "DISABLE - $($u.SamAccountName) & move to $dou"
                #Get-ADUser -Identity $($u.SamAccountName) | Set-ADUser -Enabled $false
                #Move-ADObject -Identity $($u.DistinguishedName) -TargetPath $dou
            }
            else{ }
        } # End of if

    } # End of foreach
} # End of Compare function
############### END OF COMPARE FUNCTION ###############



############### DECLARATION OF CREATE FUNCTION ###############
function CreateStudents
{
    foreach($e in $eSchoolMod)
    {
        if(($ad.SamAccountName -contains $e.'Student ID') -and ($ad.Enabled -eq $True)) 
        {
            # student exists and is enabled.  Validate data against AD
            # Account Exists and is enabled at this point
            # Variable to get info from AD to validate against CSV
            $adinfo = Get-ADUser -Identity $e.'Student ID' -Properties *

            # Variable to hold complete OU path from CSV
            $csvDN = "CN=$($e.'First Name') $($e.'Last Name'),$($e.'OU')"

            # Run if statement against common attributes at once.
            # If one of the attributes are incorrect, reset them all
            if(($adinfo.GivenName -eq $e.'First Name') -and ($adinfo.SurName -eq $e.'Last Name') -and ($adinfo.EmailAddress -eq $e.'Email') )
            { <# All common attributes are correct.  Do nothing #> }
            else
            {
                # One of the common attributes is incorrect.  reset first name, last name, and email
                Add-Content $logcompare -value "UPDATE - $($e.'Student ID') attributes"
                Set-ADUser -Identity $($e.'Student ID') -GivenName $($e.'First Name') -Surname $($e.'Last Name') -EmailAddress $($e.'Email')
            } # End of if statement

            # Run if statement to ensure the user is in the correct OU
            if($adinfo.DistinguishedName -eq $csvDN) { <# Account in correct OU. Do nothing #>}
            else 
            { 
                # Account is not in the correct OU.  Move it
                Add-Content $logcompare -Value "MOVE - $($e.'Student ID') to $($e.'OU')"
                # Move-ADObject -Identity $($e.'Student ID') -TargetPath $($e.'OU')
            } # End of if statement
        }
        else
        {
            Add-Content $logcreate -Value "CREATE - $($e.'Student ID'), $($e.'First Name') $($e.'Last Name'), $($e.'Email')"
            New-ADUser `
            -Name "$($e.'First Name') $($e.'Last Name')" `
            -SamAccountName $($e.'Student ID') `
            -UserPrincipalName $($e.'Student ID') `
            -GivenName $($e.'First Name') `
            -Surname $($e.'Last Name') `
            -Description $($e.'Description') `
            -DisplayName "$($e.'First Name') $($e.'Last Name')" `
            -Path $($e.'OU') `
            -EmailAddress $($e.'Email') `
            -AccountPassword (ConvertTo-SecureString $($e.Password) -AsPlainText -Force) -ChangePasswordAtLogon $true `
            -Enabled $true
        } # end of if statement

        # CHECK GROUP MEMBERSHIPS
        # Check if the account is not a member of the student content filter group
        # Variable to hold Display Name from CSV, this is how AD checks and manages groups
        $displayname = "$($e.'First Name') $($e.'Last Name')"
        if(!($filterGroupMem -contains $displayname))
        {
            # Account not in lightspeed group.  add them
            Add-Content $loggroups -Value "ADD - $($e.'Student ID') to $filterGroup"
            Add-ADGroupMember -Identity $filterGroup -Members $($e.'Student ID')
        }
        else { <# Account is in light speed group. Do nothing #>} # End of if statement

        # Check grade level of students for group memberships
        # checks if student grade level is in the elementary
        if([convert]::ToInt32($e.'Grade Level') -lt "7")
        {
            # If in elementary check if student is part of group
            if(!($esGroupMem -contains $displayname))
            {
                # Account not in elementary group.  Add them
                Add-Content $loggroups -Value "ADD - $($e.'Student ID') to $esGroup"
                Add-ADGroupMember -Identity $esGroup -Members $($e.'Student ID')
            }
            else { <# Account is in the elementary and in correct group. Do nothing#> } # End of if statement
        }
        else
        {
            # Check is account is still in the elementary group
            if($esGroupMem -contains $displayname)
            {
                # Account is still in the elementary group.  Remove it
                Add-Content $loggroups -Value "REMOVE - $($e.'Student ID') from $esGroup"
                Remove-ADGroupMember -Identity $esGroup -Members $($e.'Student ID') -Confirm:$false
            }
            else { <# Account is not in elementary group. do nothing#> }   # end of if statement
            # student is in the high school.  check group membership
            if(!($hsGroupMem -contains $displayname))
            {
                # Account not in high school group.  Add them
                Add-Content $loggroups -Value "ADD - $($e.'Student ID') to $hsGroup"
                Add-ADGroupMember -Identity $hsGroup -Members $($e.'Student ID')
            }
            else { <# Account is in the high school and in correct group. Do nothing#> } # End of if statement
        } # End of if statement

    } # End of foreach
} # End of CreateStudents function
############### DECLARATION OF CREATE FUNCTION ###############



############### CALL FUNCTIONS ###############
ModifyeSchoolData

# Import the modified eSchool file after it has been exported.
$eSchoolMod = Import-Csv C:\Exports\eSchoolMod.csv

CheckOU
CompareADtoCSV
CreateStudents
############### END OF CALL ###############