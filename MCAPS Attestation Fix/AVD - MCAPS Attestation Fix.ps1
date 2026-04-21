#===========================================================================================================================#
# Version     = 1.0
# Script Name = AVD - MCAPS Attestation Fix.ps1
# Description = Fixes VM attestation failures in Microsoft Defender for Cloud by disabling test/flight signing on AVD hosts.
# Notes       = Requires restart to take effect. Deploy via Intune to AVD managed devices.
#===========================================================================================================================#

# Define the log file location
$logFolder = "C:\Temp"
$logFile = "$logFolder\AVD-MCAPS-AttestationFix.txt"

# Ensure the log folder exists
if (-not (Test-Path -Path $logFolder)) {
  New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# Function to write log entries
function Write-Log {
  param ([string]$message)
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $logEntry = "$timestamp - $message"
  Write-Host $logEntry
  $logEntry | Out-File -FilePath $logFile -Append
}

# Log execution context
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Write-Log "Running as: $currentUser"
Write-Log "Starting MCAPS attestation fix for AVD host."

try {
  # Disable Test Signing
  Write-Log "Disabling test signing..."
  $testSignResult = bcdedit /set testsigning off
  if ($LASTEXITCODE -eq 0) {
    Write-Log "Test signing disabled successfully."
  }
  else {
    Write-Log "Warning: Test signing disable returned exit code $LASTEXITCODE"
  }

  # Disable Flight Signing
  Write-Log "Disabling flight signing..."
  $flightSignResult = bcdedit /set flightsigning off
  if ($LASTEXITCODE -eq 0) {
    Write-Log "Flight signing disabled successfully."
  }
  else {
    Write-Log "Warning: Flight signing disable returned exit code $LASTEXITCODE"
  }

  # Check and disable Debug mode if enabled
  $debugStatus = bcdedit /enum | Select-String "debug"
  if ($debugStatus -match "Yes") {
    Write-Log "Debug mode detected. Disabling..."
    bcdedit /set debug off | Out-Null
    Write-Log "Debug mode disabled."
  }
  else {
    Write-Log "Debug mode not enabled."
  }

  Write-Log "MCAPS attestation fix completed successfully."
  Write-Log "IMPORTANT: A system restart is required for changes to take effect."

  # Exit with success code for Intune
  Exit 0

}
catch {
  Write-Log "ERROR: $($_.Exception.Message)"
  # Exit with failure code for Intune
  Exit 1
}
