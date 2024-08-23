#!/bin/bash
#change 1.4
# Cập nhật hệ thống và cài đặt Docker
apt-get update
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

# Xóa container và image không cần thiết
docker stop myst || true
docker rm myst || true
docker rmi mysteriumnetwork/myst || true

# Tải về Mysterium Node Docker image
docker pull mysteriumnetwork/myst:latest

# Khởi động Mysterium Node
docker run --cap-add NET_ADMIN -d -p 4449:4449 --name myst \
-v /home/client-repo/docker:/var/lib/mysterium-node --restart unless-stopped \
mysteriumnetwork/myst:latest service --agreed-terms-and-conditions

# Liên kết node với tài khoản Mysterium bằng API key
docker exec myst myst cli mmn VoZzWV5bQLk0KuvJGxQotg2RBI1CyreLm21FrQBa
