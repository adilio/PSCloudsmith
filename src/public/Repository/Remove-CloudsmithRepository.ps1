function Remove-CloudsmithRepository {
    <#
    .SYNOPSIS
    Removes a CloudSmith Repository
    
    .DESCRIPTION
    Removes a CloudSmith Repository
    
    .PARAMETER Owner
    The namespace or owner of the repository (Likely your username)
    
    .PARAMETER Repository
    The repository to remove
    
    .PARAMETER Force
    Don't prompt for confirmation
    
    .EXAMPLE
    Remove-CloudsmithRepository -Owner yourusername -Reposistory your-repository-name
    
    .NOTES
    
    #>
    [CmdletBinding(ConfirmImpact = 'High',SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory)]
        [Alias('Namespace')]
        [String]
        $Owner,

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String[]]
        $Repository,

        [Parameter()]
        [Switch]
        $Force
    )

    begin { 
        if (-not $header) { 
            throw "Not connected to CloudSmith API! Run Connect-CloudsmithInstance first!"
        }
    }

    process {
        
        $Repository | Foreach-Object {
            $endpoint = "repos/$Owner/$_"


            if ($Force -and -not $Confirm) {
                $ConfirmPreference = 'None'
                if ($PSCmdlet.ShouldProcess("$_", "Remove Repository")){
                    Invoke-CloudSmith -Slug $endpoint -Method 'DELETE'
                }
            }

            else {
                if($PSCmdlet.ShouldProcess("$_","Remove Repository")){
                    Invoke-CloudSmith -Slug $endpoint -Method 'DELETE'
                }
            }
        }

    }
}