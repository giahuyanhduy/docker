#!/bin/bash

# Cập nhật hệ thống và loại bỏ Docker nếu đã cài đặt
echo "Updating system and removing Docker..."

sudo apt-get remove --purge -y docker.io

# Kiểm tra và xóa tất cả các container đang chạy (nếu có)
containers=$(docker ps -aq)
if [ -n "$containers" ]; then
  echo "Stopping and removing existing containers..."
  docker stop $containers
  docker rm $containers
else
  echo "No running containers to stop."
fi

# Xóa Docker hoàn toàn
sudo apt-get autoremove -y --purge docker.io
sudo apt-get autoclean
sudo rm -rf /var/lib/docker

# Tải về và giải nén GaGaNode
echo "Downloading and installing GaGaNode..."
curl -o apphub-linux-amd64.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz
tar -zxf apphub-linux-amd64.tar.gz
rm -f apphub-linux-amd64.tar.gz
cd ./apphub-linux-amd64

# Loại bỏ dịch vụ hiện có (nếu có) và cài đặt dịch vụ mới
sudo ./apphub service remove
sudo ./apphub service install

# Khởi động dịch vụ
sudo ./apphub service start

# Kiểm tra trạng thái dịch vụ
./apphub status

# Đảm bảo rằng trạng thái của GaGaNode là 'RUNNING'
if [[ $(./apphub status | grep "gaganode" | grep "RUNNING") ]]; then
  echo "GaGaNode is running."
else
  echo "Error: GaGaNode is not running."
  exit 1
fi

# Cấu hình token cho GaGaNode
echo "Configuring GaGaNode with token..."
sudo ./apps/gaganode/gaganode config set --token=vdxpwpxkfrsdkvlp8d853b4348808ab3

# Khởi động lại ứng dụng
sudo ./apphub restart

echo "GaGaNode setup complete."
