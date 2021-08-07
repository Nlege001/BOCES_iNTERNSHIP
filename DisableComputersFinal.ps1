#Loading Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


#Creating form

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Disable Computers'
$form.Width = 485
$form.Height = 280
$form.AutoSize = $true

#*********************First Row(Inactive days)*********************** 
$daysCount = New-Object System.Windows.Forms.Label
$daysCount.Text = 'Number of days inactive'
$daysCount.Location = New-Object System.Drawing.Point(10,20)
$daysCount.AutoSize = $true
$form.Controls.Add($daysCount)

$daysCountBox = New-Object System.Windows.Forms.TextBox
$daysCountBox.Location = New-Object System.Drawing.Point(150,17)
$daysCountBox.Size = New-Object System.Drawing.Size(100,20)
$daysCountBox.Text = '(numbers only)'
$daysCountBox.Add_TextChanged({RequiredFields})
$form.Controls.Add($daysCountBox)

#**********************Second Row(OU path to be scanned****************
$ouPath = New-Object System.Windows.Forms.Label
$ouPath.Text = 'OU path to be scanned'
$ouPath.Location = New-Object System.Drawing.Point(10,60)
$ouPath.AutoSize = $true
$form.Controls.Add($ouPath)

$ouPathBox = New-Object System.Windows.Forms.TextBox
$ouPathBox.Location = New-Object System.Drawing.Point(150,60)
$ouPathBox.Size = New-Object System.Drawing.Size(300,20)
$ouPathBox.Text = '(Example: "OU=_Workstations,DC=fpcsd,DC=local")'
$ouPathBox.Add_TextChanged({RequiredFields})
$form.Controls.Add($ouPathBox)

#********************third row(log path)************************
$logPath = New-Object System.Windows.Forms.Label
$logPath.Text = 'Log path'
$logPath.Location = New-Object System.Drawing.point(10,100)
$logPath.AutoSize = $true
$form.Controls.Add($logPath)

$logPathBox = New-Object System.Windows.Forms.TextBox
$logPathBox.Location = New-Object System.Drawing.Point(150,100)
$logPathBox.Size = New-Object System.Drawing.Size(300,20)
$logPathBox.Text = '(path of where you want to store a log of disabled computers)'
$logPathBox.Add_TextChanged({RequiredFields})
$form.Controls.Add($logPathBox)

#creating buttons

$createRunButton = New-Object System.Windows.Forms.Button
$createRunButton.Location = New-Object System.Drawing.Point(115,200)
$createRunButton.Size = New-Object System.Drawing.Size(70,30)
$createRunButton.Text = 'RUN'
$createRunButton.Add_Click{DisableComputers}
$createRunButton.Enabled = $false
$form.Controls.Add($createRunButton)

$createClearButton = New-Object System.Windows.Forms.Button
$createClearButton.Location = New-Object System.Drawing.Point(315,200)
$createClearButton.Size = New-Object System.Drawing.Size(70,30)
$createClearButton.Text = 'CLEAR'
$createClearButton.Add_Click{$daysCountBox.Clear()}
$createClearButton.Add_Click{$ouPathBox.Clear()}
$createClearButton.Add_Click{$logPathBox.Clear()}
$createClearButton.Enabled = $false
$form.Controls.Add($createClearButton)






# functions
Function RequiredFields()
{
if(($daysCountBox.Text.Length -ne 0) -and ($ouPathBox.Text.Length -ne 0) -and ($logPathBox.Text.Length -ne 0))
{
$createClearButton.Enabled = $true
$createRunButton.Enabled = $true
}
}

Function DisableComputers()
{
 $time =(Get-Date).AddDays(-($daysCountBox.Text))
 $ad = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Searchbase $ouPathBox.Text -Properties *
 
 foreach($c in $ad)
 {
   Move-ADObject -Identity $($c.DistinguishedName) -TargetPath $ouPathBox.Text
   Disable-ADAccount -Identity $($c.sAMccountName)
   Add-Content $logPathBox.Text -Value *Computer: $($c.Name) was moved and disabled on $(Get-Date -Format "MM/dd/yy")
 }
}





#outbox
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()