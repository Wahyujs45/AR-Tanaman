@echo off
setlocal
cd /d "%~dp0"
title Hubungkan Kebun Pewarna AR ke GitHub

where git >nul 2>nul
if errorlevel 1 (
  echo Git belum terpasang di komputer ini.
  echo Unduh dari https://git-scm.com/download/win , pasang dengan pilihan bawaan, lalu jalankan berkas ini lagi.
  pause
  exit /b 1
)

git config user.name >nul 2>nul
if errorlevel 1 goto setname
goto checkemail
:setname
set /p GN=Nama Anda (untuk riwayat Git): 
git config --global user.name "%GN%"

:checkemail
git config user.email >nul 2>nul
if errorlevel 1 goto setemail
goto repo
:setemail
set /p GE=Email akun GitHub Anda: 
git config --global user.email "%GE%"

:repo
echo.
echo Buat dulu repositori KOSONG di https://github.com/new
echo   - Nama: kebun-pewarna-ar
echo   - Pilih Private
echo   - JANGAN centang "Add a README file"
echo.
set /p REPO=Tempel alamat repositori (contoh https://github.com/nama-akun/kebun-pewarna-ar.git): 
if "%REPO%"=="" (
  echo Alamat repositori kosong.
  pause
  exit /b 1
)

if not exist ".git" git init
git add .
git commit -m "Kebun Pewarna AR: versi awal"
git branch -M main
git remote remove origin >nul 2>nul
git remote add origin %REPO%
echo.
echo Mengunggah... Bila jendela login GitHub muncul, masuk dengan akun Anda.
git push -u origin main
if errorlevel 1 (
  echo.
  echo Unggahan gagal. Periksa alamat repositori dan login GitHub, lalu jalankan lagi.
  pause
  exit /b 1
)

echo.
echo Selesai. Proyek sudah tersambung ke GitHub.
echo Buka tab "Actions" di repositori untuk melihat build aplikasi Android.
pause
