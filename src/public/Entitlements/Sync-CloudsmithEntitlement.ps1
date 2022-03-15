function Sync-CloudsmithEntitlement {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Source,

        [Parameter(Mandatory)]
        [String]
        $Destination,

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
        $endpoint = "entitlements/$owner/$Destination/sync/?show_tokens=$ShowToken"

        $Body = @{ source = $Source}
       
        $result = Invoke-Cloudsmith -Endpoint $endpoint -Method 'POST' -Body $Body

        $result.tokens | Foreach-Object {
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
        
        
}