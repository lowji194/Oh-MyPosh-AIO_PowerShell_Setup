#Requires -Version 5.1
<#
.SYNOPSIS
    Script cai dat AIO (All-In-One) lam dep PowerShell 7 + Windows Terminal
.DESCRIPTION
    Tu dong cai dat va cau hinh:
    - Oh My Posh (theme prompt mac dinh: Dracula, load THEME LOCAL, khong can mang)
    - Nerd Font (CascadiaCode)
    - PSReadLine (autocomplete + syntax highlight)
    - Terminal-Icons (icon cho file/folder)
    - zoxide (nhay thu muc thong minh)
    - posh-git (trang thai Git tren prompt + tab-completion)
    - PSFzf (fuzzy finder cho lich su lenh & file)
    - (Tuy chon) ImportExcel, Pester, PSScriptAnalyzer, SecretManagement, BurntToast
    - File $PROFILE hoan chinh
.NOTES
    Chay script nay bang PowerShell 7 (pwsh.exe), voi quyen Administrator de winget hoat dong on dinh.
    Viet Boi Loi Nguyen - lowji194.github.io.vn
#>

# ============================================================
#  KIEM TRA MOI TRUONG
# ============================================================

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   CAI DAT AIO - LAM DEP POWERSHELL 7 (Theme: Dracula)" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "[CANH BAO] Ban dang chay PowerShell $($PSVersionTable.PSVersion). Khuyen nghi dung PowerShell 7+." -ForegroundColor Yellow
    Write-Host "Cai PowerShell 7 bang lenh: winget install Microsoft.PowerShell" -ForegroundColor Yellow
    Write-Host ""
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[CANH BAO] Script chua chay voi quyen Administrator." -ForegroundColor Yellow
    Write-Host "Mot so buoc (winget, cai font) co the yeu cau quyen admin de hoat dong dung." -ForegroundColor Yellow
    Write-Host ""
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[LOI] Khong tim thay winget. Vui long cai dat 'App Installer' tu Microsoft Store truoc." -ForegroundColor Red
    exit 1
}

# ============================================================
#  1. CAI OH MY POSH
# ============================================================

Write-Host "[1/8] Dang cai dat Oh My Posh..." -ForegroundColor Green
try {
    winget install JanDeDobbeleer.OhMyPosh -s winget --accept-source-agreements --accept-package-agreements -e
    if ($LASTEXITCODE -ne 0) {
        Write-Host "      -> winget tra ve ma loi $LASTEXITCODE. Co the da cai san hoac can kiem tra thu cong." -ForegroundColor Yellow
    } else {
        Write-Host "      -> Hoan tat." -ForegroundColor DarkGreen
    }
} catch {
    Write-Host "      -> Loi khi cai Oh My Posh: $_" -ForegroundColor Red
}
Write-Host ""

# Refresh PATH trong session hien tai de nhan lenh moi cai
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# --- Thiet lap bien moi truong POSH_THEMES_PATH (vinh vien, cho user hien tai) ---
# De oh-my-posh luon load theme TU O CUNG (local), khong can tai qua mang moi lan mo terminal
Write-Host "      Dang thiet lap POSH_THEMES_PATH (theme local)..." -ForegroundColor Green
try {
    $poshThemesPath = Join-Path $env:LOCALAPPDATA "Programs\oh-my-posh\themes"
    if (Test-Path $poshThemesPath) {
        [Environment]::SetEnvironmentVariable("POSH_THEMES_PATH", $poshThemesPath, "User")
        $env:POSH_THEMES_PATH = $poshThemesPath
        Write-Host "      -> Da set POSH_THEMES_PATH = $poshThemesPath" -ForegroundColor DarkGreen
    } else {
        Write-Host "      -> Chua tim thay thu muc theme tai $poshThemesPath (se thu lai sau khi mo terminal moi)." -ForegroundColor Yellow
    }
} catch {
    Write-Host "      -> Loi khi set POSH_THEMES_PATH: $_" -ForegroundColor Red
}
Write-Host ""

# ============================================================
#  2. CAI NERD FONT
# ============================================================

Write-Host "[2/8] Dang cai dat Nerd Font (CascadiaCode)..." -ForegroundColor Green
try {
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        oh-my-posh font install CascadiaCode
        Write-Host "      -> Hoan tat. Nho vao Windows Terminal > Settings > Font face doi thanh 'CaskaydiaCove Nerd Font'." -ForegroundColor DarkGreen
    } else {
        Write-Host "      -> Bo qua: chua tim thay lenh oh-my-posh. Hay chay lai script sau khi mo lai terminal moi." -ForegroundColor Yellow
    }
} catch {
    Write-Host "      -> Loi khi cai font: $_" -ForegroundColor Red
}
Write-Host ""

# ============================================================
#  3. CAP NHAT PSReadLine
# ============================================================

Write-Host "[3/8] Dang cap nhat PSReadLine..." -ForegroundColor Green
try {
    Install-Module PSReadLine -Force -SkipPublisherCheck -Scope CurrentUser -ErrorAction Stop
    Write-Host "      -> Hoan tat." -ForegroundColor DarkGreen
} catch {
    Write-Host "      -> Loi khi cai PSReadLine: $_" -ForegroundColor Red
}
Write-Host ""

# ============================================================
#  4. CAI Terminal-Icons
# ============================================================

Write-Host "[4/8] Dang cai dat Terminal-Icons..." -ForegroundColor Green
try {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser -ErrorAction Stop
    Write-Host "      -> Hoan tat." -ForegroundColor DarkGreen
} catch {
    Write-Host "      -> Loi khi cai Terminal-Icons: $_" -ForegroundColor Red
}
Write-Host ""

# ============================================================
#  5. CAI zoxide
# ============================================================

Write-Host "[5/8] Dang cai dat zoxide..." -ForegroundColor Green
try {
    winget install ajeetdsouza.zoxide -s winget --accept-source-agreements --accept-package-agreements -e
    if ($LASTEXITCODE -ne 0) {
        Write-Host "      -> winget tra ve ma loi $LASTEXITCODE. Co the da cai san hoac can kiem tra thu cong." -ForegroundColor Yellow
    } else {
        Write-Host "      -> Hoan tat." -ForegroundColor DarkGreen
    }
} catch {
    Write-Host "      -> Loi khi cai zoxide: $_" -ForegroundColor Red
}
Write-Host ""

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# ============================================================
#  6. CAI CAC MODULE KHUYEN NGHI (posh-git + PSFzf)
# ============================================================

Write-Host "[6/8] Dang cai dat posh-git va PSFzf (fuzzy finder)..." -ForegroundColor Green

try {
    Install-Module posh-git -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
    Write-Host "      -> posh-git: Hoan tat." -ForegroundColor DarkGreen
} catch {
    Write-Host "      -> Loi khi cai posh-git: $_" -ForegroundColor Red
}

try {
    # PSFzf can binary fzf, cai qua winget truoc
    winget install junegunn.fzf -s winget --accept-source-agreements --accept-package-agreements -e
    if ($LASTEXITCODE -ne 0) {
        Write-Host "      -> fzf: winget tra ve ma loi $LASTEXITCODE." -ForegroundColor Yellow
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Install-Module PSFzf -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
    Write-Host "      -> PSFzf: Hoan tat." -ForegroundColor DarkGreen
} catch {
    Write-Host "      -> Loi khi cai PSFzf: $_" -ForegroundColor Red
}
Write-Host ""

# ============================================================
#  7. MODULE BO SUNG (TUY CHON)
# ============================================================

Write-Host "[7/8] Module bo sung (tuy chon):" -ForegroundColor Green
Write-Host "      - ImportExcel        : doc/ghi file Excel bang PowerShell" -ForegroundColor White
Write-Host "      - Pester             : framework viet unit test cho script" -ForegroundColor White
Write-Host "      - PSScriptAnalyzer   : linter kiem tra chat luong code" -ForegroundColor White
Write-Host "      - SecretManagement   : luu password/API key an toan" -ForegroundColor White
Write-Host "      - BurntToast         : hien thong bao Windows (toast) tu script" -ForegroundColor White
Write-Host ""

$installExtra = Read-Host "Ban co muon cai tat ca cac module bo sung o tren khong? (Y/n)"

if ($installExtra -eq "" -or $installExtra -match "^[Yy]") {
    $extraModules = @(
        "ImportExcel",
        "Pester",
        "PSScriptAnalyzer",
        "Microsoft.PowerShell.SecretManagement",
        "Microsoft.PowerShell.SecretStore",
        "BurntToast"
    )

    foreach ($mod in $extraModules) {
        Write-Host "      Dang cai $mod..." -ForegroundColor Green
        try {
            Install-Module -Name $mod -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
            Write-Host "      -> $mod : Hoan tat." -ForegroundColor DarkGreen
        } catch {
            Write-Host "      -> Loi khi cai $mod : $_" -ForegroundColor Red
        }
    }
} else {
    Write-Host "      -> Bo qua cac module bo sung. Ban co the tu cai sau bang Install-Module." -ForegroundColor Yellow
}
Write-Host ""

# ============================================================
#  8. TAO FILE $PROFILE
# ============================================================

Write-Host "[8/8] Dang cau hinh file profile PowerShell (theme: Dracula)..." -ForegroundColor Green

$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (Test-Path $PROFILE) {
    $backupPath = "$PROFILE.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $PROFILE $backupPath -Force
    Write-Host "      -> Da sao luu profile cu vao: $backupPath" -ForegroundColor DarkGray
}

$profileContent = @'
# ============================================================
#  POWERSHELL PROFILE - AUTO GENERATED
# ============================================================

# --- Oh My Posh (theme prompt: Dracula, uu tien load LOCAL) ---
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {

    # Neu POSH_THEMES_PATH chua duoc set trong session nay, thu tu suy ra tu duong dan cai dat mac dinh
    if (-not $env:POSH_THEMES_PATH) {
        $fallbackThemesPath = Join-Path $env:LOCALAPPDATA "Programs\oh-my-posh\themes"
        if (Test-Path $fallbackThemesPath) {
            $env:POSH_THEMES_PATH = $fallbackThemesPath
        }
    }

    $draculaTheme = $null
    if ($env:POSH_THEMES_PATH) {
        $draculaTheme = Join-Path $env:POSH_THEMES_PATH "dracula.omp.json"
    }

    if ($draculaTheme -and (Test-Path $draculaTheme)) {
        # Load theme LOCAL - khong can mang, nhanh hon
        oh-my-posh init pwsh --config $draculaTheme | Invoke-Expression
    } else {
        # Fallback: chi tai qua mang neu khong tim thay theme local
        oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json" | Invoke-Expression
    }
}

# --- PSReadLine (autocomplete + syntax highlight) ---
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -Colors @{
        Command   = 'Cyan'
        Parameter = 'Gray'
        String    = 'Yellow'
        Operator  = 'Magenta'
        Variable  = 'Green'
        Comment   = 'DarkGray'
    }
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# --- Terminal-Icons (icon file/folder) ---
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}

# --- posh-git (trang thai Git tren prompt + tab-completion cho git) ---
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}

# --- PSFzf (fuzzy finder: Ctrl+T tim file, Ctrl+R tim lich su lenh) ---
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# --- zoxide (nhay thu muc thong minh: dung "z ten-thu-muc") ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- Alias tien ich ---
Set-Alias ll Get-ChildItem
function .. { Set-Location .. }
function ... { Set-Location ..\.. }

Write-Host "Viet Boi Loi Nguyen - lowji194.github.io.vn" -ForegroundColor DarkGray
'@

Set-Content -Path $PROFILE -Value $profileContent -Encoding UTF8

Write-Host "      -> Hoan tat. File profile: $PROFILE" -ForegroundColor DarkGreen
Write-Host ""

# ============================================================
#  KET THUC
# ============================================================

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  CAI DAT HOAN TAT! (Theme mac dinh: Dracula)" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "CAC BUOC TIEP THEO (BAT BUOC):" -ForegroundColor Yellow
Write-Host "  1. Dong terminal nay va mo lai PowerShell 7 (pwsh)." -ForegroundColor White
Write-Host "  2. Mo Windows Terminal > Settings > Profile PowerShell > Appearance" -ForegroundColor White
Write-Host "     -> Doi Font face thanh: CaskaydiaCove Nerd Font" -ForegroundColor White
Write-Host "  3. (Tuy chon) Neu muon doi theme khac Dracula, sua dong 'dracula.omp.json'" -ForegroundColor White
Write-Host "     trong file profile ($PROFILE) sang theme khac." -ForegroundColor White
Write-Host "     Xem danh sach theme: https://ohmyposh.dev/docs/themes" -ForegroundColor White
Write-Host ""
Write-Host "GOI Y SU DUNG NHANH:" -ForegroundColor Yellow
Write-Host "  - Ctrl+R : tim lich su lenh bang fuzzy search (PSFzf)" -ForegroundColor White
Write-Host "  - Ctrl+T : tim file bang fuzzy search (PSFzf)" -ForegroundColor White
Write-Host "  - z ten-thu-muc : nhay nhanh toi thu muc da tung vao (zoxide)" -ForegroundColor White
Write-Host ""
