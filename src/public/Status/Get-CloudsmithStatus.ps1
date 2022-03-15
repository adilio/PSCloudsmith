function Get-CloudsmithStatus {
    $endpoint = "status/check/basic/"
    Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
}