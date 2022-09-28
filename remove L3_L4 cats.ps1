#define some globals. need some arrays for later, api headers can be changed per environment
$testmode = 0 #make this 0 to actually peform the node unlink call. anything else will just write the call to screen
$L2Array = @()
$L3Array = @()
$results = @()
$headers = @{
    "Accept" = "application/json";
    "X-inRiver-APIKey" = "a2738738dfbf63809c574d6d181e44f7"
}
$ChannelID = "113323"
$GetStructureURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/channels/$ChannelID/nodes"

#Invoke-RestMethod -Method:Get -Headers $headers -URI $GetStructureURI 
$response = Invoke-RestMethod -Method:Get -Headers $headers -URI $GetStructureURI 

#replace $responseSplitTest with  $response to actually do the full list of nodes..
#the second part of the and should be removed for the full catalog. else it can be run for individual L1's by putting the L1 sys ID in
foreach($i in $response) {
    $channelID,$L1,$L2,$L3,$L4 = $i.Split('/')
    #if((!$L3 -eq "") -and ($L1 -eq "114148") ) {
    if(!$L3 -eq "") {
        $L3Array += $L3
    }
    #if((!$L2 -eq "") -and ($L1 -eq "114148")) {
    if(!$L2 -eq "")  {
        $L2Array += $L2 
     }  
};

$L3Array = $L3Array | Select-Object -Unique
$L2Array = $L2Array | Select-Object -Unique

write-host "removing links between L2's and L3's"
foreach($L3 in $L3Array){
    if(!$L3 -eq "") {
        #We have an L3 that needs to be unlinked. get the link ID of the link to it's parent
        $GetNodeLinkIDURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/entities/$L3/links?linkDirection=inbound&linkTypeId=ChannelNodeChannelNodes"
        try {
            $NodeLinkID = (Invoke-RestMethod -Method:Get -Headers $headers -URI $GetNodeLinkIDURI).id
            $DeleteLinkURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/links/$NodeLinkID"
            if($testmode -eq 0) {
               write-host "Removing link $NodeLinkID. Calling $DeleteLinkURI..."
               Invoke-RestMethod -Method:Delete -Headers $headers -URI $DeleteLinkURI
            }
            else {
                write-host "In test mode, we write this call to screen instead of actually calling the delete.. Call endpoint $DeleteLinkURI"
            }
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
    }
};


Write-Host "Links all removed. now get all of the L2's and create the CSV for the node link rules"
#get the name of each of these, we currently just have the ID
foreach($L2 in $L2Array){
    $NodeIDURI = "https://apiuse.productmarketingcloud.com/api/v1.0.0/entities/$L2/summary/fields?fieldTypeIds=ChannelNodeID"
    $NodeID = (Invoke-RestMethod -Method:Get -Headers $headers -URI $NodeIDURI).value
    $csvoutput = @{
        ChannelNodeUniqueValue = $NodeID
        Field = "ProductCat2"
        value = $NodeID.replace("PM-", "")
    }
    $results += New-Object PSObject -Property $csvoutput
}

$datetime = Get-date -Format MMddyyyyHHmmss 
$csvoutputpath = "C:\Users\getch\Luminos Labs\Luminos Labs - Clients\NDC\Client Shared - NDC\inRiver\Import Files\Model Import Files\NodeLinkRules_$datetime.csv"
$results | Select-Object ChannelNodeUniqueValue, Field, @{label = "Equals";expression={$_.value}} | Export-Csv -Path $csvoutputpath -NoTypeInformation

#$csvoutputpath = "C:\Users\getch\Luminos Labs\Luminos Labs - Clients\NDC\Client Shared - NDC\inRiver\Import Files\Model Import Files\NodeLinkRules_09062022152122.csv"
#call the improt routines to load the link rules that we exported to csv. 
& C:\LLInRiverToolkit\ImportToolkit\LL.InRiver.ImportToolkits.exe addlinkdefinitions `
     -c "Preferred Medical" `
     -u "ChannelNodeID" `
     -l "ChannelNodeProducts" `
     -i $csvoutputpath `
     -r `
     -e test `
     --user jerrod_ndc@luminoslabs.com `
     --pass "yygJh94NnK@e@o" `
     --url https://remoting.productmarketingcloud.com