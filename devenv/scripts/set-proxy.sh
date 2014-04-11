#!/bin/sh
# set proxy for yum

PROXY=$1

if [ z$PROXY != "z" ]; then
    sudo cat > /etc/apt/apt.conf <<EOF
Acquire::http::proxy  "$PROXY";
Acquire::https::proxy "$PROXY";
Acquire::ftp::proxy   "$PROXY"; 
EOF

fi
