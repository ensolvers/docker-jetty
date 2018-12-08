#!/bin/bash

mkdir -p /var/run/sshd
mkdir /root/.ssh
chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys