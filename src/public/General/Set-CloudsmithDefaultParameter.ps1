function Set-CloudsmithDefaultParameter {
    [CmdletBinding(DefaultParameterSetName = 'Owner')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'Owner')]
        [String]
        $Owner,

        [Parameter(Mandatory, ParameterSetName = 'Repository')]
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
            $cloudSmithDefaultParams = @{}
        }
        switch ($PSCmdlet.ParameterSetName) {
            'Owner' {
                $cloudSmithDefaultParams.Add('Owner', $Owner)
            }

            'Repository' {
                $cloudSmithDefaultParams.Add('Repository', $Repository)
            }
        }
    }
}