function Complete-CloudsmithUpload {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Repository,

        [Parameter(Mandatory)]
        [String]
        $Identifier
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {

        $endpoint = "packages/$Owner/$Repository/upload/nuget/"

        $Body = @{
            package_file = $Identifier
        }

        Invoke-Cloudsmith -Endpoint $endpoint -Body $body -Method 'POST'
    }
}