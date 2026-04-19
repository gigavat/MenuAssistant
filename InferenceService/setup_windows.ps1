# One-time setup for InferenceService on Windows native (no Docker).
#
# Prerequisites (install manually BEFORE running this):
#   1. Python 3.11 from https://www.python.org/downloads/
#      (check "Add Python to PATH" during install)
#   2. NVIDIA GPU driver (latest) — https://www.nvidia.com/Download/index.aspx
#      CUDA toolkit is NOT required — PyTorch bundles its own CUDA runtime.
#
# Run from PowerShell in InferenceService/ directory:
#   .\setup_windows.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== InferenceService Windows Native Setup ===" -ForegroundColor Cyan

# 1. Check Python
$pythonVersion = & python --version 2>&1
if ($LASTEXITCODE -ne 0 -or $pythonVersion -notmatch "Python 3\.1[0-2]") {
    Write-Host "ERROR: Python 3.10-3.12 required. Found: $pythonVersion" -ForegroundColor Red
    Write-Host "Install from https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}
Write-Host "[OK] $pythonVersion" -ForegroundColor Green

# 2. Check NVIDIA driver
$nvidiaSmi = & nvidia-smi 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: nvidia-smi not found. Install NVIDIA GPU driver." -ForegroundColor Red
    exit 1
}
Write-Host "[OK] NVIDIA driver detected" -ForegroundColor Green

# 3. Create venv
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Cyan
    python -m venv venv
}

# 4. Activate venv
& .\venv\Scripts\Activate.ps1

# 5. Upgrade pip
Write-Host "Upgrading pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip

# 6. Install PyTorch with CUDA 12.1
Write-Host "Installing PyTorch + CUDA 12.1 (large download ~2.5GB)..." -ForegroundColor Cyan
pip install torch==2.4.1 torchvision==0.19.1 --index-url https://download.pytorch.org/whl/cu121

# 7. Install core requirements
Write-Host "Installing core requirements..." -ForegroundColor Cyan
pip install -r requirements.txt

# 8. Try optional xformers (often fails on Windows — non-fatal)
Write-Host "Attempting optional xformers install..." -ForegroundColor Cyan
pip install -r requirements-optional.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "[WARN] xformers install failed. SDXL will fall back to attention slicing." -ForegroundColor Yellow
    Write-Host "       This is expected on Windows and not a blocker." -ForegroundColor Yellow
}

# 9. Verify CUDA is accessible
Write-Host "Verifying CUDA..." -ForegroundColor Cyan
$cudaCheck = python -c "import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0) if torch.cuda.is_available() else '')"
Write-Host $cudaCheck

if ($cudaCheck -notmatch "^True") {
    Write-Host "ERROR: PyTorch can't see the GPU." -ForegroundColor Red
    exit 1
}

# 10. Create .env if missing
if (-not (Test-Path ".env")) {
    Write-Host "Generating .env with random secret..." -ForegroundColor Cyan
    $secret = -join ((1..64) | ForEach-Object { '{0:x}' -f (Get-Random -Max 16) })
    @"
INFERENCE_SERVICE_SECRET=$secret
DEFAULT_MODEL=flux-schnell
"@ | Out-File -FilePath .env -Encoding ASCII -NoNewline
    Write-Host "[OK] .env created. Secret: $secret" -ForegroundColor Green
    Write-Host "     Copy this secret into Serverpod config/passwords.yaml" -ForegroundColor Yellow
} else {
    Write-Host "[OK] .env already exists" -ForegroundColor Green
}

# 11. Create models cache dir
$modelsDir = "$PSScriptRoot\models_cache"
if (-not (Test-Path $modelsDir)) {
    New-Item -ItemType Directory -Path $modelsDir | Out-Null
}

# 12. Check Hugging Face authentication — Flux Schnell is gated.
Write-Host "Checking Hugging Face authentication..." -ForegroundColor Cyan
$hfTokenPath = "$env:USERPROFILE\.cache\huggingface\token"
if (-not (Test-Path $hfTokenPath)) {
    Write-Host "[WARN] No Hugging Face token found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Flux Schnell is a gated model. You need to:" -ForegroundColor Yellow
    Write-Host "  1. Create a free HF account at https://huggingface.co/join" -ForegroundColor Yellow
    Write-Host "  2. Visit https://huggingface.co/black-forest-labs/FLUX.1-schnell" -ForegroundColor Yellow
    Write-Host "     and click 'Agree and access repository' (Apache 2.0 license)" -ForegroundColor Yellow
    Write-Host "  3. Create a read token at https://huggingface.co/settings/tokens" -ForegroundColor Yellow
    Write-Host "  4. Run: huggingface-cli login" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternatively, set DEFAULT_MODEL=sdxl in .env to skip Flux entirely." -ForegroundColor Yellow
} else {
    Write-Host "[OK] HF token found at $hfTokenPath" -ForegroundColor Green
}

Write-Host "`n=== Setup complete ===" -ForegroundColor Green
Write-Host "Next: run .\run_windows.ps1 to start the service"
Write-Host "First start downloads Flux Schnell (~17GB: 7GB GGUF + 10GB T5 + VAE/CLIP)"
Write-Host "Download takes ~5-15 min depending on connection."
