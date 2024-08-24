
# ==============================================
# Script Menu Utility - Created for arkz.tech
# ==============================================

# Function to check if running as admin
function Test-Admin {
    [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent()
    return $user.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to display the menu and get user choice
function Show-Menu {
    Clear-Host
    Write-Host "====================================="
    Write-Host "        Script Utility Menu          "
    Write-Host "          Created by arkz.tech       "
    Write-Host "====================================="
    Write-Host ""
    Write-Host "1. Move NIKKE Folder to another Hard Drive"
    Write-Host "4. Exit"
    Write-Host ""
    $choice = Read-Host "Select an option (1-4)"
    return $choice
}

# Function to execute the selected script
function Execute-Script {
    param (
        [string]$url
    )
    try {
        Write-Host "Executing script from: $url"
        irm $url | iex
    }
    catch {
        Write-Error "Failed to execute the script. Error: $_"
    }
}

# Main execution block
Clear-Host
if (-not (Test-Admin)) {
    Write-Host "This script needs to be run as an administrator." -ForegroundColor Red
    Write-Host "Please restart this script with elevated privileges (Run as Administrator)." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press any key to exit..."
    exit 1
}

# Main loop to display the menu and execute the selected option
do {
    $choice = Show-Menu

    switch ($choice) {
        1 {
            # Option 1 - Move NIKKE Folder
            Execute-Script -url "https://scripts.arkz.tech/move_nikke_folder.ps1"
        }
        4 {
            Write-Host "Exiting... Thank you for using this utility." -ForegroundColor Green
            exit
        }
        default {
            Write-Host "Invalid selection, please choose a valid option." -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Read-Host "Press any key to return to the menu..."
} while ($true)
