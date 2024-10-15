<#
=======================================================================
    NIKKE: Goddess of Victory - NIKKE OCR Downloader
    Created for Arkz Tech Command Center
    Version: 1.2
    Author: Commander Valentin Marquez
=======================================================================
#>

function Show-NikkeBanner {
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Magenta
    Write-Host "     NIKKE: Goddess of Victory - NIKKE OCR Downloader  " -ForegroundColor Cyan
    Write-Host "          Arkz Tech Command Center Utility            " -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Magenta
    Write-Host ""
}

function Get-UserDownloadPath {
    $defaultPath = Join-Path $env:USERPROFILE "Downloads"
    Write-Host "Please specify the download path for NIKKE OCR:" -ForegroundColor Yellow
    Write-Host "(Press Enter to use the default path: $defaultPath)" -ForegroundColor Gray
    
    $userPath = Read-Host
    
    if ([string]::IsNullOrWhiteSpace($userPath)) {
        return $defaultPath
    }
    
    if (Test-Path $userPath) {
        return $userPath
    } else {
        Write-Host "The specified path does not exist. Creating directory..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $userPath -Force | Out-Null
        return $userPath
    }
}

function Download-NikkeOCR {
    $repo = "arkz-tech/nikke-ocr"
    $releases = "https://api.github.com/repos/$repo/releases"
    
    try {
        Write-Host "Fetching latest release information..." -ForegroundColor Yellow
        $latestRelease = (Invoke-WebRequest $releases | ConvertFrom-Json)[0]
        $tag = $latestRelease.tag_name
        $downloadUrl = "https://github.com/$repo/releases/download/$tag/NIKKE-OCR.zip"
        
        Write-Host "Latest version found: $tag" -ForegroundColor Green
        
        $downloadPath = Get-UserDownloadPath
        $fullDownloadPath = Join-Path $downloadPath "NIKKE-OCR.zip"
        
        Write-Host "Downloading NIKKE OCR to $fullDownloadPath..." -ForegroundColor Yellow
        Invoke-WebRequest $downloadUrl -OutFile $fullDownloadPath
        
        Write-Host "Download completed successfully!" -ForegroundColor Green
        Write-Host "File saved to: $fullDownloadPath" -ForegroundColor Cyan
        
        $extractPath = Join-Path $downloadPath "NIKKE-OCR"
        
        Write-Host "Extracting files..." -ForegroundColor Yellow
        Expand-Archive -Path $fullDownloadPath -DestinationPath $extractPath -Force
        
        Write-Host "Extraction completed!" -ForegroundColor Green
        Write-Host "NIKKE OCR has been installed to: $extractPath" -ForegroundColor Cyan
        
        Write-Host "`nImportant Notes:" -ForegroundColor Yellow
        Write-Host "1. Ensure your game is running in fullscreen at 1920x1080 resolution." -ForegroundColor White
        Write-Host "2. Set your in-game language to English for optimal performance." -ForegroundColor White
        Write-Host "3. Run NIKKE-OCR.exe as administrator when you use it." -ForegroundColor White
        
    } catch {
        Write-Host "An error occurred while downloading or extracting NIKKE OCR:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "Stack Trace:" -ForegroundColor Red
        Write-Host $_.Exception.StackTrace -ForegroundColor Red
    }
}

try {
    Show-NikkeBanner
    Download-NikkeOCR
} catch {
    Write-Host "An unexpected error occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "Stack Trace:" -ForegroundColor Red
    Write-Host $_.Exception.StackTrace -ForegroundColor Red
}

Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")