#!/bin/bash

# Dừng và xóa tất cả các container Docker
echo "Stopping and removing all Docker containers..."
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Xóa Docker images
echo "Removing all Docker images..."
docker rmi $(docker images -q)

# Gỡ cài đặt Docker
echo "Uninstalling Docker..."
apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
apt-get autoremove -y --purge docker-engine docker docker.io docker-ce

# Xóa các file cấu hình và dữ liệu
rm -rf /var/lib/docker
rm -rf /var/run/docker.sock

# Xóa card mạng của Docker
ip link set docker0 down
ip link delete docker0

# Tải và cài đặt GaGaNode
echo "Downloading and installing GaGaNode..."
curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz 
tar -zxf apphub-linux-amd64.tar.gz 
rm -f apphub-linux-amd64.tar.gz 
cd ./apphub-linux-amd64

# Gỡ cài đặt dịch vụ hiện tại và cài đặt dịch vụ mới
./apphub service remove
./apphub service install

# Khởi động dịch vụ
./apphub service start

# Đặt token
./apps/gaganode/gaganode config set --token=vdxpwpxkfrsdkvlp8d853b4348808ab3

# Khởi động lại ứng dụng
./apphub restart

echo "Setup complete."
