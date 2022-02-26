function Get-CloudsmithOrg {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $Org
    )
    
    begin {
        if (-not $header) {
            throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
        }
    }

    process {
        $endpoint = 'orgs/'

        if($Org){
            $endpoint = $endpoint + $Org + '/'
        }

        Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
    }
}