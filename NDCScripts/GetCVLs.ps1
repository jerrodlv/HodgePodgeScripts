$headers = @{
    "Accept" = "application/json";
    "X-inRiver-APIKey" = "a2738738dfbf63809c574d6d181e44f7"
}
$GetStructureURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/model/cvls"

$response = Invoke-RestMethod -Method:Get -Headers $headers -URI $GetStructureURI
$record = @()

foreach ($i in $response) {
    $csvoutput = @{
        cvlID = $i.id
        ParentKey = $i.parentId
        DataType = $i.dataType
    }
    $record += New-Object PSObject -Property $csvoutput
}

$record | Export-Csv -Path ".\Desktop\csvType.csv" -NoTypeInformation