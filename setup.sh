#!/usr/bin/env bash

# Um echo bonito | A beautiful echo
# echo -e "${GREEN}[*]${NC}"

# Parte importantíssima do código | Important part of code
RED='\033[0;31m'
GREEN='\033[0;32'
NC='\033[0m' # No Color

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}Por favor, inicie como root \nPlease run as root${NC}"
  exit
fi

stop_tor (){
  echo -e "${GREEN}[*]${NC} Desligando o Tor | Turning off Tor"
  systemctl stop tor
  # Verificar se o Tor foi desligado ou não
}

setup_backup (){
  stop_tor

  # Back Up Tor
  echo -e  "${GREEN}[*]${NC} Fazendo backup do arquivo de configuração do Tor | Backing Up Tor's config file"
  mkdir config; mkdir config/torrc.d
  cp /etc/tor/torrc config/torrc.d/torrc; cp /etc/tor/torrc config/torrc.d/torrc.bak

  # Back Up DNS Resolver
  echo -e  "${GREEN}[*]${NC} Fazendo backup do arquivo de configuração do DNS resolver | Backing Up DNS resolver's config file"
  mkdir config/resolv.d
  cp /etc/resolv.conf config/resolv.d/resolv.conf.bak; cp /etc/resolv.conf config/resolv.d/resolv.conf

}

config_torrc (){
  stop_tor

  echo -e "${GREEN}[*]${NC} Configurando o arquivo de configuração do Tor | Configuring Tor's config file"
  echo "## Transparent Proxy Settings" >> config/torrc.d/torrc
  echo "## :)" >> config/torrc.d/torrc
  echo "VirtualAddrNetworkIPv4 10.192.0.0/10" >> config/torrc.d/torrc
  echo "AutomapHostsOnResolve 1" >> config/torrc.d/torrc
  echo "TransPort 9040 IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort" >> config/torrc.d/torrc
  echo "DNSPort 5353" >> config/torrc.d/torrc

}

config_dns (){

  echo -e "${GREEN}[*]${NC} Configurando o DNS Resolver | Configuring the DNS Resolver"
  echo "nameserver 127.0.0.1" >> config/resolv.d/resolv.conf

}

ativar_transProxy (){
  
  echo -e "${GREEN}[*]${NC} Ativando as configurações de Proxy Transparente | Activating Transparent Proxy's configuration files"
  cp config/torrc.d/torrc /etc/tor/config_torrc
  cp config/resolv.d/resolv.conf /etc/resolv.config

  echo -e "${GREEN}[*]${NC} Configurando as regras do Iptables | Configuring Iptables' rules"
  # Informando variáveis para o iptables | Setting iptables variables
  if [ $1 == "debian"]; then
    UID='debian-tor'
  else
    UID='tor'
  fi
  ./iptables-transProxy.sh $UID $2

}
