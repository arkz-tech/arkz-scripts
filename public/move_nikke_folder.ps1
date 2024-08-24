<#
=======================================================================
    NIKKE: Goddess of Victory - Data Migration Utility
    Created for Arkz Tech Command Center
    Version: 2.0
    Author: Commander Valentin Marquez
=======================================================================
#>

# Function to verify administrator privileges
function Confirm-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $currentUser
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to display progress with NIKKE theme
function Show-NikkeProgress {
    param ([int]$Percent)
    $progressChar = ">"
    $emptyChar = "-"
    $barLength = 50
    $filledLength = [math]::Round($Percent / 100 * $barLength)
    $bar = $progressChar * $filledLength + $emptyChar * ($barLength - $filledLength)
    Write-Host ("[{0}] {1}% Complete" -f $bar, $Percent) -ForegroundColor Cyan
}

# Function to calculate folder size in GB
function Get-FolderSizeGB {
    param ([string]$Path)
    $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -Sum).Sum
    return [math]::Round($size / 1GB, 2)
}

# Function to display NIKKE-themed banner
function Show-NikkeBanner {
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Magenta
    Write-Host "     NIKKE: Goddess of Victory - Data Migration       " -ForegroundColor Cyan
    Write-Host "          Arkz Tech Command Center Utility            " -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Magenta
    Write-Host ""
}

# Main execution block
if (-not (Confirm-AdminPrivileges)) {
    Show-NikkeBanner
    Write-Host "Error: Insufficient permissions detected." -ForegroundColor Red
    Write-Host "Please restart this utility with administrator privileges." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press any key to exit..."
    exit 1
}

# Find default NIKKE data folder
Show-NikkeBanner
$defaultPath = "$env:USERPROFILE\AppData\LocalLow\Unity\com_proximabeta_NIKKE"
if (Test-Path $defaultPath) {
    $sourcePath = $defaultPath
} else {
    $sourcePath = Read-Host "NIKKE data not found. Please enter the full path to your NIKKE data folder"
    if (-not (Test-Path $sourcePath)) {
        Write-Error "The specified path does not exist. Aborting mission."
        exit 1
    }
}

# Get destination path from user
do {
    $destinationPath = Read-Host "Enter the full path for NIKKE data relocation"
    $folderName = Split-Path $sourcePath -Leaf
    $fullDestinationPath = Join-Path $destinationPath $folderName

    if (Test-Path $fullDestinationPath) {
        Write-Host "Warning: A folder named $folderName already exists at $destinationPath." -ForegroundColor Yellow
        Write-Host "Please choose a different location to avoid data conflicts." -ForegroundColor Yellow
    }
} while (Test-Path $fullDestinationPath)

# Prepare for data transfer
if (-not (Test-Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
}

$sourceDrive = (Get-Item $sourcePath).PSDrive.Name
$destDrive = (Get-Item $destinationPath).PSDrive.Name
$crossDriveOperation = $sourceDrive -ne $destDrive

$totalSize = Get-FolderSizeGB $sourcePath
$totalItems = (Get-ChildItem $sourcePath -Recurse).Count
$currentItem = 0

Show-NikkeBanner
Write-Host "Mission Briefing:" -ForegroundColor Green
Write-Host "Relocating NIKKE data (${totalSize}GB) to $fullDestinationPath" -ForegroundColor Cyan

# Execute data transfer
Get-ChildItem -Path $sourcePath -Recurse | ForEach-Object {
    $destFile = $_.FullName.Replace($sourcePath, $fullDestinationPath)
    $destDir = Split-Path $destFile -Parent
    
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    
    Move-Item $_.FullName $destFile -Force
    
    $currentItem++
    $percentComplete = [math]::Round(($currentItem / $totalItems) * 100)
    Show-NikkeProgress -Percent $percentComplete
}

# Clean up and create symlink
if ($crossDriveOperation) {
    Remove-Item -Path $sourcePath -Recurse -Force
}

cmd /c mklink /j $sourcePath $fullDestinationPath

Show-NikkeBanner
Write-Host "Mission Accomplished!" -ForegroundColor Green
Write-Host "NIKKE data successfully relocated and linked." -ForegroundColor Cyan
Write-Host "New data location: $fullDestinationPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Thank you for using Arkz Tech Command Center utilities." -ForegroundColor Magenta
Write-Host "For more NIKKE resources, visit: arkz.tech" -ForegroundColor Yellow