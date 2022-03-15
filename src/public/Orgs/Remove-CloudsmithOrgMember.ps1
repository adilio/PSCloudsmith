function Remove-CloudsmithOrgMember {
    [CmdletBinding(ConfirmImpact='High',SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $Org,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [Alias('user')]
        [String]
        $Username
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {
        $endpoint = "orgs/$Org/members/$Username/remove/"

        if ($Force -and -not $Confirm) {
            $ConfirmPreference = 'None'
            if ($PSCmdlet.ShouldProcess($Username, "Remove User")) {
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
            }
        }

        else {
            if ($PSCmdlet.ShouldProcess($Username, "Remove User")) {
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
            }
        }
    }
}