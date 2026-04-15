#!/bin/bash
sudo ufw default deny incoming
sudo ufw allow 22
sudo ufw allow 80
sudo ufw default allow outgoing
sudo ufw allow 53
sudo ufw allow 8080
sudo ufw allow 2375
sudo ufw allow 51820
sudo ufw allow 389
sudo ufw allow 389636
sudo ufw allow 636
sudo ufw allow 9100
sudo ufw allow 9090
sudo ufw allow 3306
sudo ufw allow 3000
sudo ufw allow 9093
sudo ufw reload
sudo ufw status