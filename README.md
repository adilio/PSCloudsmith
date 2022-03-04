# PSCloudsmith
PowerShell wrapper for Cloudsmith API


## Building the module

Run `./build.ps1 -Build` from the repository root

A fresh copy of the module will be placed in `Output\Cloudsmith`

## Testing the module

Run `Import-Module ./Output/PSCloudSmith/PSCloudsmith.psd1 -Force`
Verify with `Get-Command -Module PSCloudSmith`

**Make sure you run `Connect-CloudsmithInstance` before attempting any other commands!**

## Creating docs

1. Install PlatyPS PowerShell module: `Install-Module PlatyPS -Force`
2. Install mkdocs: `choco install mkdocs -y` or `brew install mkdocs` on MacOS
3. Generate markdown docs:

    **Easy Way:** `Import-Module ./Output/PSCloudsmith/PSCloudsmith.psd1 -Force ; New-MarkdownHelp -Module PSCloudsmith -OutputFolder ./docs/`

    **More structured way:**

    ```powershell
    Import-Module ./Output/PSCloudsmith/PSCloudsmith.psd1 -Force
    Get-Command -Module PSCloudsmith | Where-Object Name -match 'Repository' | Foreach-Object {
    New-MarkdownHelp -Command $_.Name -OutputFolder ./docs/Repository/
    }
    ```

Rinse and repeat for each type of function

## Testing docs site locally, and Deploying to GitHub Pages

1. Build site locally: `mkdocs serve`
2. Publish docs to GitHub Pages: mkdocs gh-deploy
