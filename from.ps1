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
$ouPathBox.Add_TextChanged({RequireFields})
$form.Controls.Add($ouPathBox)


#outbox
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()