$headers = @{
    "Accept" = "application/json";
    "X-inRiver-APIKey" = "a2738738dfbf63809c574d6d181e44f7"
}
$QueryEndpoint = "https://apiuse.productmarketingcloud.com/api/v1.0.0/query"
$requestJSON = @'
    { 
        "systemCriteria": [
            {
                "type": "EntityTypeId",
                "value": "ChannelNode",
                "operator": "Equal"
            }
        ],
            "linkCriterion": 
            {
                "linkTypeID": "ChannelNodeChannelNodes",
                "direction": "inbound",
                "linkExists": false
            }
    }
'@

$response = (Invoke-RestMethod -Method:Post -Headers $headers -URI $QueryEndpoint -Body ($requestJSON) -ContentType "application/json").entityIds

$nodesToDelete = @()

foreach ($r in $response) {
    #Write-Host $r
    $CheckLinkURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/entities/$r/links?linkTypeId=ChannelChannelNodes"
    $ChannelNodeLinkReponse = Invoke-RestMethod -Method:Get -Headers $headers -URI $CheckLinkURI
    if($ChannelNodeLinkReponse.Count -eq 0){
        $nodesToDelete += $r
    }
}

foreach ($node in $nodesToDelete) {
    $entityDeleteURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/entities/$node"
    Write-Host "Deleting Entity ID $node"
    Invoke-RestMethod -Method:Delete -Headers $headers -URI $entityDeleteURI
}
