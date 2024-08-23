#!/bin/bash
#change 1.2
# Cập nhật hệ thống và cài đặt Docker (không cần sudo)
apt-get install -y docker.io

# Bật Docker và cho phép Docker khởi động cùng hệ thống
systemctl start docker
systemctl enable docker

# Kiểm tra xem có container nào đang chạy không, nếu có thì dừng và xóa tất cả
if [ "$(docker ps -q)" ]; then
    echo "Stopping and removing all running containers..."
    docker stop $(docker ps -q)
    docker rm $(docker ps -aq)
fi

# Dừng, xóa và remove image cho watchtower và psclient
docker stop watchtower
docker rm watchtower
docker rmi containrrr/watchtower

docker stop psclient
docker rm psclient
docker rmi packetstream/psclient

# Khởi động lại container psclient và watchtower
docker run -d --restart=always -e CID=6b2H --name psclient packetstream/psclient:latest

docker run -d --restart=always --name watchtower \
-v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower \
--cleanup --include-stopped --include-restarting --revive-stopped --interval 60 psclient
