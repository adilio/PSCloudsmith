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