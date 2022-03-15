function Get-CloudsmithOrgMember {
    [CmdletBinding(DefaultParameterSetName='default')]
    Param(
        [Parameter(Mandatory,ParameterSetName='default')]
        [Parameter(ParameterSetName='User',Mandatory)]
        [String]
        $Org,

        [Parameter(ParameterSetName='User',Mandatory)]
        [String]
        $User
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {
        switch($PSCmdlet.ParameterSetName){
            'User' {
                $endpoint = "orgs/$Org/members/$User/"
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
            }

            default {
                $endpoint = "orgs/$Org/members/"
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
            }
        }
    }
}