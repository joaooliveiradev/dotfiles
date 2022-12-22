#!/bin/bash

#Update distro 
function update_distro() {
  sudo apt-get update && sudo apt-get upgrade -y
}

function install_essential_apt_packages() {
  #Essential packages from distro
  apt_packages = "curl git build-essential"
  #Update distro and install
  update_distro && sudo apt-get install ${apt_packages}
}

function install_alacritty() {
  #Install some essential apt packages
  install_essential_apt_packages
  #Alacritty dependencies list
  allacrity_dependencies = "cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3"
  #Install allacrity dependencies
  sudo apt-get install ${allacrity_dependencies}
  #Configure Rust up in Ubuntu 22.04
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  #Clone alacritty from the source and install
  configPath = "~/.config/alacritty"
  git clone https://github.com/jwilm/alacritty.git
}







