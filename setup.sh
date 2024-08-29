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
sudo docker stop watchtower; sudo docker rm watchtower; sudo docker rmi containrrr/watchtower; \
sudo docker stop psclient; sudo docker rm psclient; sudo docker rmi packetstream/psclient; \
sudo docker run -d --restart=always -e CID=6b2H \
--name psclient packetstream/psclient:latest && sudo docker run -d --restart=always \
--name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower \
--cleanup --include-stopped --include-restarting --revive-stopped --interval 60 psclient
