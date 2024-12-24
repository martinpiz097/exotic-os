#!/bin/sh
sed -i 's/ParallelDownloads.*/ParallelDownloads = 100/' /etc/pacman.conf
sed -i 's/#MAKEFLAGS.*/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf

sudo pacman -Rs dolphin || true
sudo pacman -Rs firefox || true

# mejorar calidad de audio

#sudo pacman -S pro-audio
sudo pacman -S $(< package_lists/pacman_packages.txt)

sudo pacman -S --needed base-devel git
git config --global core.editor "micro"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version

# cambiar compilacion paralela y nativa en yay

yay -S $(< package_lists/aur_packages.txt)

sudo pacman -Rs nautilus-open-any-terminal || true

# falta graalvm

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo systemctl start docker
sudo systemctl enable docker
docker run hello-world

systemctl --user enable gcr-ssh-agent.service
systemctl --user enable gcr-ssh-agent.socket

systemctl --user start gcr-ssh-agent.service
systemctl --user start gcr-ssh-agent.socket
