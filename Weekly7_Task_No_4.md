Konsep Dasar Linux, SSH, HTTP/HTTPS, dan Docker
Rangkuman beserta contoh

A. Linux Kernel vs Distro
Kernel adalah inti sistem operasi Linux yang mengatur hardware, memori, dan proses. Kernel sendiri tidak bisa dipakai langsung oleh pengguna biasa.
Distro adalah paket lengkap yang dibangun di atas kernel, ditambah package manager, shell, dan aplikasi, sehingga siap dipakai.
Contoh: Ubuntu, Debian, dan Fedora sama-sama memakai Linux Kernel, tapi beda package manager dan tampilan.

B. Linux FHS
FHS (Filesystem Hierarchy Standard) mengatur letak folder di Linux agar konsisten di semua distro.
-	/etc — file konfigurasi, contoh: /etc/ssh/sshd_config
-	/home — folder pribadi tiap user
-	/var — file yang sering berubah, contoh log di /var/log
-	/bin, /usr — tempat program dan aplikasi
-	/tmp — file sementara
Contoh: saat mau cek log server, admin langsung buka /var/log tanpa perlu menebak-nebak lokasinya.

C. Permission dan Owner
Tiap file punya owner (user), group, dan others. Masing-masing bisa diberi izin read (r), write (w), dan execute (x).

-rwxr-xr--  1 andi developer  deploy.sh

Artinya: owner (andi) boleh baca/tulis/jalankan, group boleh baca/jalankan, others cuma boleh baca.

chmod 750 deploy.sh
chown andi:developer deploy.sh

chmod mengubah hak akses, chown mengubah kepemilikan file.

D. Bash, sh, dan Shell Lain
Shell adalah program untuk menjalankan perintah di terminal.
-	sh — shell paling dasar, ringan tapi fiturnya minim
-	bash — pengembangan dari sh, jadi default di banyak distro, fiturnya lebih lengkap (history, auto-complete, array)
-	zsh — mirip bash tapi lebih bisa dikustomisasi, dipakai banyak developer
-	fish — lebih ramah pemula, ada saran perintah otomatis
Contoh: baris pertama script seperti #!/bin/bash menentukan shell apa yang dipakai untuk menjalankan script itu.

E. Enkripsi pada SSH
SSH dipakai untuk remote ke server dengan aman. Ada 3 mekanisme yang berperan:
-	Enkripsi asimetris — dipakai di awal untuk key exchange dan autentikasi (kunci publik & privat)
-	Enkripsi simetris (AES) — dipakai untuk mengenkripsi data selama sesi berlangsung, karena lebih cepat
-	Hashing (HMAC) — memastikan data yang dikirim tidak diubah di tengah jalan
Contoh: ssh-keygen membuat pasangan kunci, lalu kunci publik dikirim ke server supaya bisa login tanpa password tapi tetap aman.

F. HTTP vs HTTPS
HTTP mengirim data tanpa enkripsi (plain text), jadi bisa disadap. Pakai port 80.
HTTPS menambahkan enkripsi TLS/SSL sehingga data aman meski disadap. Pakai port 443 dan butuh sertifikat SSL.
Contoh: situs bank wajib pakai HTTPS supaya data login nasabah tidak bisa dibaca orang lain.

G. Docker OCI Compliance
OCI (Open Container Initiative) adalah standar terbuka untuk format image dan cara container dijalankan, supaya tidak tergantung satu vendor saja.
Docker sudah mengikuti standar OCI, jadi image yang dibuat pakai Docker bisa dijalankan di runtime lain seperti containerd atau Podman.
Contoh: image dibuat dengan docker build, lalu dijalankan di Kubernetes yang pakai containerd — tetap jalan karena sama-sama ikut standar OCI.

H. Container vs VM
VM menjalankan sistem operasi penuh sendiri-sendiri lewat hypervisor. Ukurannya besar dan booting-nya lambat.
Container berbagi kernel yang sama dengan host, jadi lebih ringan dan cepat nyala (hitungan detik).
Contoh: kalau butuh beberapa OS berbeda (Windows dan Linux), pakai VM. Kalau cuma butuh banyak instance aplikasi Linux, container lebih hemat resource.

I. Image Layer pada Docker
Docker image tersusun dari beberapa layer yang bertumpuk. Setiap baris di Dockerfile biasanya jadi satu layer baru.

FROM node:18-alpine
COPY package.json .
RUN npm install
COPY . .

Manfaatnya: layer yang sama bisa dipakai bareng antar image (hemat storage), dan layer yang tidak berubah bisa dipakai dari cache supaya build lebih cepat.

J. Docker Volume dan Network
Volume
Data di dalam container biasanya hilang kalau container dihapus. Volume dipakai supaya data tetap tersimpan meski container-nya diganti.

docker volume create db_data
docker run -d -v db_data:/var/lib/mysql mysql:8

Network
Docker network menghubungkan antar container agar bisa saling komunikasi.

docker network create app-network
docker run -d --name backend --network app-network myapp
docker run -d --name db --network app-network mysql:8

Contoh: container backend bisa langsung konek ke database cukup pakai nama 'db', tanpa perlu tahu IP-nya.

K. Web Server dan Reverse Proxy
Web server menerima request dari browser dan mengirim balik halaman web. Contoh: Nginx, Apache.
Reverse proxy adalah server perantara yang meneruskan request ke server backend yang sesuai, tanpa klien tahu server aslinya.
-	Load balancing — membagi trafik ke beberapa server
-	Keamanan — menyembunyikan server backend
-	SSL termination — menangani enkripsi di satu titik

location /api/ {
    proxy_pass http://backend:3000/;
}

Contoh: request ke /api/ diarahkan ke server backend, request lain diarahkan ke frontend — semua lewat satu domain.


