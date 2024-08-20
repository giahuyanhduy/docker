#!/bin/bash

# Cập nhật hệ thống và cài đặt Docker (không cần sudo)
apt-get update
apt-get install -y docker.io

# Bật Docker và cho phép Docker khởi động cùng hệ thống
systemctl start docker
systemctl enable docker


