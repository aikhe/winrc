function Open-Neovide {
    param(
        [string]$path = "."
    )
    neovide --frame none $path
}
Set-Alias -Name vim -Value Open-Neovide 

