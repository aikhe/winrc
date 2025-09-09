$Env:YAZI_FILE_ONE = 'C:\Program Files\Git\usr\bin\file.exe'

function Open-Neovide {
    param(
        [string]$path = "."
    )
    neovide --frame none $path
}
Set-Alias -Name vim -Value Open-Neovide 

function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}
