function Set-CloudSmithEntitlement {
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
        $Identifier,

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
        [String]
        [Alias('LimitPathQuery')]
        $Limit_Path_Query,

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
        $Name,

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
        $endpoint = "entitlements/$Owner/$Repository/$Name"

        $existingSettings = Get-CloudsmithEntitlement -Owner $Owner -Repository $Repository -Name $Name

        switch($true){
            $Is_Active {$existingSettings.is_active = [bool]$Is_Active}
            $Limit_Bandwidth {$existingSettings.limit_bandwidth = $Limit_Bandwidth}
            $Limit_Bandwidth_Unit {$existingSettings.limit_bandwidth_unit = $Limit_Bandwidth_Unit}
            $Limit_Date_Range_From {$existingSettings.limit_date_range_from = $Limit_Date_Range_From}
            $Limit_Date_Range_To {$existingSettings.limit_date_range_to = $Limit_Date_Range_To}
            $Limit_Num_Clients {$existingSettings.limit_num_clients = $Limit_Num_Clients}
            $Limit_Num_Downloads {$existingSettings.limit_num_downloads = $Limit_Num_Downloads}
            $Limit_Package_Query {$existingSettings.limit_package_query = $Limit_Package_Query}
            $Limit_Path_Query {$existingSettings.limit_path_query = $Limit_Path_Query}
            $MetaData {$existingSettings.metadata = $MetaData}
            $Name {$existingSettings.name = $Name}    
            $Scheduled_Reset_At {$existingSettings.scheduled_reset_at = $Scheduled_Reset_At}
            $Scheduled_Reset_Period {$existingSettings.scheduled_reset_period = $Scheduled_Reset_Period}
            $Token {$existingSettings.token = $Token}
        }

        $newSettings = @{}

        $existingSettings.psobject.properties | Foreach-Object { $newSettings[$_.Name] = $_.Value }
    
        Invoke-Cloudsmith -Endpoint $endpoint -Body $newSettings -Method 'PATCH'

    }
}