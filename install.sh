#!/bin/bash

module="$(pwd)/module"
rm -rf "$module"
wget -O "$module" "https://raw.githubusercontent.com/rudi9999/Herramientas/main/module/module" &>/dev/null
[[ ! -e "$module" ]] && exit
chmod +x "$module" &>/dev/null
source "$module"

CTRL_C(){
  rm -rf "$module"
  exit
}

# Never trap EXIT (it kills the installer)
trap CTRL_C INT TERM

if [[ $(id -u) != 0 ]]; then
  clear
  msg -bar
  print_center -ama "ERROR DE EJECUCION"
  msg -bar
  print_center -ama "DEVE EJECUTAR DESDE EL USUSRIO ROOT"
  msg -bar
  CTRL_C
fi

ADMRufu="/etc/ADMRufu"
ADM_inst="$ADMRufu/install"
tmp="$ADMRufu/tmp"
SCPinstal="$HOME/install"

mkdir -p "$ADMRufu" "$ADM_inst" "$tmp"

# Save installer copy
cp -f "$0" "$ADMRufu/install.sh"
rm -f "$0" &>/dev/null

# Author mode (no license)
echo ">> License check disabled (author mode)"
sleep 1

stop_install(){
  title "INSTALACION CANCELADA"
  exit
}

time_reboot(){
  print_center -ama "REINICIANDO VPS EN $1 SEGUNDOS"
  REBOOT_TIMEOUT="$1"

  while [ "$REBOOT_TIMEOUT" -gt 0 ]; do
     print_center -ne "-$REBOOT_TIMEOUT-\r"
     sleep 1
     : $((REBOOT_TIMEOUT--))
  done
  reboot
}

repo_install(){
  link="https://raw.githubusercontent.com/rudi9999/ADMRufu/main/Repositorios/$VERSION_ID.list"
  [[ ! -e /etc/apt/sources.list.back ]] && cp /etc/apt/sources.list /etc/apt/sources.list.back
  wget -O /etc/apt/sources.list "$link" &>/dev/null
}
