# AVD MCAPS Attestation Fix

## Overview
This script fixes VM attestation failures in Microsoft Defender for Cloud (MDC) for Azure Virtual Desktop hosts managed by MCAPS.

## Problem
MCAPS-managed CDX tenants report attestation failures with the error:
> "Your virtual machine failed attestation because test signing is enabled on it. Flight signing, or test signing, can allow test bits to run on your virtual machine. Disabling this mode will prevent unofficial OS binaries from running."

## Solution
The script disables:
- **Test signing** - Prevents unsigned test binaries from running
- **Flight signing** - Prevents flight/preview OS bits from running
- **Debug mode** - If enabled, also disabled to meet attestation requirements

## Deployment
**Target**: AVD managed Intune devices
**Method**: Deploy as remediation script via Intune
**Requires**: Administrator privileges
**Reboot**: Required for changes to take effect

## Intune Configuration
1. Navigate to **Devices > Scripts** in Intune
2. Add the script as a PowerShell script
3. Target your AVD device group
4. Run as **System** context
5. Monitor exit codes: 0 = Success, 1 = Failure

## Logs
Script logs are written to: `C:\Temp\AVD-MCAPS-AttestationFix.txt`

## Version History
- **v1.0** - Initial release (April 2026)
