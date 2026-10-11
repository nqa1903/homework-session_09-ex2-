#!/usr/bin/env bash
# Bài 2: Chạy Nginx (nginx:alpine) với port mapping 8080:80,
# kiểm tra bằng curl, rồi dừng và xóa container.
# Cách dùng (KHÔNG gõ sudo):  bash bai2_nginx.sh

OUT=README.md

# Hàm run: ghi lệnh + kết quả (stdout và stderr) vào README.md
run() {
  {
    echo '```'
    echo "\$ $*"
  } >> "$OUT"
  "$@" >> "$OUT" 2>&1
  echo '```' >> "$OUT"
  echo >> "$OUT"
}

# Hàm title: ghi một tiêu đề vào README.md
title() {
  printf '\n## %s\n\n' "$1" >> "$OUT"
}

# Xóa container cũ tên my-web (nếu còn sót từ lần chạy trước) để tránh lỗi trùng tên
docker rm -f my-web > /dev/null 2>&1

# Phần đầu báo cáo
{
  echo "# Bài 2 - Nginx Web Server với Port Mapping"
  echo
  echo "- Thời gian chạy: $(date)"
  echo "- Image: nginx:alpine | Tên container: my-web | Ánh xạ cổng: 8080:80"
} > "$OUT"

title "1. Khởi chạy container (chế độ ngầm -d)"
run docker run -d -p 8080:80 --name my-web nginx:alpine
sleep 2   # chờ Nginx khởi động xong
run docker ps --filter name=my-web

title "2. Kiểm tra trang web bằng curl"
run curl -s http://localhost:8080

title "3. Dừng và xóa container"
run docker stop my-web
run docker rm my-web
run docker ps -a --filter name=my-web

# Tự kiểm tra kết quả mong đợi
if grep -q "Welcome to nginx!" "$OUT"; then
  echo "ĐẠT: curl trả về trang 'Welcome to nginx!'. Kết quả đã lưu vào $OUT"
else
  echo "CHƯA ĐẠT: không thấy 'Welcome to nginx!' trong $OUT, hãy xem lại file."
fi
