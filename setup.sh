#!/bin/bash
#change 1.3
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

# Dừng, xóa và remove image cho watchtower và psclient nếu có
docker stop watchtower || true
docker rm watchtower || true
docker rmi containrrr/watchtower || true

docker stop psclient || true
docker rm psclient || true
docker rmi packetstream/psclient || true

# Cài đặt và khởi động Mysterium Node
docker pull mysterium/node:latest
docker run -d --restart=always --cap-add NET_ADMIN --net host --name mysterium-node \
-v mysterium_node_data:/var/lib/mysterium-node mysterium/node

# Liên kết node với tài khoản Mysterium bằng API key
docker exec mysterium-node mysterium-cli --api-key VoZzWV5bQLk0KuvJGxQotg2RBI1CyreLm21FrQBa claim
