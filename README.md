# Notifier Server

Layanan WebSocket & HTTP Push Notification Server ringan berbasis Node.js dan Express. Layanan ini menghubungkan service backend/utama dengan client/browser secara realtime melalui WebSocket berdasarkan `clientId`.

---

## 🚀 Fitur

- **Realtime WebSocket Connection**: Client terhubung dengan parameter identifikasi `clientId`.
- **HTTP Webhook Push Endpoint (`/notify`)**: Service backend dapat mengirim payload notifikasi ke client tertentu via HTTP POST.
- **Multi-Architecture Docker Image**: Mendukung arsitektur `linux/amd64` (x86_64) dan `linux/arm64` (Apple Silicon, ARM server).
- **Proses Port Cleanup Otomatis**: Script runner otomatis mematikan proses lama yang menduduki port sebelum start.

---

## ⚙️ Konfigurasi Environtment (`.env`)

Buat file `.env` di root direktori (atau duplikasi dari `.env-example`):

```env
PORT=8989
```

---

## 📦 Menjalankan Server Secara Lokal

### Menggunakan Script Runner (Rekomendasi)
Script ini otomatis mengecek dan menghentikan proses lama yang memakai port sebelum menjalankan server:

- **Linux / macOS:**
  ```bash
  ./run
  ```
- **Windows:**
  ```cmd
  run.bat
  ```

### Menggunakan NPM
```bash
npm install
npm run start
```

### Menggunakan PM2 (Production Daemon)
- **Linux:**
  ```bash
  ./start
  ```
- **Windows:**
  ```cmd
  start.bat
  ```

---

## 🐳 Docker Deployment

Image resmi telah dipublikasikan ke Docker Hub dengan dukungan multi-platform (`linux/amd64` dan `linux/arm64`).

### 1. Jalankan via Docker Run
```bash
docker run -d \
  --name notifierserver \
  -p 8989:8989 \
  --restart unless-stopped \
  dhewe/notifierserver:latest
```

### 2. Jalankan via Docker Compose
Gunakan file `docker-compose.yml`:

```yaml
version: '3.8'

networks:
  docker1:
    external: true

services:
  notifierserver:
    container_name: notifierserver
    image: dhewe/notifierserver:latest
    environment:
      - PORT=8989
    ports:
      - "8989:8989"
    networks:
      - docker1
    restart: unless-stopped
```

Jalankan perintah:
```bash
docker compose up -d
```

### 3. Build & Push Multi-Platform Image
Untuk build dan push image baru ke Docker Hub:
```bash
./build
```

---

## 🔌 API & WebSocket Usage

### 1. WebSocket Client Connection
Client (browser / frontend) terhubung ke server dengan query parameter `clientId`:

```javascript
const clientId = "USER_12345";
const ws = new WebSocket(`ws://localhost:8989/?clientId=${clientId}`);

ws.onopen = () => {
  console.log("Terhubung ke Notifier Server");
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log("Notifikasi diterima:", data);
};

ws.onclose = () => {
  console.log("Koneksi terputus");
};
```

### 2. HTTP Push Notification Endpoint
Kirim notifikasi dari backend ke client yang sedang terhubung melalui endpoint HTTP POST `/notify`:

- **URL:** `POST http://localhost:8989/notify`
- **Headers:** `Content-Type: application/json`
- **Body:**
  ```json
  {
    "clientId": "USER_12345",
    "status": "success",
    "info": "Proses sinkronisasi data telah selesai."
  }
  ```

- **Response:**
  - `200 OK` jika notifikasi berhasil diteruskan ke client.
  - `400 Bad Request` jika `clientId` atau `status` kosong.
