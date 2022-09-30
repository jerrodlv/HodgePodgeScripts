<#
Author: Jerrod LaVassor

This script requires the import-excel module to be installed in order to save results to an excel file (multiple worksheets)
Install-Module -Name ImportExcel     Needs to run as admin


TO DO
 Gather input arguments to get file source and destination output
#>

$SourceFilePath = "C:\Users\getch\Downloads\jsontest_full.json"
$SourceJSON = Get-Content $SourceFilePath  -Raw | ConvertFrom-Json

#iterate through all of the JSON objects and put them into posh objects before export

#ServerSettings
$ServerSettings = $SourceJSON | Select-Object -Expand ServerSettings
$ServerSettings | Get-Member -MemberType NoteProperty |
Select-Object @{name = 'Name'; expression = { $_.name } }, 
@{name = 'Value'; expression = { $ServerSettings.($_.name) } } |
Export-Excel -Path "C:\Users\getch\Downloads\test.xlsx" -WorksheetName "ServerSettings" 


#Categories
$CategoryResults = @()    
$Categories = $SourceJSON | Select-Object -Expand Categories
foreach ($Cat in $Categories) {
    $CatResObj = @{
        "Field Category" = $_.Name.stringMap.endpoint
        AttributeID      = $_.Id
        SortOrder        = $_.Index
    }
    $CategoryResults += New-Object PSObject -Property $CatResObj
}

$CategoryResults | Sort-Object -Property SortOrder | Export-Excel -Path "C:\Users\getch\Downloads\test.xlsx" -WorksheetName "Categories"



#Entity Types
$EntityTypeResults = @()
$EntityTypes = $SourceJSON | Select-Object -Expand EntityTypes
ForEach ($EntityType in $EntityTypes) { 
    foreach ($fieldType in ($EntityType | Select-Object -Expand FieldTypes)) {
        #handle localized name object another time...
        #$fieldType | Add-Member -NotePropertyName 'Name_en' -NotePropertyValue $fieldType.Name.stringMap.en
        #$fieldType | Add-Member -NotePropertyName 'Description_en' -NotePropertyValue $fieldType.Description.stringMap.en
        #$fieldType.PSObject.Properties.Remove('Name')
        #$fieldType.PSObject.Properties.Remove('Description')
        $EntityTypeResObj = @{
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
        $EntityTypeResults += New-Object PSObject -Property $EntityTypeResObj
    } 
    $EntityTypeResults | 
    Select-Object EntityTypeID, FieldTypeID, Name, Description, DataType, SortOrder, CVLId, DefaultValue, Mandatory, ReadOnly, Multivalue, Unique, Hidden, ExcludeFromDefaultView, TrackChanges, CategoryID |
    Sort-Object -Property SortOrder | 
    Export-Excel -Path "C:\Users\getch\Downloads\test.xlsx" -WorksheetName $EntityType.Id
}



 
#FieldSet
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
$FSresults | Export-Excel -Path "C:\Users\getch\Downloads\test.xlsx" -WorksheetName FieldSets

