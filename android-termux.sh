set -e

# constants
REPO_NAME="tg-ws-proxy"
REPO_ROOT="~/"
BASHRC="~/.bashrc"

RUN_CMD="pgrep -f "tg_ws_proxy.py" > /dev/null || nohup python $REPO_ROOT/$REPO_NAME/proxy/tg_ws_proxy.py --secret $SECRET --dc-ip 5:149.154.175.55 &"
SECRET="71aff5b77c58c1f13efa5e48ded5acf3" # without 'dd' prefix # this is random secret, you can use it or generate your own MTProxy secret

# termux update & upgrade & install requirement packages
pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y git python python-pip python-cryptography

# cloning into ~/ directory
cd $REPO_ROOT && git clone "https://github.com/Flowseal/$REPO_NAME"

# set autocommand in $BASHRC
echo "$RUN_CMD" >> $BASHRC

# start proxy
$RUN_CMD
