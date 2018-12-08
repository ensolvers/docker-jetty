#!/bin/bash

# if $SSH_AUTH_KEYS_S3_URL is present, gather that keys and start SSH server
if [ ! -z $SSH_AUTH_KEYS_S3_URL ]; then
	echo "[INFO] Copying pubkey from [$SSH_AUTH_KEYS_S3_URL]"
	aws s3 cp $SSH_AUTH_KEYS_S3_URL /root/.ssh/authorized_keys
	service ssh start
fi