$WindowsSpotlightFolder = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
$WindowsSpotlightImages = "$env:USERPROFILE\Desktop\SpotlightImages\"

if (Test-Path $WindowsSpotlightImages) {
    $FolderTimestamp = Get-Date (Get-Item $WindowsSpotlightImages).LastWriteTime -Format "yyyyMMdd.HHmmss"
    Rename-Item -Path $WindowsSpotlightImages -NewName ('SpotlightImages-' + $FolderTimestamp) -Force
    Remove-Variable FolderTimestamp   # Cleanup
}

New-Item -Path $WindowsSpotlightImages -ItemType Directory | Out-Null

Add-Type -AssemblyName System.Drawing
$ImagesToCopy = @()
$(Get-ChildItem -Path $WindowsSpotlightFolder).FullName | ForEach-Object { 
    $Image = [System.Drawing.Image]::Fromfile($_)
    $Dimensions = "$($Image.Width)x$($Image.Height)"

    If ($Dimensions -eq "1920x1080") {
        $ImagesToCopy += $_
    }
    $Image.Dispose()
}

$ImagesToCopy | Copy-Item -Destination $WindowsSpotlightImages 
$FileNumber = 0

Get-ChildItem -Path $WindowsSpotlightImages | Sort-Object LastWriteTime | 
foreach {
    $FileNumber += 1
    Rename-Item -Path $_.FullName -NewName ("1920x1080_" + $FileNumber.ToString("000") + '.jpg')
}

# Report
$NewSpotlgihtImages = Get-ChildItem -Path $WindowsSpotlightImages
if ($NewSpotlgihtImages) {
    Write-Host
    ($NewSpotlgihtImages).Name
    Write-Host `n($NewSpotlgihtImages).Count "new images were copied into $WindowsSpotlightImages`n" -ForegroundColor Green 
}
else { 
    Write-Host "`nNo new images were copied.`n" -ForegroundColor Red
    Remove-Item $WindowsSpotlightImages -Force
}

# Cleanup
Remove-Variable WindowsSpotlightFolder, WindowsSpotlightImages, ImagesToCopy, Image, Dimensions, FileNumber, NewSpotlgihtImages