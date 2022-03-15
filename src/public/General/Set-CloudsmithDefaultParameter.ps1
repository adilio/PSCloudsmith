function Set-CloudsmithDefaultParameter {
    [CmdletBinding(DefaultParameterSetName = 'Owner')]
    Param(
        [Parameter()]
        [String]
        $Owner,

        [Parameter()]
        [String]
        $Repository
    )

    begin {
        if (-not $header) {
            throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
        }
    }

    process {

        if (-not $cloudSmithDefaultParams) {
            $script:cloudSmithDefaultParams = @{}
        }

        if($Owner){
            $cloudsmithDefaultParams.Add('Owner',$Owner)
        }
        if($Repository){
            $cloudSmithDefaultParams.Add('Repository',$Repository)
        }
        
    }
}