#!/bin/bash
#

echo -e "[*] Desligando o Tor"
sudo systemctl stop tor

echo -e "[*] Reconfigurando Tor para o padrão"
sudo cp torrc.bak /etc/tor/torrc

echo -e "[*] Reconfigurando o DNS"
sudo cp resolv.conf.bak /etc/resolv.conf
