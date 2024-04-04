Param(
    [Parameter(Mandatory = $false)]
    [string]$caffeinPath = "C:\Users\benme\tools\caffeine\caffeine64.exe",
    [Parameter(Mandatory = $false)]
    [string]$arguments = "-activefor:1440"
)

Start-Process -FilePath $caffeinPath -ArgumentList $arguments
