#!/bin/sh
#Misskey-run
cd ~

# Start Misskey!
forever start Misskey-API
forever start Misskey-Web
forever start Misskey-File

# Don't stop me
while :
do
	sleep 1
done
