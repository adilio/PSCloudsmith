function Get-CloudsmithEntitlement {
    <#
    .SYNOPSIS
    Get Entitlement Tokens in a repository
    
    .DESCRIPTION
    Get Entitlement Tokens in a repository
    
    .PARAMETER Owner
    Repository owner (likely your username)
    
    .PARAMETER Repository
    Repository to query
    
    .PARAMETER Name
    Specific token to retrieve
    
    .PARAMETER ShowToken
    Show token in plain-text in returned results (Defaults to false)
    
    .EXAMPLE
    Get-CloudSmithEntitlement -Owner your-username -Repository your-repository

    .EXAMPLE
    Get-CloudsmithEntitlement -Owner your-username -Repository your-repository -Name TokenIdentifier

    .EXAMPLE
    Get-CloudsmithEntitlement -Owner your-username -Repository your-repository -ShowToken
    
    .NOTES
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Repository,

        [Parameter()]
        [Alias('SlugPerm')]
        [String[]]
        $Identifier,

        [Parameter()]
        [Switch]
        $ShowToken
    )

    begin {
        if (-not $header) {
            throw "Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!"
        }
    }

    process {
        if(-not $Name){
            $endpoint = "entitlements/$Owner/$Repository/?show_tokens=$ShowToken"
        }

        else {
            $endpoint = "entitlements/$Owner/$Repository/$Name/?show_tokens=$ShowToken"
        }

        try {
            $result = Invoke-Cloudsmith -Endpoint $endpoint -Method GET -ErrorAction Stop

            $result | Foreach-Object {
                [pscustomobject]@{
                    "created_at"             = $_.created_at
                    "created_by_url"         = $_.created_by_url
                    "clients"                = $_.clients
                    "downloads"              = $_.downloads
                    "default"                = $_.default
                    "disable_url"            = $_.disable_url
                    "enable_url"             = $_.enable_url
                    "eula_accepted"          = $_.eula_accepted
                    "eula_accepted_at"       = $_.eula_accepted_at
                    "eula_accepted_from"     = $_.eula_accepted_from
                    "eula_required"          = $_.eula_required
                    "has_limits"             = $_.has_limits
                    "identifier"             = $_.identifier
                    "is_active"              = $_.is_active
                    "is_limited"             = $_.is_limited
                    "limit_date_range_from"  = $_.limit_date_range_from
                    "limit_date_range_to"    = $_.limit_date_range_to
                    "limit_num_downloads"    = $_.limit_num_downloads
                    "limit_package_query"    = $_.limit_package_query
                    "limit_path_query"       = $_.limit_path_query
                    "limit_bandwidth"        = $_.limit_bandwidth
                    "limit_bandwidth_unit"   = $_.limit_bandwidth_unit
                    "metadata"               = $_.metadata
                    "name"                   = $_.name
                    "refresh_url"            = $_.refresh_url
                    "reset_url"              = $_.reset_url
                    "self_url"               = $_.self_url
                    "slug_perm"              = $_.slug_perm
                    "scheduled_reset_period" = $_.scheduled_reset_period
                    "scheduled_reset_at"     = $_.scheduled_reset_at
                    "token"                  = $_.token
                    "updated_at"             = $_.updated_at
                    "updated_by"             = $_.updated_by
                    "updated_by_url"         = $_.updated_by_url
                    "usage"                  = $_.usage
                    "user"                   = $_.user
                    "user_url"               = $_.user_url
                }
            }
        }
        catch {
            $_.Exception.Message
        }
            
            
        
    }
}