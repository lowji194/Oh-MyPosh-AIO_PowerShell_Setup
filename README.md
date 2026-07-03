# Oh-MyPosh AIO Setup 🦇

Script cài đặt tự động (All-In-One) giúp "lên đồ" cho terminal chỉ trong một lệnh: Oh My Posh (theme **Dracula** mặc định), Nerd Font, autocomplete, fuzzy finder, nhảy thư mục thông minh và các công cụ hữu ích khác.

Hỗ trợ:
- 🪟 **Windows** — PowerShell 7 + Windows Terminal (`AIO_PowerShell_Setup.ps1`)
- 🐧 **Ubuntu/Debian** — Bash hoặc Zsh (`AIO_OhMyPosh_Setup.sh`)

---

## 🪟 Windows (PowerShell 7)

### Cài đặt nhanh (không cần tải file về)

Mở **PowerShell 7 (pwsh)** với quyền **Administrator**, chạy:

```powershell
irm https://raw.githubusercontent.com/lowji194/Oh-MyPosh-AIO_PowerShell_Setup/main/AIO_PowerShell_Setup.ps1 | iex
```

> `irm` (Invoke-RestMethod) tải nội dung script trực tiếp từ GitHub, `iex` (Invoke-Expression) chạy luôn — không cần clone repo hay lưu file `.ps1` xuống máy.

Nếu chưa có PowerShell 7, cài trước bằng:

```powershell
winget install Microsoft.PowerShell
```

rồi mở lại terminal bằng `pwsh` và chạy lệnh cài ở trên.

### Script sẽ tự động làm gì

1. Kiểm tra môi trường (phiên bản PowerShell, quyền admin, winget)
2. Cài **Oh My Posh** (`winget install JanDeDobbeleer.OhMyPosh`)
3. Cài **Nerd Font** (CascadiaCode / CaskaydiaCove Nerd Font)
4. Cập nhật **PSReadLine** (autocomplete + syntax highlight)
5. Cài **Terminal-Icons** (icon cho file/folder trong terminal)
6. Cài **zoxide** (di chuyển thư mục thông minh bằng lệnh `z`)
7. Cài **posh-git** + **PSFzf** (trạng thái Git trên prompt, fuzzy finder `Ctrl+T` / `Ctrl+R`)
8. Cho phép chọn cài thêm module tùy chọn: `ImportExcel`, `Pester`, `PSScriptAnalyzer`, `SecretManagement`, `BurntToast`
9. Ghi file `$PROFILE` hoàn chỉnh với theme **Dracula** làm mặc định (tự backup profile cũ nếu có)

### Sau khi cài xong

1. Đóng terminal hiện tại, mở lại **PowerShell 7**.
2. Vào **Windows Terminal → Settings → Profile PowerShell → Appearance**, đổi **Font face** thành `CaskaydiaCove Nerd Font`.
3. Muốn đổi theme khác Dracula, mở file profile:

   ```powershell
   notepad $PROFILE
   ```

   và sửa dòng chứa `dracula.omp.json` thành tên theme bạn muốn (xem tại [ohmyposh.dev/docs/themes](https://ohmyposh.dev/docs/themes)).

### Cài đặt thủ công (tùy chọn)

```powershell
git clone https://github.com/lowji194/Oh-MyPosh-AIO_PowerShell_Setup.git
cd Oh-MyPosh-AIO_PowerShell_Setup
./AIO_PowerShell_Setup.ps1
```

---

## 🐧 Ubuntu / Debian (Bash hoặc Zsh)

### Cài đặt nhanh (không cần tải file về)

Mở terminal, chạy:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lowji194/Oh-MyPosh-AIO_PowerShell_Setup/main/AIO_OhMyPosh_Setup.sh)
```

> Script cần quyền `sudo` để cài một số gói hệ thống (`curl`, `unzip`, `fontconfig`, `eza`, `bat`), sẽ được hỏi mật khẩu khi cần.

### Script sẽ tự động làm gì

1. Cập nhật danh sách gói và cài dependency cơ bản (`curl`, `unzip`, `fontconfig`, `git`)
2. Cài **Oh My Posh** vào `~/.local/bin`
3. Cài **Nerd Font** (CascadiaCode) vào `~/.local/share/fonts`
4. Cài **zoxide** (di chuyển thư mục thông minh bằng lệnh `z`)
5. Cài **fzf** (fuzzy finder, `Ctrl+T` tìm file / `Ctrl+R` tìm lịch sử lệnh)
6. Cài **eza** (thay thế `ls` hiện đại, có icon — nếu có sẵn qua `apt`)
7. Cài **bat** (thay thế `cat` có syntax highlight — nếu có sẵn qua `apt`)
8. Tải theme **Dracula** cho Oh My Posh về `~/.poshthemes/dracula.omp.json`
9. Tự phát hiện bạn dùng `bash` hay `zsh` để chèn cấu hình vào đúng file (`~/.bashrc` hoặc `~/.zshrc`), có backup file cũ và không bị nhân đôi cấu hình nếu chạy lại nhiều lần

### Sau khi cài xong

1. Nạp lại cấu hình (hoặc đóng terminal và mở lại):

   ```bash
   source ~/.bashrc   # hoặc: source ~/.zshrc nếu bạn dùng zsh
   ```

2. Đổi Font của terminal (GNOME Terminal, Windows Terminal chạy WSL, v.v.) thành `CaskaydiaCove Nerd Font`.
3. Muốn đổi theme khác Dracula, mở file cấu hình:

   ```bash
   nano ~/.bashrc   # hoặc ~/.zshrc
   ```

   và sửa đường dẫn theme trong dòng `oh-my-posh init` (xem danh sách theme tại [ohmyposh.dev/docs/themes](https://ohmyposh.dev/docs/themes)).

### Cài đặt thủ công (tùy chọn)

```bash
git clone https://github.com/lowji194/Oh-MyPosh-AIO_PowerShell_Setup.git
cd Oh-MyPosh-AIO_PowerShell_Setup
chmod +x AIO_OhMyPosh_Setup.sh
./AIO_OhMyPosh_Setup.sh
```

---

## ⌨️ Phím tắt / lệnh hữu ích (áp dụng cho cả 2 nền tảng)

| Lệnh / Phím tắt | Chức năng |
|---|---|
| `Ctrl + R` | Tìm lịch sử lệnh bằng fuzzy search |
| `Ctrl + T` | Tìm file bằng fuzzy search |
| `z ten-thu-muc` | Nhảy nhanh tới thư mục đã từng vào (zoxide) |
| `ll` | Alias liệt kê chi tiết file/thư mục |
| `..` / `...` | Lùi lại 1 / 2 cấp thư mục |

---

## 🔧 Yêu cầu

**Windows:**
- Windows 10/11
- PowerShell 7 trở lên (khuyến nghị)
- [winget](https://learn.microsoft.com/vi-vn/windows/package-manager/winget/) (có sẵn qua "App Installer" trên Microsoft Store)
- Quyền Administrator

**Ubuntu/Debian:**
- Ubuntu 20.04 trở lên hoặc Debian tương đương (kể cả WSL)
- Quyền `sudo`
- Kết nối internet

---

## 📝 Ghi chú

- Cả 2 script đều **tự động backup** cấu hình cũ trước khi ghi đè:
  - Windows: `Microsoft.PowerShell_profile.ps1.backup_yyyyMMdd_HHmmss`
  - Ubuntu: `.bashrc.backup_yyyyMMdd_HHmmss` (hoặc `.zshrc...`)
- Nếu chạy lần đầu mà lệnh `oh-my-posh` chưa được nhận diện ngay (do PATH chưa refresh), hãy đóng terminal và chạy lại lệnh cài một lần nữa.
- Script Ubuntu có thể chạy lại nhiều lần an toàn — cấu hình cũ sẽ được thay thế chứ không bị nhân đôi.
