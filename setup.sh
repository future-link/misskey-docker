#!/bin/sh

cd ~
mkdir -p /data/db
mkdir /file

# Install some packages
apk update
echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk add --no-cache mongodb --allow-untrusted
apk add --no-cache redis graphicsmagick openssl nodejs python alpine-sdk
npm install -g forever node-gyp

git clone https://github.com/atnanasi/misskey-local-config.git ~/.misskey

# Build Misskey-Web
git clone git://github.com/misskey-delta/Misskey-Web.git
cd Misskey-Web
npm run deploy
cd ..

# Build Misskey-API
git clone git://github.com/misskey-delta/Misskey-API.git
cd Misskey-API
npm install
npm run build
cd ..

# Build Misskey-File
git clone git://github.com/misskey-delta/Misskey-File.git
cd Misskey-File
npm install
npm run build
cd ..
