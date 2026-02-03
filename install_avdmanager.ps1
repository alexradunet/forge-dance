$ErrorActionPreference = "Stop"

$url = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$zipPath = "$env:TEMP\commandlinetools.zip"
$installDir = "C:\Android"
$cmdlineToolsDir = "$installDir\cmdline-tools"
$finalDir = "$cmdlineToolsDir\latest"

Write-Host "Creating installation directory: $installDir"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
New-Item -ItemType Directory -Force -Path $cmdlineToolsDir | Out-Null

Write-Host "Downloading command line tools from $url..."
Invoke-WebRequest -Uri $url -OutFile $zipPath

Write-Host "Extracting zip file..."
Expand-Archive -Path $zipPath -DestinationPath $cmdlineToolsDir -Force

# The zip extracts to a folder named "cmdline-tools", we need it to be inside "cmdline-tools\latest" for sdkmanager to work
# Current structure after extract: C:\Android\cmdline-tools\cmdline-tools\bin
# Desired structure: C:\Android\cmdline-tools\latest\bin

$extractedFolder = "$cmdlineToolsDir\cmdline-tools"

if (Test-Path $finalDir) {
    Write-Host "Removing existing 'latest' directory..."
    Remove-Item -Recurse -Force $finalDir
}

Write-Host "Renaming extracted folder to 'latest'..."
Rename-Item -Path $extractedFolder -NewName "latest"

# Clean up zip
Remove-Item -Force $zipPath

# Set Environment Variables
Write-Host "Setting Environment Variables..."
[System.Environment]::SetEnvironmentVariable("ANDROID_HOME", $installDir, [System.EnvironmentVariableTarget]::User)

$binPath = "$finalDir\bin"
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

if ($currentPath -notlike "*$binPath*") {
    Write-Host "Adding $binPath to User Path..."
    $newPath = "$currentPath;$binPath"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
} else {
    Write-Host "Path already set."
}

Write-Host "Installation complete."
Write-Host "Please restart your terminal or refresh environment variables to use 'avdmanager' and 'sdkmanager'."
