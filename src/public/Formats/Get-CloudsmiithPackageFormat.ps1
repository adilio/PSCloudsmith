function Get-CloudsmithPackageFormat {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String[]]
        $Format
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {

        if(-not $Format){
            $endpoint = 'formats/'

            Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'

        } else {
            $Format | Foreach-Object {
                $endpoint = "formats/$_"
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
            }
        }
    }
}