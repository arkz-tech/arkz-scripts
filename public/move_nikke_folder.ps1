<#
===============================================================
Script created for arkz.tech
Created by Valentin Marquez
===============================================================
#>

# Function to check if running as admin
function Test-Admin {
    [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent()
    return $user.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to show progress
function Show-Progress {
    param ([int]$Percent)
    Write-Progress -Activity "Moving NIKKE files and creating symlink" -Status "$Percent% Complete" -PercentComplete $Percent
}

# Function to get folder size
function Get-FolderSize {
    param ([string]$Path)
    $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -Sum).Sum
    return [math]::Round($size / 1GB, 2)
}

# Function to clear screen and show banner
function Clear-Screen {
    Clear-Host
    Write-Host "====================================="
    Write-Host "     NIKKE Folder Move Utility       "
    Write-Host "         Created by nozz.dev         "
    Write-Host "====================================="
    Write-Host ""
}

# Check if running as admin
if (-not (Test-Admin)) {
    Clear-Screen
    Write-Host "This script needs to be run as an administrator." -ForegroundColor Red
    Write-Host "Please restart this script with elevated privileges (Run as Administrator)." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press any key to exit..."
    exit 1
}

# Find default NIKKE folder
Clear-Screen
$defaultPath = "$env:USERPROFILE\AppData\LocalLow\Unity\com_proximabeta_NIKKE"
if (Test-Path $defaultPath) {
    $sourcePath = $defaultPath
} else {
    $sourcePath = Read-Host "Default NIKKE folder not found. Please enter the full path to the NIKKE folder"
    if (-not (Test-Path $sourcePath)) {
        Write-Error "The specified path does not exist. Exiting script."
        exit 1
    }
}

# Get destination path from user
do {
    $destinationPath = Read-Host "Enter the full path where you want to move the NIKKE folder"
    $folderName = Split-Path $sourcePath -Leaf
    $fullDestinationPath = Join-Path $destinationPath $folderName

    if (Test-Path $fullDestinationPath) {
        Write-Host "A folder named $folderName already exists at $destinationPath. Please choose a different location."
    }
} while (Test-Path $fullDestinationPath)

# Create destination directory if it doesn't exist
if (-not (Test-Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
}

# Check if moving to a different drive
$sourceDrive = (Get-Item $sourcePath).PSDrive.Name
$destDrive = (Get-Item $destinationPath).PSDrive.Name
$differentDrive = $sourceDrive -ne $destDrive

# Get total size and item count
$totalSize = Get-FolderSize $sourcePath
$totalItems = (Get-ChildItem $sourcePath -Recurse).Count
$currentItem = 0

Clear-Screen
Write-Host "Moving $folderName (${totalSize}GB) to $fullDestinationPath"

# Move files
Get-ChildItem -Path $sourcePath -Recurse | ForEach-Object {
    $destFile = $_.FullName.Replace($sourcePath, $fullDestinationPath)
    $destDir = Split-Path $destFile -Parent
    
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    
    Move-Item $_.FullName $destFile -Force
    
    $currentItem++
    Show-Progress -Percent ([math]::Round(($currentItem / $totalItems) * 100))
}

# Remove original folder if moving to a different drive
if ($differentDrive) {
    Remove-Item -Path $sourcePath -Recurse -Force
}

# Create symlink
cmd /c mklink /j $sourcePath $fullDestinationPath

Clear-Screen
Write-Host "Operation completed successfully!"
Write-Host "Symlink created at $sourcePath pointing to $fullDestinationPath"
Write-Host ""
Write-Host "Thank you for using this script!"
Write-Host "Visit: nozz.dev"