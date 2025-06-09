# AntiMiner

This script helps detect suspicious or hidden processes (like stealthy miners) that disappear when Task Manager is opened.

──────────────────────────────
 HOW TO USE:
──────────────────────────────

1. Right-click the script file (Detect-HiddenProcesses.ps1) → Click **Properties** → Ensure **Read-only** is checked (to protect from tampering).

2. To run it:

   A. Right-click the script file → Select **Run with PowerShell**.

   B. Follow the on-screen instructions.

──────────────────────────────
 WHAT THIS SCRIPT DOES:
──────────────────────────────

- Takes a snapshot of all currently running processes on your system.
- Asks you to press Enter (during this time, Task Manager can be opened).
- Compares before/after snapshots to detect processes that closed or vanished.
- For each disappeared process:
   - Shows its name, PID, and file path.
   - If possible, opens the folder where the file is located (unless it's in System32).
   - Tries to show the original file (like a .bat, .exe, or script) even if it launched through cmd.exe.

This is useful to catch malicious scripts or miners that close when they detect Task Manager.

──────────────────────────────
 SAFETY NOTICE:
──────────────────────────────

- This script does not modify, delete, or upload anything.
- It simply checks for processes and opens folders for review.
- If you're unsure about its safety, feel free to ask **ChatGPT**:

   > “Can you check if this PowerShell script is safe?”  
   > Then paste the entire contents of the `Detect-HiddenProcesses.ps1` file.

──────────────────────────────
 NOTES:
──────────────────────────────

- False positives are rare, but Windows Media Player and some built-in apps may still show as located in `C:\Windows\System32`. This is normal.
- Actual miners or hidden scripts usually won't run from that location — this script tries to reveal their true paths if possible.
- If you find something suspicious, you can right-click its file → **Open file location** → and consider uploading it to [VirusTotal.com].

──────────────────────────────

Created to help reveal stealthy processes that may be hiding in plain sight.
Stay safe.
