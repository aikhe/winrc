# Start the Komorebi daemon
komorebi

# Optional: If you use a specific configuration file layout (like komorebi.json), 
# komorebic start automatically looks for it in ~/.config/komorebi/komorebi.json.
# If you use a custom script configuration instead, uncomment and point to it here:
# & "$HOME\.config\komorebi\komorebi.ps1"

# Wait a brief moment to let Komorebi initialize before drawing the bar
Start-Sleep -Seconds 2

# Start YASB (Assumes 'yasb' is in your system PATH or installed via pip/exe)
# If it's an executable, call it directly:
yasb

# If you run YASB via python/pip, use this line instead:
# python -m yasb

