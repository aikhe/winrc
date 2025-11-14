$Env:YAZI_FILE_ONE = 'C:\Program Files\Git\usr\bin\file.exe'

function Open-Neovide {
    param(
        [string]$path = "."
    )
    neovide --frame none $path
}

function Cd-Local { Set-Location C:\Users\aikhe\Desktop\ike\local }

function Cd-Neovim { Set-Location C:\Users\aikhe\AppData\Local\nvim }

function Cd-Winrc { Set-Location C:\Users\aikhe\Desktop\ike\local\winrc }

function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

Set-Alias -Name local -Value Cd-Local
Set-Alias -Name vim -Value Open-Neovide 
Set-Alias -Name winrc -Value Cd-Winrc
Set-Alias -Name nvimconf -Value Cd-Neovim
