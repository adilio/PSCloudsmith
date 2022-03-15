function Get-CloudsmithUser {
  [Cmdletbinding()]
  Param(
    [Parameter()]
    [String]
    $Slug
  )
  begin {
    if (-not $header) {
      throw 'Not connected to Cloudsmith API! Run Connect-CloudsmithInstance first!'
    }
  }

  process {
    
    if ($Slug) {
      $endpoint="users/profile/$Slug/"
    }

    else {
      $endpoint = 'user/self/'
    }

    Invoke-Cloudsmith -Endpoint $endpoint -Method 'GET'
    
  }
}