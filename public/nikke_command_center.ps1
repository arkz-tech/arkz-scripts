<#
=======================================================================
    NIKKE: Goddess of Victory - Command Center
    Created for Arkz Tech
    Version: 2.1
    Author: Commander Valentin Marquez
=======================================================================
#>

# Function to verify administrator privileges
function Confirm-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $currentUser
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to display NIKKE-themed menu and get user choice
function Show-CommandCenterMenu {
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Magenta
    Write-Host "     NIKKE: Goddess of Victory - Command Center       " -ForegroundColor Cyan
    Write-Host "             Arkz Tech Utility Suite                  " -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "1. Initiate NIKKE Data Relocation Protocol" -ForegroundColor Yellow
    Write-Host "2. Download NIKKE OCR" -ForegroundColor Yellow
    Write-Host "3. [Placeholder for future utility]" -ForegroundColor Gray
    Write-Host "4. Exit Command Center" -ForegroundColor Red
    Write-Host ""
    $choice = Read-Host "Enter command (1-4)"
    return $choice
}

# Function to execute selected utility
function Invoke-NikkeUtility {
    param (
        [string]$url
    )
    try {
        Write-Host "Initializing utility from: $url" -ForegroundColor Cyan
        Invoke-Expression (New-Object Net.WebClient).DownloadString($url)
    }
    catch {
        Write-Error "Utility execution failed. Error: $_"
    }
}

# Main execution block
Clear-Host
if (-not (Confirm-AdminPrivileges)) {
    Write-Host "Error: Insufficient permissions detected." -ForegroundColor Red
    Write-Host "Please restart the Command Center with administrator privileges." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press any key to exit..."
    exit 1
}

# Main loop for Command Center operations
do {
    $choice = Show-CommandCenterMenu

    switch ($choice) {
        1 {
            # NIKKE Data Relocation Protocol
            Invoke-NikkeUtility -url "https://scripts.arkz.tech/move_nikke_folder.ps1"
        }
        2 {
            # Download NIKKE OCR
            Invoke-NikkeUtility -url "https://scripts.arkz.tech/download_nikke_ocr.ps1"
        }
        4 {
            Write-Host "Exiting NIKKE Command Center. Thank you for your service, Commander." -ForegroundColor Green
            exit
        }
        default {
            Write-Host "Invalid command. Please select a valid option." -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Read-Host "Press any key to return to the Command Center..."
} while ($true)