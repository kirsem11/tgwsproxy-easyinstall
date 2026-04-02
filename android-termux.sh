##################################################
# android-termux.sh
# Borrowed from https://gist.githubusercontent.com/mtkpapa/3ad8841d7f93b5f33ae26ef4111e6c62/raw/69d3365acd01295872b2808b27dfb940764821de/tg-ws-proxy-install.sh
# Copyrigth (c) 2026 Kirill Semenov
##################################################

set -ex

# constants
REPO_NAME="tg-ws-proxy"
REPO_ROOT="$HOME"
BASHRC="$HOME/.bashrc"

# this is random secret, you can use it or generate your own MTProto proxy secret
SECRET="71aff5b77c58c1f13efa5e48ded5acf3" # without 'dd' prefix
PORT=1443
DC_IP="
--dc-ip 1:149.154.175.50
--dc-ip 2:149.154.167.220
--dc-ip 3:149.154.175.100
--dc-ip 4:149.154.167.220
--dc-ip 5:149.154.171.5
--dc-ip 5:149.154.175.55
--dc-ip 203:91.105.192.100"

CMD="tg_ws_proxy.py"

# run proxy
run_proxy( )
{
  if ! pgrep -f "$CMD" > /dev/null; then
    nohup python $REPO_ROOT/$REPO_NAME/proxy/tg_ws_proxy.py -v --port $PORT --secret $SECRET $DC_IP 2>&1 | tee nohup.log &
    echo "The proxy server is started"
  else
    echo "The proxy server is already running"
  fi
}

# create autocommand in $BASHRC
update_bashrc( )
{
  echo "pgrep -f '$CMD' > /dev/null || nohup python $REPO_ROOT/$REPO_NAME/proxy/tg_ws_proxy.py --port $PORT --secret $SECRET $DC_IP &" >> $BASHRC
  echo "Created autocommand in $BASHRC"
}

# termux update & upgrade & install requirement packages
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y git python python-pip python-cryptography

# cloning repo
if [ -d "$REPO_ROOT/$REPO_NAME" ]; then
    echo "Update repository..."
    cd "$REPO_ROOT/$REPO_NAME" && git pull
else
    echo "Clone repository..."
    git clone "https://github.com/Flowseal/$REPO_NAME" "$REPO_ROOT/$REPO_NAME"
fi

# start
update_bashrc
run_proxy

##################################################
