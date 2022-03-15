function Enable-CloudsmithEntitlement {
    [CmdletBinding()]
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
        $Identifier
    )

    begin {
        if (-not $header) {
            throw "Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!"
        }
    }
    
    process {
        $endpoint = "entitlements/$Owner/$Repository/$Identifier/enable/"

        Invoke-Cloudsmith -Endpoint $endpoint -Method 'POST'
    }
}