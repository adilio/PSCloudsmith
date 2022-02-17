function Get-CloudsmithRepository {
    <#
    .SYNOPSIS
    Retrieve CloudSmith repository information
    
    .DESCRIPTION
    Retrieve CloudSmith repository Information
    
    .PARAMETER Namespace
    The namespace to retrieve repository information from
    
    .PARAMETER Repository
    Retrieve only information for this repository
    
    .EXAMPLE
    Get-CloudsmithRepository

    .EXAMPLE
    Get-CloudsmithRepository -Namespace yourusername -Repository your-repo-name
    
    .NOTES
    
    #>
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
    <#
    .SYNOPSIS
    Create a new Cloudsmith Repository
    
    .DESCRIPTION
    Create a new Cloudsmith Repository
    
    .PARAMETER Owner
    The namespace to create the repository in. (Likely your username)
    
    .PARAMETER Name
    A descriptive name for the repository.
    
    .PARAMETER Type
    The repository type changes how it is accessed and billed. Private repositories can only be used on paid plans, but are visible only to you or authorised delegates. Public repositories are free to use on all plans and visible to all Cloudsmith users.
    
    .PARAMETER Slug
    Optional. The slug identifies the repository in URIs.
    
    .PARAMETER Description
    A description of the repository's purpose/contents.
    
    .PARAMETER StorageRegion
    The Cloudsmith region in which package files are stored.
    
    .PARAMETER IndexFiles
    If checked, files contained in packages will be indexed, which increase the synchronisation time required for packages. Note that it is recommended you keep this enabled unless the synchronisation time is significantly impacted.
    
    .EXAMPLE
    New-CloudSmithRepository -Owner yourusername -Name api-test -Type Public -Slug test-api-repo -Description 'Testing creation from API' 
    
    .NOTES
    General notes
    #>
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
        $endpoint = "repos/$Owner/"

        $Body = @{
            name = $Name
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
            $Body.Add('index_files',[bool]'False')
        } else {
            $Body.Add('index_files',[bool]'True')
        }

        Invoke-CloudSmith -Slug $endpoint -Method 'POST' -Body $Body
    }
}
function Remove-CloudsmithRepository {
    <#
    .SYNOPSIS
    Removes a CloudSmith Repository
    
    .DESCRIPTION
    Removes a CloudSmith Repository
    
    .PARAMETER Owner
    The namespace or owner of the repository (Likely your username)
    
    .PARAMETER Repository
    The repository to remove
    
    .PARAMETER Force
    Don't prompt for confirmation
    
    .EXAMPLE
    Remove-CloudsmithRepository -Owner yourusername -Reposistory your-repository-name
    
    .NOTES
    
    #>
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
            $Params.Add('Body', ($Body | ConvertTo-Json -Depth 3))
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
