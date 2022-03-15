function Connect-CloudsmithInstance {
    [CmdletBinding(DefaultParameterSetName='Credential')]
    Param(
        [Parameter(Mandatory,ParameterSetName="Credential")]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory,ParameterSetName='Token')]
        [Alias('Token')]
        [String]
        $ApiKey
    )

    switch($PSCmdlet.ParameterSetName){
        'Token' {
            $script:header = @{
                Authorization = "token $ApiKey"
            }
        }

        'Credential' {
            $pair = "$($Credential.UserName  ):$($Credential.GetNetworkCredential().Password)"
            $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

            $script:header = @{
                Authorization = "Basic $encodedCreds"
            }
        }
    }

    Write-Host "Successfully authenticated to CloudSmith" -ForegroundColor Green

}