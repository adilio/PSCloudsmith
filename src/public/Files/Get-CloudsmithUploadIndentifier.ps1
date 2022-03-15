function Get-CloudsmithUploadIdentifier {
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
        $File,

        [Parameter(Mandatory)]
        [String]
        $Leaf,

        [Parameter(Mandatory)]
        [Hashtable]
        $UploadHeader
    )

    begin {
        if (-not $header) {
            throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
        }
    }

    process {
        $uri = "https://upload.cloudsmith.io/$Owner/$Repository/$Leaf"
        $idHeader = $header.Clone()
        $idHeader.Add('Content-Sha256',$($UploadHeader['Content-Sha256']))
        $identifier = Invoke-RestMethod -Uri $uri -Method 'PUT' -Headers $idHeader -InFile $File

        return $identifier
    }
}