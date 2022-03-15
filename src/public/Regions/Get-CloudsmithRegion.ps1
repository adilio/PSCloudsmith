function Get-CloudsmithRegion {
    <#
    .SYNOPSIS
    Get a storage region information from Cloudsmith
    
    .DESCRIPTION
    Get storage region information from Cloudsmith
    
    .PARAMETER Slug
    Get a specif storage region
    
    .EXAMPLE
    Get-CloudsmithRegion

    .EXAMPLE
    Get-CloudsmithRegion -Slug 'us-ohio'
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [Alias('Name')]
        $Slug
    )

    begin {
        if(-not $header){
            throw "Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!"
        }
    }
    
    process {
        $endpoint = 'storage-regions/'

        if($Slug){
            $endpoint = 'storage-regions/' + "$Slug/"
        }

        Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
    }
}