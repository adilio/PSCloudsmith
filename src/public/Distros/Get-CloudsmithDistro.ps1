function Get-CloudsmithDistro {
    [CmdletBinding()]
    Param(
        [Parameter()]    
        [String[]]
        $Distro
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {
        if(-not $Distro){
            $endpoint = 'distros/'
            Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
        }
        else {
            $Distro | Foreach-Object {
                $endpoint = "distros/$_/"
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
            }
        }
    }
}