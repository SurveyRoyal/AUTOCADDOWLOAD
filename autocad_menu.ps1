function Install-Software {
    param (
        [string]$Name,
        [string]$Url,
        [string]$Installer,
        [string]$InstallArgs
    )

    Write-Host "`n=== Dang tai $Name ==="
    $Path = "$env:TEMP\$Installer"

    try {
        Invoke-WebRequest -Uri $Url -OutFile $Path -UseBasicParsing -ErrorAction Stop
        if ((Get-Item $Path).Length -lt 10MB) {
            throw "File tải về quá nhỏ hoặc link không hợp lệ!"
        }
        Write-Host ">>> Tải xong $Name"
        Write-Host ">>> Đang cài đặt..."
        Start-Process -FilePath $Path -ArgumentList $InstallArgs -Wait
        Write-Host ">>> Hoàn tất cài đặt $Name`n"
    }
    catch {
        Write-Host "❌ Lỗi khi cài đặt $Name: $($_.Exception.Message)"
    }
    finally {
        if (Test-Path $Path) { Remove-Item $Path -Force }
    }
}

function Fix-Software {
    param (
        [string]$FixUrl,
        [string]$TargetPath
    )

    Write-Host "`n=== Đang tải bản Fix… ==="
    $FixPath = "$env:TEMP\fix_acad.exe"

    try {
        Invoke-WebRequest -Uri $FixUrl -OutFile $FixPath -UseBasicParsing -ErrorAction Stop
        if ((Get-Item $FixPath).Length -lt 1MB) {
            throw "File Fix tải về quá nhỏ hoặc link không hợp lệ!"
        }
        Write-Host ">>> Fix tải xong: $FixPath"

        Write-Host ">>> Đang copy vào thư mục đích: $TargetPath"
        robocopy (Split-Path $FixPath -Parent) $TargetPath /e /w:5 /r:2 /COPY:DATSOU /DCOPY:DAT /MT
        Write-Host ">>> Hoàn thành Fix—file đã được copy sang $TargetPath`n"
    }
    catch {
        Write-Host "❌ Lỗi khi thực hiện Fix: $($_.Exception.Message)"
    }
    finally {
        if (Test-Path $FixPath) { Remove-Item $FixPath -Force }
    }
}

# ======== MENU ========
Clear-Host
Write-Host "===== MENU CAI DAT & FIX AutoCAD 2024 ====="
Write-Host "1. Cài AutoCAD 2024"
Write-Host "2. Fix"
Write-Host "3. Thoát"

$choice = Read-Host "Chọn (1-3)"

switch ($choice) {
    "1" {
        Install-Software `
          -Name "AutoCAD 2024" `
          -Url "https://github.com/SurveyRoyal/AUTOCADDOWLOAD/releases/download/V2024/AutoCAD_2024_setup.exe" `
          -Installer "autocad2024.exe" `
          -InstallArgs "/S"
    }
    "2" {
        Fix-Software `
          -FixUrl "https://github.com/SurveyRoyal/AUTOCADDOWLOAD/releases/download/FIX24/acad.exe" `
          -TargetPath "C:\Program Files\Autodesk\AutoCAD 2024"
    }
    "3" { Write-Host "Thoát chương trình..."; break }
    Default { Write-Host "Lựa chọn không hợp lệ. Vui lòng thử lại!" }
}
