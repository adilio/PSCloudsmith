function Get-CloudsmithPackageMetric {
    <#
    .SYNOPSIS
    Get package usage metrics, for a repository
    
    .DESCRIPTION
    Get package usage metrics, for a repository
    
    .PARAMETER Owner
    Your organization or username (likely your username)
    
    .PARAMETER Repository
    Repository to query
    
    .PARAMETER Finish
    Include metrics upto and including this UTC date or UTC datetime. For example '2020-12-31' or '2021-12-13T00:00:00Z'
    
    .PARAMETER Start
    Include metrics from and including this UTC date or UTC datetime. For example '2020-12-31' or '2021-12-13T00:00:00Z'
    
    .PARAMETER Package
    A comma seperated list of packages (slug perm) to include in the results.
    
    .EXAMPLE
    Get-CloudsmithPackageMetric -Owner yourusername -Repository yourrepository -Package packageA,packageB
    
    .EXAMPLE
    Get-CloudsmithPackageMetric -Owner yourusername -Repository yourrepository -Package packageA,packageB

    .EXAMPLE
    Get-CloudsmithPackageMetric -Owner yourusername -Repository yourrepository -Package packageA -Start (Get-Date).AddDays(-5)

    .EXAMPLE

    $params = @{
        Owner = 'yourusername'
        Repository = 'yourrepository'
        Package = @('packageA','packageB','packageC')
        Start = (Get-Date).AddDays(-5)
        Finish = (Get-Date).AddDays(-1)
    }

    Get-CloudsmithPackageMetric @params

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
        [Datetime]
        [Alias('To')]
        $Finish,

        [Parameter()]
        [Datetime]
        [Alias('From')]
        $Start,

        [Parameter()]
        [String[]]
        $Package
    )

    begin {
      if (-not $header) {
        throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
      }
    }

    process {
        $endpoint = "metrics/entitlements/$Owner/$Repository/"

            $queryParams = @()
         
            if($Finish){
                $Finish = $Finish.ToUniversalTime().ToString("yyyy-MM-dd")
                $finishslug = "finish=$Finish"
                $queryParams += $finishslug
            }

            if($Start){
                $Start = $Start.ToUniversalTime().ToString("yyyy-MM-dd")
                $startslug = "start=$Start"
                $queryParams += $startslug
            }

            if($Package){
                $Package = $Package -join ','
                $packageSlug = "tokens=$Package"
                $queryParams += $packageSlug
            }

            if($queryParams.Count -gt 0){
                $queryString = $queryParams -join '&'
                $endpoint = $endpoint + '?' + $queryString
                
                Write-Verbose $endpoint
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'Get'
            }
            else {
                Write-Verbose $endpoint
                Invoke-Cloudsmith -Endpoint $endpoint -Method 'Get'    
            }

        } 
        
    
}