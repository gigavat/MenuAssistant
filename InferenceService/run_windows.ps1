# Start InferenceService on Windows native.
#
# Run from PowerShell in InferenceService/ directory:
#   .\run_windows.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path "venv")) {
    Write-Host "ERROR: venv/ not found. Run .\setup_windows.ps1 first." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path ".env")) {
    Write-Host "ERROR: .env not found. Run .\setup_windows.ps1 first." -ForegroundColor Red
    exit 1
}

# Load .env into process environment
Get-Content .env | ForEach-Object {
    if ($_ -match "^\s*([^#][^=]*)=(.*)$") {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}

# Hugging Face cache lives next to the script
$env:HF_HOME = "$PSScriptRoot\models_cache"

# Silence symlink warning on Windows — not fatal, cache just uses more space.
# To enable symlinks: activate Windows Developer Mode or run PowerShell as admin.
$env:HF_HUB_DISABLE_SYMLINKS_WARNING = "1"

& .\venv\Scripts\Activate.ps1

Write-Host "Starting InferenceService on http://0.0.0.0:8000" -ForegroundColor Cyan
Write-Host "(first request loads SDXL into VRAM ~30 sec)" -ForegroundColor Yellow

uvicorn app.main:app --host 0.0.0.0 --port 8000
