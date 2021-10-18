set -x
exec > /home/logfile.log        2>&1
date
sudo -i

sudo apt install -y docker.io
 
git clone https://github.com/dyarleniber/docker-php.git

sleep 10

cd docker-php
docker-compose build app

sleep 5

docker-compose --env-file .env.example up -d