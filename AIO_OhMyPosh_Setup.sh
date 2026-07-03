#!/usr/bin/env bash
#
# AIO_OhMyPosh_Setup.sh
# ------------------------------------------------------------
# Script cai dat AIO (All-In-One) lam dep Bash/Zsh tren Ubuntu
# ------------------------------------------------------------
# Tu dong cai dat va cau hinh:
#   - Oh My Posh (theme prompt mac dinh: Dracula)
#   - Nerd Font (CascadiaCode)
#   - zoxide (nhay thu muc thong minh)
#   - fzf (fuzzy finder cho lich su lenh & file)
#   - eza (thay the "ls" hien dai, co icon)
#   - bat (thay the "cat" co syntax highlight)
#   - File ~/.bashrc VA ~/.zshrc (neu co zsh) deu duoc cau hinh tu dong
#   - Dong bo tu dong cac cau hinh cua nvm/pyenv/sdkman/cargo/go/...
#     tu ~/.bashrc sang ~/.zshrc (va nguoc lai neu can), tranh phai
#     copy tay moi khi cai them cong cu moi
#
# Yeu cau: Ubuntu/Debian, co quyen sudo, ket noi internet
# Cach chay:
#   chmod +x AIO_OhMyPosh_Setup.sh
#   ./AIO_OhMyPosh_Setup.sh
#
# Hoac chay truc tiep khong can tai file:
#   bash <(curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/AIO_OhMyPosh_Setup.sh)
# ------------------------------------------------------------

set -uo pipefail

# ============================================================
#  HAM TIEN ICH IN MAU
# ============================================================

GREEN='\033[0;32m'
DARKGREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

log_info()  { echo -e "${GREEN}$1${NC}"; }
log_ok()    { echo -e "${DARKGREEN}      -> $1${NC}"; }
log_warn()  { echo -e "${YELLOW}$1${NC}"; }
log_err()   { echo -e "${RED}$1${NC}"; }
log_step()  { echo -e "${CYAN}$1${NC}"; }

# ============================================================
#  KIEM TRA MOI TRUONG
# ============================================================

echo ""
log_step "====================================================="
log_step "   CAI DAT AIO - LAM DEP TERMINAL UBUNTU (Theme: Dracula)"
log_step "====================================================="
echo ""

if [[ "$(uname -s)" != "Linux" ]]; then
    log_err "[LOI] Script nay chi ho tro Linux (Ubuntu/Debian)."
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    log_err "[LOI] Khong tim thay apt-get. Script nay danh cho Ubuntu/Debian."
    exit 1
fi

if [[ $EUID -eq 0 ]]; then
    log_warn "[CANH BAO] Ban dang chay script bang user root."
    log_warn "Khuyen nghi chay bang user thuong (co quyen sudo) de cac cau hinh ap dung dung cho user hien tai."
    echo ""
fi

if ! command -v sudo >/dev/null 2>&1 && [[ $EUID -ne 0 ]]; then
    log_err "[LOI] Khong tim thay 'sudo' va ban khong phai root. Vui long cai sudo hoac chay bang root."
    exit 1
fi

# Xac dinh shell dang dung (chi de hien thi thong tin, vi ban than script
# se cau hinh cho CA HAI shell ben duoi neu co)
CURRENT_SHELL="$(basename "$SHELL")"
log_info "Shell dang dung: $CURRENT_SHELL"
echo ""

SUDO="sudo"
[[ $EUID -eq 0 ]] && SUDO=""

# ============================================================
#  0. CAP NHAT GOI HE THONG & CAI DEPENDENCY CO BAN
# ============================================================

log_info "[0/9] Dang cap nhat danh sach goi va cai dependency co ban (curl, unzip, fontconfig, git)..."
if $SUDO apt-get update -y >/dev/null 2>&1 && \
   $SUDO apt-get install -y curl unzip fontconfig git ca-certificates >/dev/null 2>&1; then
    log_ok "Hoan tat."
else
    log_err "      -> Loi khi cap nhat/cai dependency co ban. Kiem tra ket noi mang hoac quyen sudo."
fi
echo ""

# ============================================================
#  1. CAI OH MY POSH
# ============================================================

log_info "[1/9] Dang cai dat Oh My Posh..."
if command -v oh-my-posh >/dev/null 2>&1; then
    log_ok "Oh My Posh da duoc cai san, bo qua."
else
    if curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin" >/dev/null 2>&1; then
        log_ok "Hoan tat. Da cai vao $HOME/.local/bin"
    else
        log_err "      -> Loi khi cai Oh My Posh. Vui long thu lai hoac xem huong dan tai https://ohmyposh.dev/docs/installation/linux"
    fi
fi

# Dam bao $HOME/.local/bin nam trong PATH cua session hien tai
export PATH="$HOME/.local/bin:$PATH"
echo ""

# ============================================================
#  2. CAI NERD FONT (CascadiaCode)
# ============================================================

log_info "[2/9] Dang cai dat Nerd Font (CascadiaCode)..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if fc-list | grep -qi "CaskaydiaCove Nerd Font"; then
    log_ok "Font da duoc cai san, bo qua."
else
    TMP_FONT_ZIP="$(mktemp -d)/CascadiaCode.zip"
    if curl -fsSL -o "$TMP_FONT_ZIP" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"; then
        unzip -oq "$TMP_FONT_ZIP" -d "$FONT_DIR" "*.ttf" 2>/dev/null
        fc-cache -f "$FONT_DIR" >/dev/null 2>&1
        log_ok "Hoan tat. Nho chinh Font cua terminal thanh 'CaskaydiaCove Nerd Font'."
    else
        log_err "      -> Loi khi tai font. Ban co the tai thu cong tai https://www.nerdfonts.com/"
    fi
fi
echo ""

# ============================================================
#  3. CAI zoxide (nhay thu muc thong minh)
# ============================================================

log_info "[3/9] Dang cai dat zoxide..."
if command -v zoxide >/dev/null 2>&1; then
    log_ok "zoxide da duoc cai san, bo qua."
else
    if curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash >/dev/null 2>&1; then
        log_ok "Hoan tat."
    else
        log_err "      -> Loi khi cai zoxide."
    fi
fi
export PATH="$HOME/.local/bin:$PATH"
echo ""

# ============================================================
#  4. CAI fzf (fuzzy finder)
# ============================================================

log_info "[4/9] Dang cai dat fzf (fuzzy finder)..."
if command -v fzf >/dev/null 2>&1; then
    log_ok "fzf da duoc cai san, bo qua."
else
    if [[ ! -d "$HOME/.fzf" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >/dev/null 2>&1
    fi
    # Cai key-bindings + completion cho CA bash lan zsh (bo --no-bash/--no-zsh)
    if "$HOME/.fzf/install" --key-bindings --completion --no-update-rc >/dev/null 2>&1; then
        log_ok "Hoan tat. (Ctrl+T tim file, Ctrl+R tim lich su lenh)"
    else
        log_err "      -> Loi khi cai fzf."
    fi
fi
echo ""

# ============================================================
#  5. CAI eza (thay the ls hien dai)
# ============================================================

log_info "[5/9] Dang cai dat eza (ls hien dai, co icon)..."
if command -v eza >/dev/null 2>&1; then
    log_ok "eza da duoc cai san, bo qua."
else
    if $SUDO apt-get install -y eza >/dev/null 2>&1; then
        log_ok "Hoan tat (cai qua apt)."
    else
        log_warn "      -> Khong co san qua apt. Bo qua eza (khong bat buoc)."
    fi
fi
echo ""

# ============================================================
#  6. CAI bat (thay the cat co syntax highlight)
# ============================================================

log_info "[6/9] Dang cai dat bat (cat co syntax highlight)..."
if command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1; then
    log_ok "bat da duoc cai san, bo qua."
else
    if $SUDO apt-get install -y bat >/dev/null 2>&1; then
        log_ok "Hoan tat (cai qua apt, lenh la 'batcat' tren Ubuntu)."
    else
        log_warn "      -> Khong co san qua apt. Bo qua bat (khong bat buoc)."
    fi
fi
echo ""

# ============================================================
#  7. TAI THEME DRACULA CHO OH MY POSH
# ============================================================

log_info "[7/9] Dang tai theme Dracula cho Oh My Posh..."
THEME_DIR="$HOME/.poshthemes"
mkdir -p "$THEME_DIR"
DRACULA_THEME_PATH="$THEME_DIR/dracula.omp.json"

if curl -fsSL -o "$DRACULA_THEME_PATH" "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json"; then
    log_ok "Hoan tat. Theme luu tai: $DRACULA_THEME_PATH"
else
    log_err "      -> Loi khi tai theme Dracula. Se dung cau hinh du phong trong file rc."
fi
echo ""

# ============================================================
#  8. CAU HINH FILE RC CHO CA ~/.bashrc VA ~/.zshrc
#     (khong con phu thuoc vao shell hien tai nua)
# ============================================================

MARKER_START="# >>> AIO OhMyPosh Setup >>>"
MARKER_END="# <<< AIO OhMyPosh Setup <<<"

configure_rc_file() {
    local rc_file="$1"
    local shell_name="$2"   # "bash" hoac "zsh"

    log_info "[8/9] Dang cau hinh $rc_file (shell: $shell_name, theme: Dracula)..."

    touch "$rc_file"
    local backup_path="${rc_file}.backup_$(date +%Y%m%d_%H%M%S)"
    cp "$rc_file" "$backup_path"
    log_ok "Da sao luu file cu vao: $backup_path"

    # Xoa block cu (neu chay lai script) truoc khi chen block moi
    if grep -qF "$MARKER_START" "$rc_file"; then
        sed -i "/$MARKER_START/,/$MARKER_END/d" "$rc_file"
    fi

    cat >> "$rc_file" <<EOF
$MARKER_START
# ------------------------------------------------------------
# Cau hinh tu dong boi AIO_OhMyPosh_Setup.sh
# ------------------------------------------------------------

# --- PATH bo sung ---
export PATH="\$HOME/.local/bin:\$PATH"

# --- Oh My Posh (theme prompt: Dracula) ---
if command -v oh-my-posh >/dev/null 2>&1; then
    if [[ -f "$DRACULA_THEME_PATH" ]]; then
        eval "\$(oh-my-posh init ${shell_name} --config '$DRACULA_THEME_PATH')"
    else
        eval "\$(oh-my-posh init ${shell_name} --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json')"
    fi
fi

# --- zoxide (nhay thu muc thong minh: dung "z ten-thu-muc") ---
if command -v zoxide >/dev/null 2>&1; then
    eval "\$(zoxide init ${shell_name})"
fi

# --- fzf (fuzzy finder: Ctrl+T tim file, Ctrl+R tim lich su lenh) ---
[[ -f "\$HOME/.fzf.${shell_name}" ]] && source "\$HOME/.fzf.${shell_name}"

# --- Alias tien ich ---
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias ll='eza -la --icons'
fi
if command -v batcat >/dev/null 2>&1; then
    alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi
alias ..='cd ..'
alias ...='cd ../..'

$MARKER_END
EOF

    log_ok "Hoan tat. Da cau hinh: $rc_file"
}

# Luon cau hinh ~/.bashrc
configure_rc_file "$HOME/.bashrc" "bash"

# Neu da co zsh (hoac se cai o buoc sau), cau hinh luon ~/.zshrc
if command -v zsh >/dev/null 2>&1; then
    configure_rc_file "$HOME/.zshrc" "zsh"
else
    log_warn "      -> Chua phat hien zsh tren he thong nen tam thoi bo qua ~/.zshrc."
    log_warn "         Neu ban cai zsh sau nay, hay chay lai script nay de tu dong cau hinh ~/.zshrc."
fi
echo ""

PLACEHOLDER_STEP9

# ============================================================
#  KET THUC
# ============================================================

echo ""
log_step "====================================================="
log_step "  CAI DAT HOAN TAT! (Theme mac dinh: Dracula)"
log_step "====================================================="
echo ""
log_warn "CAC BUOC TIEP THEO (BAT BUOC):"
echo -e "${WHITE}  1. Chay lenh sau de nap lai cau hinh (hoac dong terminal va mo lai):${NC}"
echo -e "${WHITE}     source ~/.bashrc   # neu dang dung bash${NC}"
echo -e "${WHITE}     source ~/.zshrc    # neu dang dung zsh${NC}"
echo -e "${WHITE}  2. Doi Font cua terminal (GNOME Terminal / Windows Terminal WSL / ...) thanh:${NC}"
echo -e "${WHITE}     'CaskaydiaCove Nerd Font'${NC}"
echo -e "${WHITE}  3. (Tuy chon) Neu muon doi theme khac Dracula, sua duong dan trong dong 'oh-my-posh init'${NC}"
echo -e "${WHITE}     trong ca ~/.bashrc va ~/.zshrc sang theme khac.${NC}"
echo -e "${WHITE}     Xem danh sach theme: https://ohmyposh.dev/docs/themes${NC}"
echo ""
log_warn "VE VIEC DONG BO CONG CU (nvm/pyenv/sdkman/cargo/go/...):"
echo -e "${WHITE}  - Tu nay ve sau, moi khi ban cai them 1 cong cu moi (vi du: cai nvm de dung${NC}"
echo -e "${WHITE}    npm/nodejs) va no chi ghi cau hinh vao ~/.bashrc, ban CHI CAN chay lai:${NC}"
echo -e "${WHITE}       ./AIO_OhMyPosh_Setup.sh${NC}"
echo -e "${WHITE}    Script se tu dong phat hien va dong bo cau hinh do sang ~/.zshrc (va nguoc lai),${NC}"
echo -e "${WHITE}    khong can copy tay nua.${NC}"
echo ""
log_warn "GOI Y SU DUNG NHANH:"
echo -e "${WHITE}  - Ctrl+R : tim lich su lenh bang fuzzy search (fzf)${NC}"
echo -e "${WHITE}  - Ctrl+T : tim file bang fuzzy search (fzf)${NC}"
echo -e "${WHITE}  - z ten-thu-muc : nhay nhanh toi thu muc da tung vao (zoxide)${NC}"
echo ""
