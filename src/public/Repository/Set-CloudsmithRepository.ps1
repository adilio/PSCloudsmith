function Set-CloudsmithRepository {
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

        $endpoint = "repos/$Owner/$Name/"
        $existingSettings = Get-CloudsmithRepository -Owner $Owner -Repository $Name

        switch($true){
            $Type { $existingSettings.repository_type_str = $Type}
            $Slug { $existingSettings.slug = $Slug}
            $Description {$existingSettings.description = $Description}
            $StorageRegion { $existingSettings.storage_region}
            $IndexFiles { $existingSettings.index_files = $IndexFiles}
        }

        $newSettings = @{}

        $existingSettings.psobject.properties | Foreach-Object { $newSettings[$_.Name] = $_.Value }
    
        Invoke-Cloudsmith -Endpoint $endpoint -Body $newSettings -Method 'PATCH'
    
    }
}