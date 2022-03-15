function Get-CloudsmithRateLimit {
    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {
        $endpoint = 'rates/limits/'

        $limit = Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'

        [pscustomObject]@{
            Interval = $limit.resources.core.interval
            Limit = $limit.resources.core.limit
            Remaining = $limit.resources.core.remaining
            Reset = $limit.resources.core.reset
            Reset_ISO_8601 = [DateTime]$limit.resources.core.reset_iso_8601
        }
    }
}