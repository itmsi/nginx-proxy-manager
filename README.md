# Setup Nginx Proxy Manager dengan Docker

Nginx Proxy Manager adalah solusi mudah untuk mengelola reverse proxy dengan antarmuka web yang user-friendly.

## Persyaratan

- Docker
- Docker Compose
- Port 80, 81, dan 443 tersedia di server Anda

## Instalasi

### 1. Clone atau Download Repository

```bash
git clone <repository-url>
cd nginx-proxy-manager
```

### 2. Konfigurasi Environment

Salin file `env.example` menjadi `.env` dan sesuaikan konfigurasi:

```bash
cp env.example .env
```

Edit file `.env` dengan konfigurasi yang sesuai:

```bash
nano .env
```

**PENTING:** Ubah password default untuk keamanan!

### 3. Jalankan Setup

```bash
# Buat direktori untuk data
mkdir -p data mysql letsencrypt

# Jalankan container
docker-compose up -d
```

### 4. Akses Web Interface

Buka browser dan akses:
- **Admin Panel:** http://your-server-ip:81
- **Default Login:**
  - Email: `admin@example.com`
  - Password: `changeme`

**PENTING:** Segera ubah password default setelah login pertama!

## Konfigurasi SSL

### Menggunakan Let's Encrypt

1. Login ke admin panel
2. Pergi ke "SSL Certificates"
3. Klik "Add SSL Certificate"
4. Pilih "Let's Encrypt"
5. Masukkan domain dan email Anda
6. Klik "Save"

### Menggunakan Custom Certificate

1. Upload file certificate (.crt) dan private key (.key)
2. Atau paste langsung ke form

## Mengelola Proxy Hosts

1. Pergi ke "Proxy Hosts"
2. Klik "Add Proxy Host"
3. Konfigurasi:
   - **Domain Names:** domain yang akan di-proxy
   - **Scheme:** http atau https
   - **Forward Hostname/IP:** IP atau hostname target
   - **Forward Port:** port target
   - **SSL Certificate:** pilih certificate yang sudah dibuat

## Port yang Digunakan

- **80:** HTTP traffic
- **81:** Admin web interface
- **443:** HTTPS traffic

## Backup dan Restore

### Backup Data

```bash
# Backup database
docker exec npm-db mysqldump -u npm -p npm > backup.sql

# Backup konfigurasi
tar -czf npm-backup.tar.gz data/ mysql/ letsencrypt/
```

### Restore Data

```bash
# Restore database
docker exec -i npm-db mysql -u npm -p npm < backup.sql

# Restore konfigurasi
tar -xzf npm-backup.tar.gz
```

## Troubleshooting

### Container Tidak Start

```bash
# Cek logs
docker-compose logs

# Restart container
docker-compose restart
```

### Port Sudah Digunakan

Jika port 80, 81, atau 443 sudah digunakan:

1. Edit `docker-compose.yml`
2. Ubah mapping port di bagian `ports:`
3. Contoh: `'8080:80'` untuk menggunakan port 8080

### Database Connection Error

```bash
# Cek status database
docker-compose ps db

# Restart database
docker-compose restart db
```

## Update

```bash
# Pull image terbaru
docker-compose pull

# Restart dengan image baru
docker-compose up -d
```

## Uninstall

```bash
# Stop dan hapus container
docker-compose down

# Hapus data (HATI-HATI!)
rm -rf data/ mysql/ letsencrypt/
```

## Keamanan

1. **Ubah password default** segera setelah instalasi
2. **Gunakan SSL certificate** untuk domain production
3. **Backup data** secara berkala
4. **Update** secara rutin untuk patch keamanan
5. **Firewall** - hanya buka port yang diperlukan

## Support

- [Dokumentasi Resmi](https://nginxproxymanager.com/)
- [GitHub Repository](https://github.com/NginxProxyManager/nginx-proxy-manager)
- [Docker Hub](https://hub.docker.com/r/jc21/nginx-proxy-manager)
