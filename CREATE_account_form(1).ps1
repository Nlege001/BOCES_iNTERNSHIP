Add-Type -AssemblyName System.Windows.Forms  # Adds the Forms functions to script
Add-Type -AssemblyName System.Drawing        # Adds the Drawing functions (Size/Location) to script

##### CREATE FORM #####
$form = New-Object System.Windows.Forms.Form # New object to declare form to variable
$form.Text = 'User Account Creation'         # Form title
$form.Width = 485                            # Form width
$form.Height = 280                           # Form height
$form.AutoSize = $false                      # Prevent form from auto resizing
$form.FormBorderStyle='Fixed3D'              # Prevents users from resizing form manually

##### FIRST ROW #####
$fnlabel = New-Object System.Windows.Forms.Label
$fnlabel.Text = "First Name:"
$fnlabel.Location = New-Object System.Drawing.Point(10,20)
$fnlabel.AutoSize = $true
$form.Controls.Add($fnlabel)

$fntextbox = New-Object System.Windows.Forms.TextBox
$fntextbox.Location = New-Object System.Drawing.Point(75,17)
$fntextbox.Size = New-Object System.Drawing.Size(150,20)
$fntextbox.Add_TextChanged({RequiredFields})
$form.Controls.Add($fntextbox)

$lnlabel = New-Object System.Windows.Forms.Label
$lnlabel.Text = "Last Name:"
$lnlabel.Location = New-Object System.Drawing.Point(240,20)
$lnlabel.AutoSize = $true
$form.Controls.Add($lnlabel)

$lntextbox = New-Object System.Windows.Forms.TextBox
$lntextbox.Location = New-Object System.Drawing.Point(305,17)
$lntextbox.Size = New-Object System.Drawing.Size(150,20)
$lntextbox.Add_TextChanged({RequiredFields})
$form.Controls.Add($lntextbox)

##### SECOND ROW #####
$userlabel = New-Object System.Windows.Forms.Label
$userlabel.Text = "Username:"
$userlabel.Location = New-Object System.Drawing.Point(10,60)
$userlabel.AutoSize = $true
$form.Controls.Add($userlabel)

$usertextbox = New-Object System.Windows.Forms.TextBox
$usertextbox.Location = New-Object System.Drawing.Point(70,57)
$usertextbox.Size = New-Object System.Drawing.Size(200,20)
$usertextbox.Add_TextChanged({RequiredFields})
$form.Controls.Add($usertextbox)

$usercheckbox = New-Object System.Windows.Forms.CheckBox
$usercheckbox.Text = "Fill User"
$usercheckbox.Location = New-Object System.Drawing.Point(305,57)
$usercheckbox.AutoSize = $true
$usercheckbox.Add_Click({FillUserCheckBox_Click})
$form.Controls.Add($usercheckbox)

$adcheckbox = New-Object System.Windows.Forms.CheckBox
$adcheckbox.Text = "AD Only"
$adcheckbox.Location = New-Object System.Drawing.Point(385,57)
$adcheckbox.AutoSize = $true
$adcheckbox.Add_Click({ADOnlyCheckbox_Click})
$form.Controls.Add($adcheckbox)

##### THIRD ROW #####
$pagerlabel = New-Object System.Windows.Forms.Label
$pagerlabel.Text = "Pager:"
$pagerlabel.Location = New-Object System.Drawing.Point(10,100)
$pagerlabel.AutoSize = $true
$form.Controls.Add($pagerlabel)

$pagertextbox = New-Object System.Windows.Forms.TextBox
$pagertextbox.Location = New-Object System.Drawing.Point(50,98)
$pagertextbox.Size = New-Object System.Drawing.Size(100,20)
$pagertextbox.Add_TextChanged({RequiredFields})
$form.Controls.Add($pagertextbox)

$emailcheckbox = New-Object System.Windows.Forms.CheckBox
$emailcheckbox.Text = "Fill Email"
$emailcheckbox.Location = New-Object System.Drawing.Point(170,98)
$emailcheckbox.AutoSize = $true
$emailcheckbox.Add_Click({FillEmail_Click})
$form.Controls.Add($emailcheckbox)

$emaillabel = New-Object System.Windows.Forms.Label
$emaillabel.Text = "Email:"
$emaillabel.Location = New-Object System.Drawing.Point(250,100)
$emaillabel.AutoSize = $true
$form.Controls.Add($emaillabel)

$emailtextbox = New-Object System.Windows.Forms.TextBox
$emailtextbox.Location = New-Object System.Drawing.Point(290,98)
$emailtextbox.Size = New-Object System.Drawing.Size(165,20)
$form.Controls.Add($emailtextbox)

##### FOURTH ROW #####
$roleslabel = New-Object System.Windows.Forms.Label
$roleslabel.Text = "Roles:"
$roleslabel.Location = New-Object System.Drawing.Point(10,140)
$roleslabel.AutoSize = $true
$form.Controls.Add($roleslabel)

$rolescombobox = New-Object System.Windows.Forms.ComboBox
$rolescombobox.Location = New-Object System.Drawing.Point(50,138)
$rolescombobox.Size = New-Object System.Drawing.Size(160,20)
$rolescombobox.Items.Add("Admin")
$rolescombobox.Items.Add("Board Member")
$rolescombobox.Items.Add("Outside Contracter")
$rolescombobox.Items.Add("Service Account")
$rolescombobox.Items.Add("Student")
$rolescombobox.Items.Add("Support Staff")
$rolescombobox.Items.Add("Teacher")
$rolescombobox.Add_SelectedValueChanged( 
{
    if($rolescombobox.Text -eq "Admin")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=Admins,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u) }
    }
    if($rolescombobox.Text -eq "Board Member")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=BoardMembers,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u) }
    }
    if($rolescombobox.Text -eq "Outside Contracter")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=OutsideContracters,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u)}
    }
    if($rolescombobox.Text -eq "Service Account")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=ServiceAccounts,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u) }
    }
    if($rolescombobox.Text -eq "Student")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=Students,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u) }
    }
    if($rolescombobox.Text -eq "Support Staff")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=Support Staff,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u) }
    }
    if($rolescombobox.Text -eq "Teacher")
    {
        $suboucombobox.Items.Clear()
        $ou = Get-ADOrganizationalUnit -SearchBase "OU=Teachers,OU=_UserAccounts,DC=fpcsd,DC=local" -SearchScope Subtree -Filter * | Select-Object Name
        foreach($u in $ou) { $suboucombobox.Items.Add($u) }
    }
})
$form.Controls.Add($rolescombobox)

$suboulabel = New-Object System.Windows.Forms.Label
$suboulabel.Location = New-Object System.Drawing.Point(220,140)
$suboulabel.Text = "Sub OU:"
$suboulabel.AutoSize = $true
$form.Controls.Add($suboulabel)

$suboucombobox = New-Object System.Windows.Forms.ComboBox
$suboucombobox.Location = New-Object System.Drawing.Point(270,138)
$suboucombobox.Size = New-Object System.Drawing.Size(185,20)
$form.Controls.Add($suboucombobox)

##### FIFTH ROW #####
$filterlabel = New-Object System.Windows.Forms.Label
$filterlabel.Text = "Filter As:"
$filterlabel.Location = New-Object System.Drawing.Point(10,179)
$filterlabel.AutoSize = $true
$form.Controls.Add($filterlabel)

$filtercombobox = New-Object System.Windows.Forms.ComboBox
$filtercombobox.Location = New-Object System.Drawing.Point(60,176)
$filtercombobox.AutoSize = $true
$filtercombobox.Items.Add("Student")
$filtercombobox.Items.Add("Faculty/Staff")
$filtercombobox.Items.Add("Administration")
$filtercombobox.Add_SelectedValueChanged({RequiredFields})
$form.Controls.Add($filtercombobox)

##### BUTTONS #####
$createbutton = New-Object System.Windows.Forms.Button            # Creates new button
$createbutton.Location = New-Object System.Drawing.Point(215,200) # Button location
$createbutton.Size = New-Object System.Drawing.Size(70,30)        # Button size
$createbutton.Text = "CREATE"                                     # Button text
$createbutton.Enabled = $false                                    # Disables Create button if fields are empty
$form.Controls.Add($createbutton)                                 # Adds create button to form

$clearbutton = New-Object System.Windows.Forms.Button            # Creates new button
$clearbutton.Location = New-Object System.Drawing.Point(300,200) # Button location
$clearbutton.Size = New-Object System.Drawing.Size(70,30)        # Button size
$clearbutton.Text = "CLEAR"                                      # Button text
$clearbutton.Add_Click{$fntextbox.Clear()}                       # Clears First Name textbox
$clearbutton.Add_Click{$lntextbox.Clear()}                       # Clears Last Name textbox
$clearbutton.Add_Click{$pagertextbox.Clear()}                    # Clears Pager textbox
$clearbutton.Add_Click{$usercheckbox.Checked = $false}           # Clears Fill User checkbox
$clearbutton.Add_Click{$adcheckbox.Checked = $false}             # Clears AD Only checkbox
$clearbutton.Add_Click{$emailcheckbox.Checked = $false}          # Clears Fill Email checkbox
$clearbutton.Add_Click{$emailtextbox.Clear()}                    # Clears Email textbox
$clearbutton.Add_Click{$emaillabel.Enabled = $true}              # Enables Email Label
$clearbutton.Add_Click{$emailtextbox.Enabled = $true}            # Enables Email Textbox
$clearbutton.Add_Click{$emailcheckbox.Enabled = $true}           # Enables Email Checkbox
$clearbutton.Add_Click{$buildingcombobox.SelectedIndex = -1}     # Nulls buidling selection
$clearbutton.Add_Click{$suboucombobox.SelectedIndex = -1}        # Nulls OU selection
$clearbutton.Add_Click{$studentcheckbox.Checked = $false}        # Clears "is student" checkbox
$clearbutton.Add_Click{$filtercombobox.SelectedIndex = -1}       # Nulls Filter selection
$createbutton.Enabled = $false                                   # Disables Create button if fields are empty
$form.Controls.Add($clearbutton)                                 # Adds clear button to form

$cancelbutton = New-Object System.Windows.Forms.Button            # Creates new button
$cancelbutton.Location = New-Object System.Drawing.Point(385,200) # Button location
$cancelbutton.Size = New-Object System.Drawing.Size(70,30)        # Button size
$cancelbutton.Text = "CANCEL"                                     # Button text
$form.CancelButton = $cancelbutton                                # Creates form cancel function to button
$form.Controls.Add($cancelbutton)                                 # Adds cancel button to form

##### FUNCTIONS #####
Function RequiredFields()
{
    if(($fntextbox.Text.Length -ne 0) -and ($lntextbox.Text.Length -ne 0) -and ($usertextbox.Text.Length -ne 0) -and ($pagertextbox.Text.Length -ne 0) -and (!($filtercombobox.SelectedIndex -eq -1)))
    { $createbutton.Enabled = $true }
    else{ $createbutton.Enabled = $false}
}

Function FillUserCheckBox_Click()
{
    if($usercheckbox.Checked -eq $true){ $usertextbox.Text = "$($fntextbox.Text).$($lntextbox.Text)"}
    else { $usertextbox.Clear() }
}

Function ADOnlyCheckbox_Click()
{
    if($adcheckbox.Checked -eq $true)
    { 
        $emailcheckbox.Enabled = $false # Disables the Email fill checkbox
        $emailcheckbox.Checked = $false # Unchecks the email fill checkbox
        $emaillabel.Enabled = $false    # Disables the email label
        $emailtextbox.Clear()           # Clears the email textbox
        $emailtextbox.Enabled = $false  # Disables the email textbox
    }
    else 
    {
        $emailcheckbox.Enabled = $true  # Re-enables the email checkbox
        $emaillabel.Enabled = $true     # Re-enables the email label
        $emailtextbox.Enabled = $true   # Re-enables the email textbox
    }
}

Function FillEmail_Click()
{
    if($emailcheckbox.Checked -eq $true){ $emailtextbox.Text = "$($usertextbox.Text)@fortplain.org" }
    else { $emailtextbox.Clear() }
}

##### ACTIVATE + SHOW FORM #####
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()