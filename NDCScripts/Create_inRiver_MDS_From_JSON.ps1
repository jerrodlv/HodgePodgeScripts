<#
Author: Jerrod LaVassor
Description: This script will take an inriver model export (JSON) and flatten it into an excel workbook, breaking things out into separate excel worksheets.
This was written in powershell version 5. It should work in any version after v5. It was not tested in versions before v5, but i think it should work in anything v3 or later...

This script requires these modules to be installed. if it's failing to isntall, run as elevated powershell (admin)
Install-Module -Name ImportExcel     
Install-Module -Name JoinModule

How to use
0. Make sure the above required modules are installed. The script will try to install them for the current user (no admin required). if it can't it will exit. 
0b. Install them manually if it fails...
1. Export the model JSON from the source inriver environment. I guess i could have written this to use API calls, but that seems harder. Export with  CVL values
2. Save the Model JSON somewhere that you can get to it. note the full path
3. WHen prompted enter that path into the command prompt. Use quotes if there are spaces or other special characters in the path
4. when prompted, enter the location where you want to save the excel version of the model. include the name and extension (e.g. c:\users\admin\Model.xlsx)
5. Assuming all went well, you should get a file spit out to your location after a few seconds.

TO DO
 handle localized fields. any field that has a stringmap object in the json could have different languages. Typically field names, descriptions, etc. Right now we only pull english
 How to handle field settings? Since these are dynamic...
#>

#####Get input file
#$SourceFilePath = "C:\Users\getch\Downloads\jsontest.json"

if (Get-Module -ListAvailable -Name ImportExcel) {
    Write-Host "ImportExcel Module is installed."
} 
else {
    try {
        Write-Host "ImportExcel Module is not installed. Trying to install..."
        Install-Module -Name ImportExcel -AllowClobber -Confirm:$False -Force  -Scope CurrentUser
    }
    catch [Exception] {
        $_.message 
        exit
    }
}

if (Get-Module -ListAvailable -Name JoinModule) {
    Write-Host "JoinModule Module is installed."
} 
else {
    try {
        Write-Host "JoinModule Module is not installed. Trying to install..."
        Install-Module -Name JoinModule -AllowClobber -Confirm:$False -Force  -Scope CurrentUser
    }
    catch [Exception] {
        $_.message 
        exit
    }
}



$SourceFilePath = ""
:ImportJSON While ($true) {
    $SourceFilePath = Read-Host -Prompt "Enter full or relative path to JSON file exported from inriver..."

    if (Test-Path $SourceFilePath) { 
        try {
            $SourceJSON = Get-Content $SourceFilePath -Raw | ConvertFrom-Json -ErrorAction Stop;
        }
        catch {
            Write-Host "File is not well formed json..." -ForegroundColor Red
        }
        Break ImportJSON
    }
    else { 
        Write-Host "File does not exist... Try Again" -ForegroundColor Red
    }
}



#Get the excel save to file location
$ExcelSaveToFile = ""
:SaveToFile while ($true) {
    $ExcelSaveToFile = Read-Host -Prompt "Please enter a filename and path where to save the output (include file name and ext. eg. C:\users\user\downloads\excel.xslx)"
    if (Test-Path -Path $ExcelSaveToFile -IsValid) { 
        if (Test-Path -Path $ExcelSaveToFile) {
            $title = 'Confirm File Overwrite..'
            $question = 'The file entered already exists. The process will delete the file, and create a new one. Are you sure you want to proceed? '
            $choices = '&Yes', '&No'
            $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
            if ($decision -eq 0) {
                Remove-Item $ExcelSaveToFile
                Write-Host "Deleting file $ExcelSaveToFile.." -ForegroundColor Yellow
                Break SaveToFile
            }
        }
        else { break }
    }
    else {
        Write-Host "Invalid path. Please try again.." -ForegroundColor Red
    }
}
Write-Host "Saving to file: '$ExcelSaveToFile'" -ForegroundColor Green




$ExcelExportArgs = @{
    #Path       = "C:\Users\getch\Downloads\test.xlsx";
    Path       = $ExcelSaveToFile;
    TableStyle = "Medium7"
}



#ServerSettings - a little trickery to have the table pivot so it's vertical instead of horizontal
Write-Host "Parsing Server Settings.." -ForegroundColor Yellow
$ServerSettings = $SourceJSON | Select-Object -Expand ServerSettings
$ServerSettings | Get-Member -MemberType NoteProperty |
Select-Object @{name = 'Name'; expression = { $_.name } }, 
@{name = 'Value'; expression = { $ServerSettings.($_.name) } } |
Export-Excel @ExcelExportArgs -WorksheetName "ServerSettings";
Write-Host "Exported Server Settings to file" -ForegroundColor Green

#Categories
Write-Host "Parsing Field Categories.." -ForegroundColor Yellow
$CategoryResults = @()    
$Categories = $SourceJSON | Select-Object -Expand Categories
foreach ($Cat in $Categories) {
    $CatResObj = [ordered] @{
        "Field Category" = $Cat.Name.stringMap.en
        AttributeID      = $Cat.Id
        SortOrder        = $Cat.Index
    }
    $CategoryResults += New-Object PSObject -Property $CatResObj
};
$CategoryResults | Sort-Object -Property SortOrder | Export-Excel @ExcelExportArgs -WorksheetName "Categories"
Write-Host "Exported Field Categories to file" -ForegroundColor Green



#Entity Types
$EntityTypeResults = @()
$fieldTypeSettingRes = @{}
ForEach ($EntityType in $SourceJSON | Select-Object -Expand EntityTypes) { 
    $EntityTypeID = $EntityType.id
    Write-Host "Parsing Entity Type $EntityTypeID.." -ForegroundColor Yellow
    $FieldTypes = $EntityType | Select-Object -Expand FieldTypes
    foreach ($fieldType in ($FieldTypes)) {
        
        $settings = $fieldType | Select-Object -Expand Settings   
        foreach ($setting in $settings) {
            $setting | Get-Member -MemberType NoteProperty | 
            % Name | 
            % { Add-Member -InputObject $fieldType -NotePropertyName ("Setting." + $_) -NotePropertyValue $setting.$_ -Force } 
        }
        $fieldType.PSObject.Properties | Where-Object Name -like "Setting.*" | foreach { $fieldTypeSettingRes[$_.Name] = $_.Value }
        
        $EntityTypeResObj = [ordered] @{
            EntityTypeID           = $EntityType.iD
            FieldTypeID            = $fieldType.id
            Name                   = $fieldType.Name.stringMap.en
            Description            = $fieldType.Description.stringMap.en
            DataType               = $fieldType.DataType
            SortOrder              = $fieldType.Index
            CVLId                  = $fieldType.CVLId
            DefaultValue           = $fieldType.DefaultValue
            Mandatory              = $fieldType.Mandatory
            ReadOnly               = $fieldType.ReadOnly
            Multivalue             = $fieldType.Multivalue
            Unique                 = $fieldType.Unique
            Hidden                 = $fieldType.Hidden
            ExcludeFromDefaultView = $fieldType.ExcludeFromDefaultView
            TrackChanges           = $fieldType.TrackChanges
            CategoryID             = $fieldType.CategoryId
        }
        $EntityFieldsMergedHash = $EntityTypeResObj + $fieldTypeSettingRes
        $EntityTypeResults += New-Object PSObject -Property $EntityFieldsMergedHash
        $fieldTypeSettingRes.Clear()
        $EntityTypeResObj.Clear()
    }
    #export the entity here
    $propList = $EntityTypeResults | ForEach-Object {
        $_.PSObject.Properties | Select-Object -ExpandProperty Name
    } | Select-Object -Unique

    $EntityTypeResults | Select-Object $propList | Sort-Object -Property SortOrder | Export-Excel @ExcelExportArgs -WorksheetName $EntityType.Name.stringMap.en
    $EntityTypeResults = @() 
    Write-Host "Exported Entity Type $EntityTypeID to file.." -ForegroundColor Green
}
Write-Host "Finished exporting all Entity Types to file.." -ForegroundColor Green




#FieldSet
Write-Host "Parsing Field Sets.." -ForegroundColor Yellow
$FSresults = @()
$FieldSets = $SourceJSON | Select-Object -Expand FieldSets
ForEach ($FS in $FieldSets) {
    Foreach ($FieldType in ($FS | Select-Object -Expand FieldTypes)) {
        $FieldSetObj = @{
            FieldSetID   = $FS.Id
            FieldSetName = $FS.Name.stringMap.en
            EntityTypeID = $FS.EntityTypeID
            "Field Key"  = $FieldType
            Description  = $FS.Description.stringMap.en 
        }
        $FSresults += New-Object PSObject -Property $FieldSetObj
    }
};  
$FSresults | Export-Excel @ExcelExportArgs -WorksheetName FieldSets
Write-Host "Exported Field Sets to file" -ForegroundColor Green


#Link Types
Write-Host "Parsing Link Types.." -ForegroundColor Yellow
$LTresults = @()
$LinkTypes = $SourceJSON | Select-Object -Expand LinkTypes
ForEach ($LT in $LinkTypes) {
    $LinkTypeObj = @{
        Index                = $LT.Index
        LinkTypeID           = $LT.ID
        SourceName           = $LT.SourceName.stringMap.en
        TargetName           = $LT.TargetName.stringMap.en
        "Source Entity Type" = $LT.SourceEntityTypeID
        "Target Entity Type" = $LT.TargetEntityTypeID
        "Link Entity Type"   = $LT.LinkEntityTypeId
        
    }
    $LTresults += New-Object PSObject -Property $LinkTypeObj
};  
$LTresults | Export-Excel @ExcelExportArgs -WorksheetName EntityLinkTypes
Write-Host "Exported Link Types to file" -ForegroundColor Green


Write-Host "Parsing CVL's.." -ForegroundColor Yellow
$CVLresults = @()
$CVLs = $SourceJSON | Select-Object -Expand CVLs
$CVLValues = $SourceJSON | Select-Object -Expand CVLValues 
$CVLJoined = $CVLs | LeftJoin $CVLValues -On Id -Equals CVLId #ID is a conflicting member in both objects, but seems to use the Value ID. That is ok since the ID for the CVL is the same as the CVL ID on the value object. We can just reference that
ForEach ($CVL in $CVLJoined) {
    $CVLObj = [ordered] @{
        #CVL header values
        CVLId             = $CVL.CVLId
        DataType          = $CVL.DataType
        ParentId          = $CVL.ParentId
        CVLActivated      = $CVL.Activated 
        CustomValueList   = $CVL.CustomValueList
        
        #CVL Detail Values
        #Id              = $CVL.Id
        Key               = $CVL.Key
        ParentKey         = $CVL.ParentKey
        Index             = $CVL.Index
        Value             = $CVL.Value
        RecordDeactivated = $CVL.Deactivated
        DateCreated       = $CVL.DateCreated
        LastModified      = $CVL.LastModified
    }
    $CVLresults += New-Object PSObject -Property $CVLObj
};
$CVLresults | Export-Excel @ExcelExportArgs -WorksheetName CVL
Write-Host "Exported CVL's to file" -ForegroundColor Green



<# open the file... 
doesn't seem to want to cooperate. maybe do this later

$openFile = Read-Host "Complete. Would you like to open the file?"
$title    = 'Open File?'
$question = 'Complete. Would you like to open the file?'
$choices  = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    $Excel = New-Object -ComObject Excel.Application
    $workbook = $Excel.Workbooks.Open($ExcelExportArgs.path)
}#>