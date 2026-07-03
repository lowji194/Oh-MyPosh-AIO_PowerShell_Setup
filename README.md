# Oh-MyPosh AIO PowerShell Setup 🦇

Script cài đặt tự động (All-In-One) giúp "lên đồ" cho PowerShell 7 + Windows Terminal chỉ trong một lệnh: Oh My Posh (theme **Dracula** mặc định), Nerd Font, PSReadLine, Terminal-Icons, zoxide, posh-git, PSFzf và các module PowerShell hữu ích khác.

## ⚡ Cài đặt nhanh (không cần tải file về)

Mở **PowerShell 7 (pwsh)** với quyền **Administrator**, sau đó chạy lệnh sau:

```powershell
irm https://raw.githubusercontent.com/lowji194/Oh-MyPosh-AIO_PowerShell_Setup/main/AIO_PowerShell_Setup.ps1 | iex
```

> `irm` (Invoke-RestMethod) sẽ tải nội dung script trực tiếp từ GitHub, còn `iex` (Invoke-Expression) sẽ chạy luôn script đó — không cần clone repo hay lưu file `.ps1` xuống máy.

Nếu bạn dùng Windows PowerShell 5.1 mặc định của Windows và chưa cài PowerShell 7, hãy cài trước bằng:

```powershell
winget install Microsoft.PowerShell
```

rồi mở lại terminal bằng `pwsh` và chạy lệnh cài ở trên.

## 📋 Script sẽ tự động làm gì

1. Kiểm tra môi trường (phiên bản PowerShell, quyền admin, winget)
2. Cài **Oh My Posh** (`winget install JanDeDobbeleer.OhMyPosh`)
3. Cài **Nerd Font** (CascadiaCode / CaskaydiaCove Nerd Font)
4. Cập nhật **PSReadLine** (autocomplete + syntax highlight)
5. Cài **Terminal-Icons** (icon cho file/folder trong terminal)
6. Cài **zoxide** (di chuyển thư mục thông minh bằng lệnh `z`)
7. Cài **posh-git** + **PSFzf** (trạng thái Git trên prompt, fuzzy finder `Ctrl+T` / `Ctrl+R`)
8. Cho phép chọn cài thêm module tùy chọn: `ImportExcel`, `Pester`, `PSScriptAnalyzer`, `SecretManagement`, `BurntToast`
9. Ghi file `$PROFILE` hoàn chỉnh với theme **Dracula** làm mặc định (tự backup profile cũ nếu có)

## ✅ Sau khi cài xong

1. Đóng terminal hiện tại, mở lại **PowerShell 7**.
2. Vào **Windows Terminal → Settings → Profile PowerShell → Appearance**, đổi **Font face** thành `CaskaydiaCove Nerd Font`.
3. Prompt sẽ tự động dùng theme **Dracula**. Muốn đổi theme khác, mở file profile:

   ```powershell
   notepad $PROFILE
   ```

   và sửa dòng chứa `dracula.omp.json` thành tên theme bạn muốn (xem danh sách tại [ohmyposh.dev/docs/themes](https://ohmyposh.dev/docs/themes)).

## ⌨️ Một số phím tắt / lệnh hữu ích

| Lệnh / Phím tắt | Chức năng |
|---|---|
| `Ctrl + R` | Tìm lịch sử lệnh bằng fuzzy search (PSFzf) |
| `Ctrl + T` | Tìm file bằng fuzzy search (PSFzf) |
| `z ten-thu-muc` | Nhảy nhanh tới thư mục đã từng vào (zoxide) |
| `ll` | Alias của `Get-ChildItem` |
| `..` / `...` | Lùi lại 1 / 2 cấp thư mục |

## 🔧 Yêu cầu

- Windows 10/11
- PowerShell 7 trở lên (khuyến nghị)
- [winget](https://learn.microsoft.com/vi-vn/windows/package-manager/winget/) (có sẵn qua "App Installer" trên Microsoft Store)
- Quyền Administrator (để `winget` và cài font hoạt động ổn định)

## 📦 Cài đặt thủ công (tùy chọn)

Nếu muốn xem trước script hoặc chỉnh sửa trước khi chạy:

```powershell
git clone https://github.com/lowji194/Oh-MyPosh-AIO_PowerShell_Setup.git
cd Oh-MyPosh-AIO_PowerShell_Setup
./AIO_PowerShell_Setup.ps1
```

## 📝 Ghi chú

- Script tự động **backup** file `$PROFILE` cũ (nếu có) trước khi ghi đè, dạng `Microsoft.PowerShell_profile.ps1.backup_yyyyMMdd_HHmmss`.
- Nếu chạy lần đầu mà lệnh `oh-my-posh` chưa được nhận diện ngay (do PATH chưa refresh), hãy đóng terminal và chạy lại lệnh cài ở trên một lần nữa.
