# Capital Region BOCES Internship
![Software engineering intern](https://github.com/Nlege001/BOCES_iNTERNSHIP/blob/source-codes/Untitled%20design-6.png)

## Software Engineering Internship


This repository consists of the code I wrote and the source code that was provided. I was able to create a program that manages and control the accounts of students. Given the right OU (Organizational unit i.e n form of a path) and a log of whhere the data should be stored, the program will disable old accounts(accounts that have been inactive or accounts of students that have graduated) and will store the information and time stap in the log.



## Languages used
    - 🔌 Powershell
    - 🐍 Python

## Code and explanation


```powershell
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
```


    
## Snippet of GUI
<img src="https://github.com/Nlege001/BOCES_iNTERNSHIP/blob/main/disbalecomputers.jpg" width= 500/>
