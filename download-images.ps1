#Author: Jerrod La Vassor
#Description:
#
#
#



$BaseURL = "https://eadn-wc03-4643882.nxedge.io/cdn/media/catalog/product/cache/1/image/560x/040ec09b1e35df139433887a97daa66f"
$SaveToDir = "D:\WolfImages\images"


$imageFilePath = "D:\WolfImages\test.csv"
$ImagePaths = Import-Csv -Path $imageFilePath
$results = @()
$outputFileName = "D:\WolfImages\ImageDownloadResults.csv"
if (test-path $outputFileName) {
    remove-item $outputFileName
}

ForEach ($ImagePath in $ImagePaths) {   
    $FileName = Split-Path $ImagePath.path -Leaf
    $Sku = $imagepath.sku
    $relurl = $imagepath.path
    Write-Host "Trying " $BaseURL$relurl
    if (!(test-path -Path "$SaveToDir\$Sku"))
    { New-Item -ItemType directory -Path "$SaveToDir\$Sku" }
    try {
        Invoke-WebRequest $BaseURL$relurl -OutFile "$SaveToDir\$Sku\$FileName"
        write-host "Downloading Image" -fore Green
        $details = @{            
            sku        = $sku         
            ImagePath  = $relurlr                 
            Downloaded = "True" 
        }                           
        $results += New-Object PSObject -Property $details
    }
    catch [System.Net.WebException] {
        Write-Host "No Image Found" -fore Red
        if (!(test-path -Path "$SaveToDir\$Sku\*"))
        { Remove-Item -Path "$SaveToDir\$Sku" }
        $details = @{            
            sku        = $sku         
            ImagePath  = $relurlr                 
            Downloaded = "False" 
        }                           
        $results += New-Object PSObject -Property $details
    }
    catch {
        write-host "unknown error" -fore Red 
        $details = @{            
            sku        = $sku         
            ImagePath  = $relurlr                 
            Downloaded = "False" 
        }                           
        $results += New-Object PSObject -Property $details
    }
}