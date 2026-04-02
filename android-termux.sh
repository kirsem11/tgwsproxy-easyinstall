set -e

# constants
SECRET="71aff5b77c58c1f13efa5e48ded5acf3" # without 'dd' prefix
TG_WS_PROXY_RUN_CMD="python ~/tg-ws-proxy/proxy/tg_ws_proxy.py --secret $SECRET --dc-ip 5:149.154.175.55"
BASHRC="~/.bashrc"

# termux update & upgrade & install requirement packages
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y git python python-pip python-cryptography

# cloning into ~/ directory
git clone https://github.com/Flowseal/tg-ws-proxy && cd tg-ws-proxy

# start proxy
$TG_WS_PROXY_RUN_CMD
echo "Proxy started!"

# set autocommand in $BASHRC
echo "$TG_WS_PROXY_RUN_CMD" >> $BASHRC
