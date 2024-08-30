#!/bin/bash

# Cập nhật hệ thống và cài đặt Docker nếu chưa có

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

# Lấy device-name từ tệp /opt/autorun
if [ -f /opt/autorun ]; then
  device_name=$(grep -oP '.*(?=:localhost:22)' /opt/autorun | head -n 1 | cut -c 1-5)
else
  echo "File /opt/autorun not found, using default device name."
  device_name="default"
fi

# Tải về và chạy Traffmonetizer
docker pull traffmonetizer/cli_v2:latest
docker run -i --name tm traffmonetizer/cli_v2 start accept --token SLJuGVmels0skr0k1Ydd+OtUimqd8Dy8SMdpZSu6vX8= --device-name "$device_name"

echo "Setup complete."
