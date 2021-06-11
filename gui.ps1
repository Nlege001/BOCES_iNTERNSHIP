Add-Type -AssemblyName System.Windows.Forms  # Adds the Forms functions to script
Add-Type -AssemblyName System.Drawing 

$form = New-Object System.Windows.Forms.Form # New object to declare form to variable
$form.Text = 'Disable form'         # Form title
$form.Width = 485                            # Form width
$form.Height = 280                           # Form height
$form.AutoSize = $false                      # Prevent form from auto resizing
$form.FormBorderStyle='Fixed3D'         