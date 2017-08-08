#!/bin/sh
# Misskey-Builder

# Initalize
cd ~
mkdir -p /data/db
mkdir /file

# Install some packages
apk update
echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk add --no-cache graphicsmagick openssl nodejs python alpine-sdk
npm install -g forever node-gyp

# Get Misskey
git clone git://github.com/misskey-delta/Misskey-Web.git
git clone git://github.com/misskey-delta/Misskey-API.git
git clone git://github.com/misskey-delta/Misskey-File.git

# Set config file for build Misskey-Web
mkdir ~/.misskey
cp ~/Misskey-Web/.ci/web.json ~/.misskey/web.json

# Build Misskey-Web
cd ~/Misskey-Web
npm run deploy

# Build Misskey-API
cd ~/Misskey-API
npm install
npm run build

# Build Misskey-File
cd ~/Misskey-File
npm install
npm run build

# Clean up
rm -rf ~/.misskey
