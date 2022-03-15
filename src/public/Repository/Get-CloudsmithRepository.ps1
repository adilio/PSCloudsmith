function Get-CloudsmithRepository {
    <#
    .SYNOPSIS
    Retrieve CloudSmith repository information
    
    .DESCRIPTION
    Retrieve CloudSmith repository Information
    
    .PARAMETER Namespace
    The namespace to retrieve repository information from
    
    .PARAMETER Repository
    Retrieve only information for this repository
    
    .EXAMPLE
    Get-CloudsmithRepository

    .EXAMPLE
    Get-CloudsmithRepository -Namespace yourusername -Repository your-repo-name
    
    .NOTES
    
    #>
    [CmdletBinding(DefaultParameterSetName='Default')]
    Param(
        [Parameter(Mandatory,ParameterSetName='Owner')]
        [Alias('Owner')]
        [String]
        $Namespace,

        [Parameter(ParameterSetName='Owner')]
        [String]
        $Repository
    )
    begin {
        if(-not $header){
            throw "Not connected to CloudSmith API!"
        }
    }
    process {
        switch($PSCmdlet.ParameterSetName){
            'Owner' {
                $slug = "repos/$Namespace/"
    
                if($Repository){
                    $slug = $slug + "$Repository/"
                }
    
                Invoke-Cloudsmith -Slug $slug -Method 'GET'
            }

            default {
                $slug = 'repos/'
                Invoke-Cloudsmith -Slug $slug -Method 'GET'
            }
        }
    }
    
}