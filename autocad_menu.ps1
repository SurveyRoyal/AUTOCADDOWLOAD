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
        Start-Process -FilePath $Path -ArgumentList $InstallArgs -Wait
        Write-Host ">>> Hoan tat cai dat $Name`n"
    }
    catch {
        Write-Host "❌ Loi khi cai dat $Name : $($_.Exception.Message)"
    }
    finally {
        if (Test-Path $Path) { Remove-Item $Path -Force }
    }
}

Clear-Host
Write-Host "=== MENU CAI DAT ==="
Write-Host "1. AutoCAD 2026"
Write-Host "2. Thoat"

$choice = Read-Host "Nhap lua chon (1-2)"

switch ($choice) {
    "1" {
        Install-Software "AutoCAD 2026" `
          "https://github.com/SurveyRoyal/AUTOCADDOWLOAD/releases/download/V2026/AutoCAD_2026_1_English-US_en-US_setup_webinstall.exe" `
          "autocad2026.exe" `
          "/quiet /norestart"
    }
    "2" { Write-Host "Thoat chuong trinh..." }
    Default { Write-Host "Lua chon khong hop le!" }
}
