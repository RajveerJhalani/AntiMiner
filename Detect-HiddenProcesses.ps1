# Detect-HiddenProcesses.ps1
Clear-Host

# Optional: Check for admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script is best run as Administrator for full access to all processes."
}

Write-Host "Step 1: Capturing running processes..." -ForegroundColor Cyan
$initialProcesses = Get-CimInstance Win32_Process | Select-Object ProcessId, Name, ExecutablePath, CommandLine

Write-Host "`nStep 2: Open Task Manager and then close it."
Read-Host "Press ENTER after Task Manager has been closed"

# Re-check processes
Write-Host "`nStep 3: Rechecking running processes..." -ForegroundColor Cyan
$currentPIDs = (Get-CimInstance Win32_Process).ProcessId

# Detect vanished processes
$disappeared = $initialProcesses | Where-Object { $currentPIDs -notcontains $_.ProcessId }

if ($disappeared.Count -eq 0) {
    Write-Host "`n✅ No processes disappeared after Task Manager opened." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Disappeared processes detected:" -ForegroundColor Yellow

    foreach ($proc in $disappeared) {
        Write-Host "`nName: $($proc.Name)"
        Write-Host "PID: $($proc.ProcessId)"
        Write-Host "ExecutablePath: $($proc.ExecutablePath)"
        Write-Host "CommandLine: $($proc.CommandLine)"

        $opened = $false

        # Attempt to open executable path
        if ($proc.ExecutablePath -and (Test-Path $proc.ExecutablePath)) {
            $exeDir = Split-Path $proc.ExecutablePath -Parent
            $windowsDir = [System.Environment]::GetFolderPath("Windows")
            $system32Dir = Join-Path $windowsDir "System32"

            if ($exeDir -notlike "$system32Dir*") {
                Write-Host "Opening folder for: $($proc.ExecutablePath)" -ForegroundColor Cyan
                Start-Process explorer.exe "/select,`"$($proc.ExecutablePath)`""
                $opened = $true
            } else {
                Write-Warning "Executable located in System32. Skipping folder open."
            }
        }

        # Fallback: Try to extract path from command line
        if (-not $opened -and $proc.CommandLine) {
            $matches = [regex]::Matches($proc.CommandLine, '"([^"]+)"')
            foreach ($match in $matches) {
                $path = $match.Groups[1].Value
                if (Test-Path $path) {
                    Write-Host "Opening from command line path: $path" -ForegroundColor Cyan
                    Start-Process explorer.exe "/select,`"$path`""
                    break
                }
            }
        }
    }
}

Write-Host "`nDone. Press any key to exit..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
