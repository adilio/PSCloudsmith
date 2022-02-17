function Get-CloudsmithRepository {
    [CmdletBinding(DefaultParameterSetName='Default')]
    Param(
        [Parameter(Mandatory,ParameterSetName='Owner')]
        [Alias('Owner')]
        [String]
        $Namespace,

        [Parameter(ParameterSetName='Owner')]
        [String]
        $Repository
    )
    begin {
        if(-not $header){
            throw "Not connected to CloudSmith API!"
        }
    }
    process {
        switch($PSCmdlet.ParameterSetName){
            'Owner' {
                $slug = 'repos/'
    
                if($Repository){
                    $slug = $slug + "$Repository/"
                }
    
                Invoke-Cloudsmith -Slug $slug -Method 'GET'
            }

            default {
                $slug = 'repos/'
                Invoke-Cloudsmith -Slug $slug -Method 'GET'
            }
        }
    }
    
}
function New-CloudSmithRepository {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [Alias('Namespace')]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('Public','Private')]
        [String]
        $Type,

        [Parameter()]
        [String]
        $Slug,

        [Parameter()]
        [String]
        $Description,

        [Parameter()]
        [String]
        $StorageRegion,

        [Parameter()]
        [bool]
        $IndexFiles = $true
    )

    begin {
        if(-not $header){
            throw "Not connected to CloudSmith API! Run Connect-CloudSmithInstance first!"
        }
    }

    process {
        $endpoint = "repos/$Owner"

        $Body = @{
            mame = $Name
        }

        if($Type){
            $Body.Add('repository_type_str',$Type)
        }

        if($Slug){
            $Body.Add('slug',$Slug)
        }

        if($Description){
            $Body.Add('description',$Description)
        }

        if($StorageRegion){
            $Body.Add('storage_region',$StorageRegion)
        }

        if($IndexFiles -eq $false){
            $Body.Add('index_files',$false)
        } else {
            $Body.Add('index_files',$true)
        }

        Invoke-CloudSmith -Slug $endpoint -Method 'POST' -Body $Body
    }
}
function Remove-CloudsmithRepository {
    [CmdletBinding(ConfirmImpact = 'High',SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory)]
        [Alias('Namespace')]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Repository,

        [Parameter()]
        [Switch]
        $Force
    )

    begin { 
        if (-not $header) { 
            throw "Not connected to CloudSmith API! Run Connect-CloudsmithInstance first!"
        }
    }

    process {
        
        $Repository | Foreach-Object {
            $endpoint = "repos/$Owner/$_"


            if ($Force -and -not $Confirm) {
                $ConfirmPreference = 'None'
                if ($PSCmdlet.ShouldProcess("$_", "Remove Repository")){
                    Invoke-CloudSmith -Slug $endpoint -Method 'DELETE'
                }
            }

            else {
                if($PSCmdlet.ShouldProcess("$_","Remove Repository")){
                    Invoke-CloudSmith -Slug $endpoint -Method 'DELETE'
                }
            }
        }

    }
}
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
function Invoke-CloudSmith {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Slug,

        [Parameter()]
        [Hashtable]
        $Body,

        [Parameter()]
        [Array]
        $BodyAsArray,

        [Parameter()]
        [String]
        $BodyAsString,

        [Parameter()]
        [SecureString]
        $BodyAsSecureString,

        [Parameter()]
        [String]
        $File,

        [Parameter()]
        [String]
        $ContentType = 'application/json',

        [Parameter()]
        [String]
        $Method
    )

    process {
        
        $BaseUri = "https://api.cloudsmith.io/v1/"
        $Uri = $BaseUri + $Slug

        $Params = @{
            Headers         = $header
            ContentType    = $ContentType
            Uri             = $Uri
            Method          = $Method
            UseBasicParsing = $true
        }

        if ($Body) {
            $Params.Add('Body', $Body)
        }

        if ($BodyAsArray) {
            $Params.Add('Body', ($BodyAsArray | ConvertTo-Json -Depth 3))
        }

        if ($BodyAsString) {
            $Params.Add('Body', $BodyAsString)
        }

        if ($BodyAsSecureString) {
            $Params.Add('Body',
                [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($BodyAsSecureString)
                )
            )
        }

        if($File){
            $Params.Remove('ContentType')
            $Params.Add('InFile',$File)
        }

        Write-Verbose "$($Body | ConvertTo-Json)"

       
         Invoke-RestMethod @Params
        
        
    }
}
