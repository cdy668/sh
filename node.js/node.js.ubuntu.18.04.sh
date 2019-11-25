#!/usr/bin/env bash
# Node.js script file example
#     ./node.js.ubuntu.18.04.sh $1 $2
#     ./node.js.ubuntu.18.04.sh init 13.2.0
# Node.js About Docs
#     https://nodejs.org/en/docs/

init(){
    pm2 stop all
    rm -f /usr/bin/node
    rm -f /usr/bin/npm
    rm -f /usr/bin/pm2
    apt -y install libstdc++6 libc6
    wget https://nodejs.org/dist/v$1/node-v$1-linux-x64.tar.gz
    tar -xvf node-v$1-linux-x64.tar.gz -C /usr/local/
    ln -s /usr/local/node-v$1-linux-x64/bin/node /usr/bin/node
    ln -s /usr/local/node-v$1-linux-x64/bin/npm /usr/bin/npm
    npm install pm2 -g
    ln -s /usr/local/node-v$1-linux-x64/bin/pm2 /usr/bin/pm2
    rm -f node-v$1-linux-x64.tar.gz
}

case $1 in
    init)
        init "$2"
    ;;
esac
