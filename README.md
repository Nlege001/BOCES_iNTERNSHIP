# Capital Region BOCES Internship
![Software engineering intern](https://github.com/Nlege001/BOCES_iNTERNSHIP/blob/source-codes/Untitled%20design-6.png)

# Software Engineering Internship

## Table of contents
- [Introduction](#x)
- [Languages used](#y)
- [Use case and Story](#z)
- [Code Snippet](#a)
- [Snippet of GUI](#b)


<div name = 'x'/>

## Introduction



This repository consists of the code I wrote and the source code that was provided. I was able to create a program that manages and control the accounts of students. Given the right OU (Organizational unit i.e n form of a path) and a log of whhere the data should be stored, the program will disable old accounts(accounts that have been inactive or accounts of students that have graduated) and will store the information and time stap in the log.

<div name = 'y'/>

## Languages used
    - 🔌 Powershell
    - 🐍 Python

<div name = 'z'/>

## Use cases and story
- Sometimes students might graduate and leave, and also in other cases there might be accounts that haven't been used for a while. 
- These accounts are stored in Organizational Units(OUs). We will provide this program a specific organizational unit, a time frame(so that we can identify accounts that haven't been used for a while as obsolete) and also a log path so that we can store the data.
- The function showed in the ```code``` section below completed the above described process
- Once we have done this, we will press the button ```Run```, which will execute the code. Old accounts that haven't been inactive will be disabled, and the dsiabled accounts will be stored in a log. 


<div name = 'a'/>

## Code


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

<div name = 'b'/>
    
## Snippet of GUI
<img src="https://github.com/Nlege001/BOCES_iNTERNSHIP/blob/main/disbalecomputers.jpg" width= 500/>
