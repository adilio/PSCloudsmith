# PSCloudsmith
PowerShell wrapper for Cloudsmith API


## Building the module

Run `./build.ps1 -Build` from the repository root

A fresh copy of the module will be placed in `Output\CloudSmith`

## Testing the module

Run `Import-Module ./Output/CloudSmith/CloudSmith.psd1 -Force`
Verify with `Get-Command -Module CloudSmith`

**Make sure you run `Connect-CloudsmithInstance` before attempting any other commands!**
