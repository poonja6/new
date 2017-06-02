Function Get-RedirectedUrl
{
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )
 
    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()
 
    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

$url = 'http://get.videolan.org/vlc/2.2.4/win32/vlc-2.2.4-win32.exe'
$codeSetupUrl = Get-RedirectedUrl -URL $url

$infPath = $PSScriptRoot + "\vlc.inf"
$VlcSetup = "${env:Temp}\vlc-2.2.4-win32.exe"

try
{
    (New-Object System.Net.WebClient).DownloadFile($codeSetupUrl, $VlcSetup)
}
catch
{
    Write-Error "Failed to download VLC Setup"
}

try
{
    Start-Process -FilePath $VlcSetup -ArgumentList "/VERYSILENT /MERGETASKS=!runcode /LOADINF=$infPath"
}
catch
{
    Write-Error 'Failed to install VLC Player'
}