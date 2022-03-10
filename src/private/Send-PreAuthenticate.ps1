function Send-PreAuthenticate
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url

    )

    $response = $null;
    try
    {
        [System.Uri]$uri = $Url;
        $repositoryAuthority = (($uri.GetLeftPart([System.UriPartial]::Authority)).TrimEnd('/') + '/');
        Write-Verbose "Send-PreAuthenticate - Sending HEAD to $repositoryAuthority";
        $wr = [System.Net.WebRequest]::Create($repositoryAuthority);
        $wr.Method = "HEAD";
        $wr.PreAuthenticate = $true;
        $wr.Headers["Authorization"] = $header['Authorization']
        $response = $wr.GetResponse();
    }
    finally
    {
        if ($response)
        {
            $response.Close();
            $response.Dispose();
            $response = $null;
        }
    }
}