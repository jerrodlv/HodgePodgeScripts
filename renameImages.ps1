#Author: Jerrod LaVassor
#Description: This script checks a csv file for image names, finds the image in the specified directory, and renames it to a new directory with the name based on the same CSV file



#generic var's 
$results = @()
$datetime = Get-date -Format MMddyyyyHHmmss 
#file/folder paths
$dirWithImages = (Read-Host -Prompt "Enter the directory or UNC path that contains the source images").trimend('\') #where the current images are
$dirWithRenamedImages = (Read-Host -Prompt "Enter the directory or UNC path of where you want to save the renamed images (not the same as the source..)").trimend('\') #where to put the renamed ones, we don't want to delete/overwrite the existing ones. Make this a different directory than the existing images...
$imageFilePath = Read-Host -Prompt "Enter the full path to the file that contains your CSV of the new and old image names"  #csv file location 
$outputLogFileName = "$dirWithRenamedImages\log\ImageRenameLog$datetime.csv"
if (test-path $outputLogFileName) {
    remove-item $outputLogFileName
}

<# THis is for testing with hardcoded paths.
$dirWithImages = "D:\work\NDC\images"  #where the current images are
$dirWithRenamedImages = "D:\work\NDC\images\renamed" #where to put the renamed ones, we don't want to delete/overwrite the existing ones. Make this a different directory than the existing images...
$imageFilePath = "D:\work\NDC\images\xref\ImageTest1.csv"  #csv file location 
$outputLogFileName = "D:\work\NDC\images\log\ImageRenameLog$datetime.csv" 
if (test-path $outputLogFileName) {
    remove-item $outputLogFileName
}
#>

#import the CSV that contains the image name and new image name. must include column headers named: ImageFileName & ProposedNewName
$Imagexref = Import-Csv -Path $imageFilePath  

#iterate each row in the csv, find the image name from the file. if we can find the image, we try to make a copy of it with a new name in the dir defined
ForEach ($Image in $Imagexref) {
    #local vars   
    $currentImageName = $Image.ImageFileName
    $newImageName = $Image.ProposedNewName
    Write-Host "Looking for image $currentImageName"
    if (!(test-path -Path "$dirWithImages\$currentImageName")) { 
        Write-Host "$currentImageName - Image Not Found in source directory"
        $details = @{            
            imagename = $currentImageName   
            ImagePath = "$currentImageName\$dirWithImages"              
            message   = "Image Not Found"
        } 
        $results += New-Object PSObject -Property $details
    }
    else {   
        Write-Host "Found image $currentImageName. Renaming..." 
        try {
            Copy-Item -Path  "$dirWithImages\$currentImageName" -Destination "$dirWithRenamedImages\$newImageName"
            $details = @{            
                imagename = $currentImageName      
                ImagePath = "$dirWithImages\$currentImageName"                 
                message   = "New Image: $dirWithRenamedImages\$newImageName"
            }           
            $results += New-Object PSObject -Property $details
            Write-Host "Successfully renamed."
    }
        catch {
            $details = @{            
                imagename = $currentImageName       
                ImagePath = "$currentImageName\$dirWithImages"                 
                message   = "Something went wrong"
            }                             
            $results += New-Object PSObject -Property $details
            Write-Host "Something went wrong with renaming/saving $currentImageName"
        }
    }
}
if (!(test-path -Path "$dirWithRenamedImages\log")){
    New-Item -Path "$dirWithRenamedImages\log" -ItemType Directory
}
$results | Export-Csv -Path $outputLogFileName -NoTypeInformation

$response = Read-Host -Prompt "Renaming is complete. You can review the log file here: $outputLogFileName. Press any key to close this window..."