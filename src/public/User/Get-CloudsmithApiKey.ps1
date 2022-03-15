function Get-CloudsmithApiKey {
    [CmdletBinding(DefaultParameterSetName='None')]
    Param(
        [Parameter(Mandatory,ParameterSetName='user')]
        [String]
        $EmailAddress,

        [Parameter(Mandatory,ParameterSetName='user')]
        [SecureString]
        $Password,

        [Parameter(Mandatory,ParameterSetName='credential')]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {

        switch($PSCmdlet.ParameterSetName){
            'user' {
                $Credential = [System.Management.Automation.PSCredential]::new('dummy',$Password)
                $endpoint = 'user/token/'

                $body = @{
                    email = $EmailAddress
                    password = $Credential.GetNetworkCredential().Password
                }

                Invoke-Cloudsmith -Endpoint $endpoint -Body $body -Method 'POST'
        
            }

            'credential' {
                $endpoint = 'user/token/'

                $Body = @{
                    email = $Credential.UserName
                    password = $Credential.GetNetworkCredential().Password
                }

                Invoke-Cloudsmith -Endpoint $endpoint -Body $body -Method 'POST'
            }

            default {
                $endpoint = 'user/token/'
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'POST'
        
            }
        }

    }
}