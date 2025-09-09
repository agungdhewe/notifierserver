FROM node:24

# Set direktori kerja di dalam container
WORKDIR /app

# Salin file package.json dan package-lock.json untuk instalasi dependensi
COPY package*.json ./

# Install dependensi (gunakan --production jika hanya butuh untuk runtime)
RUN npm install --production

# Salin seluruh source code ke dalam container
COPY . .

# Tentukan port yang digunakan oleh aplikasi
EXPOSE 8080

# Jalankan aplikasi
CMD ["node", "src/index.js"]
