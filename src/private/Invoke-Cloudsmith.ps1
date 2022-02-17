function Invoke-CloudSmith {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Slug,

        [Parameter()]
        [Hashtable]
        $Body,

        [Parameter()]
        [Array]
        $BodyAsArray,

        [Parameter()]
        [String]
        $BodyAsString,

        [Parameter()]
        [SecureString]
        $BodyAsSecureString,

        [Parameter()]
        [String]
        $File,

        [Parameter()]
        [String]
        $ContentType = 'application/json',

        [Parameter()]
        [String]
        $Method
    )

    process {
        
        $BaseUri = "https://api.cloudsmith.io/v1/"
        $Uri = $BaseUri + $Slug

        $Params = @{
            Headers         = $header
            ContentType    = $ContentType
            Uri             = $Uri
            Method          = $Method
            UseBasicParsing = $true
        }

        if ($Body) {
            $Params.Add('Body', ($Body | ConvertTo-Json -Depth 3))
        }

        if ($BodyAsArray) {
            $Params.Add('Body', ($BodyAsArray | ConvertTo-Json -Depth 3))
        }

        if ($BodyAsString) {
            $Params.Add('Body', $BodyAsString)
        }

        if ($BodyAsSecureString) {
            $Params.Add('Body',
                [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($BodyAsSecureString)
                )
            )
        }

        if($File){
            $Params.Remove('ContentType')
            $Params.Add('InFile',$File)
        }

        Write-Verbose "$($Body | ConvertTo-Json)"

       
         Invoke-RestMethod @Params
        
        
    }
}