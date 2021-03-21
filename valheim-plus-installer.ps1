##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uK1
##Nc3NCtDXThU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4NI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjofG5iZk2UHvRmElUuGeqr2zy5GA6evgsyDQRNcERUFk2yDyF1+8Vf4XR7sQrNRx
##Kc/BRM3KXxU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
# Get folder function
Function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

# Install Paths
$installPath1 = "C:\Program Files (x86)\Steam\steamapps\common\Valheim"
$installPath2 = "D:\Steam\steamapps\common\Valheim"

### Main ###
if (Test-Path $installPath1\valheim.exe) {
    Write-Host "Valehim installation found at: $installPath1"
    Write-Host ""
    $valheim = $installPath1
}
elseif (Test-Path $installPath2\valheim.exe) {
    Write-Host "Valehim installation found at: $installPath2"
    Write-Host ""
    $valheim = $installPath2
}
else {
    Write-Host "Please locate the Valheim install folder."
    $selectedPath = Get-Folder
    if (Test-Path $selectedPath\valheim.exe) {
        Write-Host "Valehim installation found at: $selectedPath"
        Write-Host ""
        $valheim = $selectedPath
    }
    else {
        Write-Host "Invalid Path. Exiting..."
        Pause
        Exit
    }
}

# Download latest release from github
$repo = "valheimPlus/ValheimPlus"
$file = "WindowsClient.zip"

$releases = "https://api.github.com/repos/$repo/releases"

Write-Host Determining latest release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

$download = "https://github.com/$repo/releases/download/$tag/$file"
$name = $file.Split(".")[0]
$zip = "$name-$tag.zip"
$dir = "$name-$tag"

Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $zip

Write-Host Extracting release files
Expand-Archive $zip -Force

# Copy mod files into Valheim folder
xcopy $dir $valheim /s /y

# Removing temp files
Remove-Item $zip -Force
Remove-Item $dir -Recurse -Force

Write-Host ""
Write-Host ""
Write-Host "Installation complete!"
Write-Host ""
Write-Host ""
pause