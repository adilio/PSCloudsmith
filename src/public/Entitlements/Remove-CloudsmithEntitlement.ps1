function Remove-CloudsmithEntitlement {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Repository,
        
        [Parameter(Mandatory)]
        [Alias('slug_perm')]
        [String]
        $Identifier,

        [Parameter()]
        [Switch]
        $Force
    )

    begin {
        if (-not $header) {
            throw "Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!"
        }
    }
    
    process {
        $endpoint = "entitlements/$Owner/$Repository/$Identifier/"

        if ($Force -and -not $Confirm) {
            $ConfirmPreference = 'None'
            if ($PSCmdlet.ShouldProcess($_, "Remove Entitlement")) {
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'DELETE'
            }
        }

        else {
            if ($PSCmdlet.ShouldProcess($_, "Remove Entitlement")) {
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'DELETE'
            }
        }
    }
}