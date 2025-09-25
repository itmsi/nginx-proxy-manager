#!/bin/bash

# Script Setup Nginx Proxy Manager
# Jalankan dengan: chmod +x setup.sh && ./setup.sh

set -e

echo "🚀 Setup Nginx Proxy Manager dengan Docker"
echo "=========================================="

# Cek apakah Docker terinstall
if ! command -v docker &> /dev/null; then
    echo "❌ Docker tidak ditemukan. Silakan install Docker terlebih dahulu."
    exit 1
fi

# Cek apakah Docker Compose terinstall
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose tidak ditemukan. Silakan install Docker Compose terlebih dahulu."
    exit 1
fi

echo "✅ Docker dan Docker Compose sudah terinstall"

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

# Cek apakah port sudah digunakan
echo "🔍 Mengecek port yang digunakan..."

check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "⚠️  Port $port sudah digunakan"
        return 1
    else
        echo "✅ Port $port tersedia"
        return 0
    fi
}

ports_available=true
check_port 80 || ports_available=false
check_port 81 || ports_available=false
check_port 443 || ports_available=false

if [ "$ports_available" = false ]; then
    echo "❌ Beberapa port sudah digunakan. Silakan hentikan service yang menggunakan port tersebut atau edit docker-compose.yml"
    echo "💡 Anda bisa mengubah mapping port di docker-compose.yml"
    exit 1
fi

# Pull image terbaru
echo "📥 Mengunduh image Docker..."
docker-compose pull

# Jalankan container
echo "🚀 Menjalankan Nginx Proxy Manager..."
docker-compose up -d

# Tunggu beberapa detik untuk container start
echo "⏳ Menunggu container start..."
sleep 10

# Cek status container
echo "📊 Status container:"
docker-compose ps

# Cek apakah container berjalan
if docker-compose ps | grep -q "Up"; then
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
else
    echo "❌ Container gagal start. Cek logs dengan:"
    echo "   docker-compose logs"
fi
