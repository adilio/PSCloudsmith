[CmdletBinding()]
Param(
    [Parameter()]
    [Switch]
    $Build
)

process {
    $root = Split-Path -Parent $MyInvocation.MyCommand.Definition

    switch($true){
        $Build {

            $Output = Join-Path $root -ChildPath 'Output'
            $CloudsmithFolder = Join-Path $Output -ChildPath 'Cloudsmith'

            if(Test-Path "$root\Output"){
                Remove-Item "$root\Output\" -Recurse -Force
            }
            if(-not (Test-Path $Output)){
                $null = New-Item $Output -ItemType Directory
            }

            if(-not (Test-Path $CloudsmithFolder)){
                $null = New-Item $CloudsmithFolder -ItemType Directory
            }

            

            Get-ChildItem $root\src\public\ -Recurse -Filter *.ps1 | Foreach-Object {
                Get-Content $_.FullName | Add-Content "$root\Output\PSCloudsmith\PSCloudsmith.psm1" -Force
            }

            Get-ChildItem $root\src\private\ -Recurse -Filter *.ps1 | Foreach-Object { 
                Get-Content $_.FullName | Add-Content "$root\Output\PSCloudsmith\PSCloudsmith.psm1" -Force
            }

            Copy-Item $root\PSCloudSmith.psd1 -Destination $CloudsmithFolder
        }
    }
}