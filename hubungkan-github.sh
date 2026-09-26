#!/usr/bin/env bash
# Hubungkan Kebun Pewarna AR ke GitHub (macOS / Linux)
set -e
cd "$(dirname "$0")"
command -v git >/dev/null || { echo "Git belum terpasang. Pasang dari https://git-scm.com lalu jalankan lagi."; exit 1; }
git config user.name  >/dev/null || { read -rp "Nama Anda (untuk riwayat Git): " GN; git config --global user.name "$GN"; }
git config user.email >/dev/null || { read -rp "Email akun GitHub Anda: " GE; git config --global user.email "$GE"; }
echo
echo "Buat dulu repositori KOSONG di https://github.com/new (Private, tanpa README)."
read -rp "Tempel alamat repositori (contoh https://github.com/nama-akun/kebun-pewarna-ar.git): " REPO
[ -n "$REPO" ] || { echo "Alamat repositori kosong."; exit 1; }
[ -d .git ] || git init
git add .
git commit -m "Kebun Pewarna AR: versi awal" || true
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO"
git push -u origin main
echo
echo "Selesai. Buka tab Actions di repositori untuk melihat build aplikasi Android."
