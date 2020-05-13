#!/bin/bash

echo -e "[*] Desativando Tor..."
#sudo systemctl stop tor

echo -e "[*] Habilitando Proxy Transparente e DNS Proxy no Tor..."
#sudo cp torrc /etc/tor/torrc

echo -e "[*] Configurando o DNS Resolver para trabalhar com o dor Tor..."
#sudo cp resolv.conf /etc/resolv.conf

echo -e "[*] Configurando o Iptables..."
#sudo ./iptables-rules.sh

echo -e "[*] Ativando Tor..."
#sudo systemctl start tor

echo -e "[*] Testando conexão com o Tor"
curl -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs

