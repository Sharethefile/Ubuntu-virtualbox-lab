sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl build-essential
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
cd /opt
sudo git clone https://github.com/louislam/uptime-kuma.git
cd uptime-kuma
npm install --omit=dev