#!/bin/bash

# Cập nhật hệ thống và cài đặt Docker nếu chưa có
echo "Updating system and installing Docker..."

sudo apt-get install -y docker.io

# Kiểm tra và khởi động Docker nếu chưa chạy
sudo systemctl start docker
sudo systemctl enable docker

# Lấy danh sách tất cả các container đang chạy
containers=$(docker ps -aq)

# Kiểm tra và xóa tất cả các container đang chạy
if [ -n "$containers" ]; then
  echo "Stopping and removing existing containers..."
  docker stop $containers
  docker rm $containers
else
  echo "No running containers to stop."
fi

# Đọc nội dung từ file /opt/autorun và lấy 4 hoặc 5 ký tự phía trước ':localhost:22'
if [ -f /opt/autorun ]; then
  device_name=$(grep -o '.\{4,5\}:localhost:22' /opt/autorun | cut -d':' -f1)  # Lấy 4 hoặc 5 ký tự phía trước ':localhost:22'
  device_id="${device_name}1"  # Tạo device_id từ device_name
else
  echo "File /opt/autorun không tồn tại!"
  exit 1
fi

# Cài đặt và chạy IPRoyal Pawns
docker pull iproyal/pawns-cli:latest
docker run --restart=on-failure:5 \
  --name iproyal_pawn \
  iproyal/pawns-cli:latest \
  -email=giahuyanhduy@gmail.com \
  -password=Anhduy3112 \
  -device-name="$device_name" \
  -device-id="$device_id" \
  -accept-tos
