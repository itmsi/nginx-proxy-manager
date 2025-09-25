#!/bin/bash

# Script Setup Nginx Proxy Manager untuk Docker Compose v2
# Jalankan dengan: chmod +x setup-v2.sh && ./setup-v2.sh

set -e

echo "🚀 Setup Nginx Proxy Manager dengan Docker Compose v2"
echo "=================================================="

# Cek apakah Docker terinstall
if ! command -v docker &> /dev/null; then
    echo "❌ Docker tidak ditemukan. Silakan install Docker terlebih dahulu."
    exit 1
fi

# Cek apakah Docker Compose v2 terinstall
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose v2 tidak ditemukan. Silakan install Docker Compose terlebih dahulu."
    exit 1
fi

echo "✅ Docker dan Docker Compose v2 sudah terinstall"

# Buat file .env jika belum ada
if [ ! -f .env ]; then
    echo "📝 Membuat file .env dari template..."
    cp env.example .env
    echo "✅ File .env berhasil dibuat"
    echo "⚠️  PENTING: Edit file .env dan ubah password default!"
else
    echo "✅ File .env sudah ada"
fi

# Buat direktori yang diperlukan
echo "📁 Membuat direktori untuk data..."
mkdir -p data mysql letsencrypt
echo "✅ Direktori berhasil dibuat"

# Pull image terbaru
echo "📥 Mengunduh image Docker..."
docker compose pull

# Jalankan container
echo "🚀 Menjalankan Nginx Proxy Manager..."
docker compose up -d

# Tunggu beberapa detik untuk container start
echo "⏳ Menunggu container start..."
sleep 10

# Cek status container
echo "📊 Status container:"
docker compose ps

# Cek apakah container berjalan
if docker compose ps | grep -q "Up"; then
    echo ""
    echo "🎉 Setup berhasil!"
    echo "=========================================="
    echo "🌐 Admin Panel: http://localhost:81"
    echo "📧 Default Login:"
    echo "   Email: admin@example.com"
    echo "   Password: changeme"
    echo ""
    echo "⚠️  PENTING:"
    echo "   1. Segera ubah password default!"
    echo "   2. Edit file .env untuk konfigurasi database"
    echo "   3. Setup SSL certificate untuk production"
    echo ""
    echo "📚 Dokumentasi lengkap ada di README.md"
    echo ""
    echo "🔧 Perintah berguna:"
    echo "   docker compose ps          # Cek status"
    echo "   docker compose logs        # Cek logs"
    echo "   docker compose down        # Stop container"
    echo "   docker compose restart     # Restart container"
else
    echo "❌ Container gagal start. Cek logs dengan:"
    echo "   docker compose logs"
fi
