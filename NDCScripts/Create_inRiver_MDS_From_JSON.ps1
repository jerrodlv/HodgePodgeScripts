<#
Author: Jerrod LaVassor

This script requires the import-excel module to be installed in order to save results to an excel file (multiple worksheets)
Install-Module -Name ImportExcel     Needs to run as admin


TO DO
 Gather input arguments to get file source and destination output
#>

$SourceFilePath = "C:\Users\getch\Downloads\export_srsdistribution_dev.json"
$SourceJSON = Get-Content $SourceFilePath  -Raw | ConvertFrom-Json

#iterate through all of the JSON objects and put them into posh objects before export

#ServerSettings
$ServerSettings = $SourceJSON | Select-Object -Expand ServerSettings
$ServerSettings | Get-Member -MemberType NoteProperty | `
    Select-Object @{name='Name';expression={$_.name}}, `
                  @{name='Value';expression={$ServerSettings.($_.name)}} `
 | Export-Excel -Path "C:\Users\getch\Downloads\test.xlsx" -WorksheetName "ServerSettings"

 # Categories __NOT DONE
$Categories = $SourceJSON | Select-Object -Expand Categories |  Select-Object -Expand Name | Select-Object -Expand stringMap `
    foreach {
        $_.en = $_.en -join ' ' `
    }
    Select-Object @{name='Name';expression={$_.name}}, `
                  @{name='Value';expression={$Categories.($_.name)}} `
 | Export-Excel -Path "C:\Users\getch\Downloads\test.xlsx" -WorksheetName "Categories"



#Entity Type parsing
 $EntityTypes =  $SourceJSON | Select-Object -Expand EntityTypes
    ForEach ($ID in $EntityTypes) {     
       $ID | Select-Object -Expand FieldTypes 
       $ID | Get-Member -MemberType NoteProperty
    }

