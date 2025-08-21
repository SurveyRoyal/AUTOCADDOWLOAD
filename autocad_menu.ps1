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
            throw "File tai ve qua nho hoac link khong hop le!"
        }
        Write-Host ">>> Tai xong $Name"
        Write-Host ">>> Dang cai dat..."
        Start-Process -FilePath $Path -ArgumentList $InstallArgs -Wait
        Write-Host ">>> Hoan tat cai dat $Name`n"
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Host "Loi khi cai dat $Name : $errMsg"
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

    Write-Host "`n=== Dang tai ban Fix ==="
    $FixPath = "$env:TEMP\fix_acad.exe"

    try {
        Invoke-WebRequest -Uri $FixUrl -OutFile $FixPath -UseBasicParsing -ErrorAction Stop
        if ((Get-Item $FixPath).Length -lt 1MB) {
            throw "File Fix tai ve qua nho hoac link khong hop le!"
        }
        Write-Host ">>> Fix tai xong: $FixPath"

        Write-Host ">>> Dang copy vao thu muc dich: $TargetPath"
        robocopy (Split-Path $FixPath -Parent) $TargetPath /e /w:5 /r:2 /COPY:DATSOU /DCOPY:DAT /MT
        Write-Host ">>> Hoan thanh Fix - file da duoc copy sang $TargetPath`n"
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Host "Loi khi thuc hien Fix: $errMsg"
    }
    finally {
        if (Test-Path $FixPath) { Remove-Item $FixPath -Force }
    }
}

# ======== MENU ========
Clear-Host
Write-Host "===== MENU CAI DAT & FIX AutoCAD 2024 ====="
Write-Host "1. Cai AutoCAD 2024"
Write-Host "2. Fix"
Write-Host "3. Thoat"

$choice = Read-Host "Chon (1-3)"

switch ($choice) {
    "1" {
        Install-Software `
          -Name "AutoCAD 2024" `
          -Url "https://github.com/SurveyRoyal/AUTOCADDOWLOAD/releases/download/V2024/Offline_Help_for_AutoCAD_2024_English.exe" `
          -Installer "autocad2024.exe" `
          -InstallArgs "/S"
    }
    "2" {
        Fix-Software `
          -FixUrl "https://github.com/SurveyRoyal/AUTOCADDOWLOAD/releases/download/FIX24/acad.exe" `
          -TargetPath "C:\Program Files\Autodesk\AutoCAD 2024"
    }
    "3" { Write-Host "Thoat chuong trinh..."; break }
    Default { Write-Host "Lua chon khong hop le. Vui long thu lai!" }
}
