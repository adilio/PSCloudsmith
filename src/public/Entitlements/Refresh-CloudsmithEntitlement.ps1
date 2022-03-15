function Refresh-CloudsmithEntitlement {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Repository,

        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter()]
        [Switch]
        $ShowToken,

        [Parameter()]
        [Switch]
        [Alias('Active')]
        $Is_Active,

        [Parameter()]
        [String]
        [Alias('LimitBandwidth')]
        $Limit_Bandwidth,

        [Parameter()]
        [String]
        [Alias('LimitBandwidthUnit')]
        $Limit_Bandwidth_Unit,

        [Parameter()]
        [String]
        [Alias('LimitDateFrom')]
        $Limit_Date_Range_From,

        [Parameter()]
        [String]
        [Alias('LimitDateTo')]
        $Limit_Date_Range_To,

        [Parameter()]
        [Int]
        [Alias('LimitNumberClients')]
        $Limit_Num_Clients,

        [Parameter()]
        [Int]
        [Alias('LimitNumberDownloads')]
        $Limit_Num_Downloads,

        [Parameter()]
        [String]
        [Alias('LimitPackageQuery')]
        $Limit_Package_Query,

        [Parameter()]
        [Hashtable]
        $MetaData,

        [Parameter()]
        [String]
        [Alias('ScheduledResetAt')]
        $Scheduled_Reset_At,

        [Parameter()]
        [String]
        [Alias('ScheduledResetPeriod')]
        $Scheduled_Reset_Period,

        [Parameter()]
        [String]
        $Token
    )

    begin {
        if (-not $header) {
            throw "Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!"
        }
    }

    process {
        $endpoint = "entitlements/$Owner/$Repository/$Name/refresh/?show_tokens=$ShowToken"

        $Body = @{}

        foreach ($BoundParameter in $PSBoundParameters.GetEnumerator()) {
            if ($BoundParameter.Key -notin 'Owner', 'Repo', 'Name') {
                if ($BoundParameter.Key -eq 'Is_Active') {
                    $Body.Add($($BoundParameter.Key.ToLower()),[bool]$($BoundParameter.Value))
                }

                else {
                    $Body.Add($($BoundParameter.Key.ToLower()), $($BoundParameter.Value))
                }
            }
        }

        if($Body.Count -gt 0){
            Invoke-Cloudsmith -Endpoint $endpoint -Method 'POST' -Body $Body
        }

        else {
            Invoke-Cloudsmith -Endpoint $endpoint -Method 'POST'
        }
    }
}