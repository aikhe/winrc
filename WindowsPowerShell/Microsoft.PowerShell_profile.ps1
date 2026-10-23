$Env:YAZI_FILE_ONE = 'C:\Program Files\Git\usr\bin\file.exe'

# function Open-Neovide {
#     param(
#         [string]$path = "."
#     )
#     neovide --frame none $path
# }

function Cd-Local { Set-Location C:\Users\aikhe\Desktop\ike\local }

function Cd-Neovim { Set-Location C:\Users\aikhe\AppData\Local\nvim }

function Cd-Winrc { Set-Location C:\Users\aikhe\Desktop\ike\local\winrc }

function Cd-Openclaw { Set-Location "$HOME\.openclaw" }

# Quick start for Komorebi tiling window manager
function komorebi { komorebic start --whkd }

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
# Set-Alias -Name vim -Value Open-Neovide 
Set-Alias -Name winrc -Value Cd-Winrc
Set-Alias -Name nvimconf -Value Cd-Neovim
Set-Alias -Name oc -Value Cd-Openclaw

function stopshim {
    $found = $false
    Get-CimInstance Win32_Process -Filter "Name='node.exe'" |
        Where-Object { $_.CommandLine -match "opencode-shim" } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force; "stopped shim (pid $($_.ProcessId))"; $found = $true }
    if (-not $found) { "shim not running" }
}

function op {
    # Start opencode fingerprint shim (needed for free-tier models) if not running
    try {
        Invoke-RestMethod -Uri "http://127.0.0.1:18791/health" -TimeoutSec 2 | Out-Null
    } catch {
        Start-Process -FilePath "node" -ArgumentList "`"C:\Users\aikhe\.openclaw\shim\opencode-shim.mjs`"" -WindowStyle Hidden
        Start-Sleep 2
    }
    openclaw gateway run $args
}

function opt {
    openclaw gateway auth-token --show
}

function oca {
    opencode --auto @args
}

# Set-Location "C:\Users\aikhe\Desktop\ike\local"

# Start Komorebi and WHKD together
# Start-Process -FilePath "komorebic.exe" -ArgumentList "start --whkd" -WindowStyle Hidden
# Start YASB
# Start-Process -FilePath "yasb.exe" -WindowStyle Hidden

# Report cwd to WezTerm on every prompt so session saves record real dirs
$Global:__orig_prompt = (Get-Item function:prompt -ErrorAction SilentlyContinue).ScriptBlock
function global:prompt {
    $uri = "file://localhost/" + ((Get-Location).Path -replace '\\','/' -replace ' ','%20')
    Write-Host -NoNewline "$([char]27)]7;$uri$([char]7)"
    if ($Global:__orig_prompt) { & $Global:__orig_prompt } else { "PS $(Get-Location)> " }
}
