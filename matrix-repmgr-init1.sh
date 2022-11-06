#!/bin/bash

# This script contains all the immediate container setup that occurs after starting it.
echo 'Launching matrix-repmgr-init1.sh...'

# Launch Dropbear
/usr/sbin/dropbear -Eas -p 2222 -r /etc/dropbear/dropbear_ed25519_host_key
sleep 15
rm -f /var/lib/postgresql/.ssh/known_hosts # is this even needed?
awk '/^Host / {print $2}' ~/.ssh/config |xargs -n1 ssh -T -o 'StrictHostKeyChecking no'

# OUTPUT IF SUCCEED

# postgres@ab922b2d3517:/$ awk '/^Host / {print $2}' ~/.ssh/config |xargs -n1 ssh -T -o 'StrictHostKeyChecking no'
# Warning: Permanently added '[matrix.perthchat2.org]:2222,[188.166.182.215]:2222' (ED25519) to the list of known hosts.

# OUTPUT IF FAILED

# postgres@ab922b2d3517:/$ awk '/^Host / {print $2}' ~/.ssh/config |xargs -n1 ssh -T -o 'StrictHostKeyChecking no'
# ssh: connect to host matrix.perthchat2.org port 2222: Connection refused
# xargs: ssh: exited with status 255; aborting


#From within a db (as superuser): select pg_reload_conf();

/matrix-repmgr-init2.sh