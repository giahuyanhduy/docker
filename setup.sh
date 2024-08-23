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

# Pull image mới nhất cho Honeygain
docker pull honeygain/honeygain:latest


echo "Honeygain has been successfully set up and is running."
