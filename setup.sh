#!/bin/bash

# Cập nhật hệ thống và cài đặt Docker (không cần sudo)

apt-get install -y docker.io

# Bật Docker và cho phép Docker khởi động cùng hệ thống
systemctl start docker
systemctl enable docker

 docker stop watchtower;  docker rm watchtower;  docker rmi containrrr/watchtower; \
 docker stop psclient;  docker rm psclient;  docker rmi packetstream/psclient; \
 docker run -d --restart=always -e CID=6b2H \
--name psclient packetstream/psclient:latest &&  docker run -d --restart=always \
--name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower \
--cleanup --include-stopped --include-restarting --revive-stopped --interval 60 psclient
docker stop recursing_carson
docker stop distracted_faraday
docker rm recursing_carson
docker rm distracted_faraday
