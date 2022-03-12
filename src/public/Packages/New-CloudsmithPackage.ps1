function New-CloudsmithPackage {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $Owner = $cloudsmithDefaultParams['Owner'],

        [Parameter()]
        [String]
        $Repository = $cloudsmithDefaultParams['Repository'],

        [Parameter(Mandatory)]
        [ValidateScript({
                Test-Path $_
            })]
        [Alias('File')]
        $Artifact,

        [Parameter(Mandatory)]
        [String]
        $Format,

        [Parameter()]
        [String]
        $Checksum = (Get-FileHash $Artifact).Hash
    )

    begin {
        if (-not $header) {
            throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
        }
    }

    process {
        Write-Host "Validating checksum to determine upload method"
          
        $md5Hash = (Get-FileHash $Artifact -Algorithm MD5).Hash
        $sha256Hash = (Get-FileHash $Artifact -Algorithm SHA256).Hash

        $validmd5Hash = $md5Hash -eq $Checksum
        $validSHA256Hash = $sha256Hash -eq $Checksum

        $UrlParams = @{
            Owner      = $Owner
            Repository = $Repository
            Leaf   = Split-Path $Artifact -Leaf
            File = $Artifact
        }

        switch ($true) {
            $validmd5Hash {
                Write-Host 'MD5 hashes match'
                throw "MD5 hash detected. Please use a SHA256 checksum"
            }

            $validSHA256Hash {
                Write-Host 'SHA256 hashes match'
                $uploadHeader = @{
                    'Content-Sha256' = $Checksum
                }
                $UrlParams.Add('UploadHeader',$UploadHeader)
            }

            default {
                throw "Checksum not match $Checksum using SHA256. Please verify checksum and try again."
            }
        }

        $RequestId = Get-CloudsmithUploadIdentifier @UrlParams

        $completionParams = @{
            Owner = $Owner
            Repository = $Repository
            Identifier = $RequestId.identifier
            Format = $Format
        }

        Complete-CloudsmithUpload @completionParams
    }
}