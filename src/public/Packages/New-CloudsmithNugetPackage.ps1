function New-CloudsmithNugetPackage {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Owner,

        [Parameter(Mandatory)]
        [String]
        $Repository,

        [Parameter(Mandatory)]
        [ValidateScript({
                Test-Path $_
            })]
        [Alias('File', 'NupkgFile')]
        $Nupkg,

        [Parameter()]
        [String]
        $Checksum = (Get-FileHash $Nupkg).Hash
    )

    begin {
        if (-not $header) {
            throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
        }
    }

    process {
        Write-Host "Validating checksum to determine upload method"
          
        $md5Hash = (Get-FileHash $Nupkg -Algorithm MD5).Hash
        $sha256Hash = (Get-FileHash $Nupkg -Algorithm SHA256).Hash

        $validmd5Hash = $md5Hash -eq $Checksum
        $validSHA256Hash = $sha256Hash -eq $Checksum

        $UrlParams = @{
            Owner      = $Owner
            Repository = $Repository
            Leaf   = Split-Path $Nupkg -Leaf
            File = $Nupkg
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
        }

        Complete-CloudsmithUpload @completionParams
    }
}