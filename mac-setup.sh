#!/bin/bash
set -e

#install xcode | required for brew and fish and things
xcode-select --install

#install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

#set admin accounts to use sudo without password
sed -i '' '/^# %admin/s/^# //' /etc/sudoers
sed -i '' '/^%admin/s/ALL$/NOPASSWD: &/' /etc/sudoers

#install cli programs
brew install \
    git \
    wireguard-tools \
    mas \
    fastfetch \
    thefuck \
    neovim

#install cask apps
brew install --cask \
    appcleaner \
    protonmail-bridge \
    protonvpn \
    proton-drive \
    visual-studio-code \
    github\
    discord

#install app store apps
mas install 1451685025 #wireguard
mas install 1440147259 #adguard for safari
mas install 1498497896 #raivo receiver
mas install 1464122853 #nextDNS

#sideserver
curl -L -o SideServer.dmg https://github.com/SideStore/SideServer-macOS/releases/latest/download/SideServer.dmg
hdiutil attach SideServer.dmg -nobrowse -quiet
cp -R /Volumes/SideServer\ */SideServer.app /Applications/
hdiutil detach /Volumes/SideServer\ */ -quiet
rm SideServer.dmg

#configure shell env
bash -c 'echo $(which fish) >> /etc/shells'
chsh -s $(which fish) $user
fish -c "echo 'set -gx PATH /opt/homebrew/bin \$PATH' >> ~/.config/fish/config.fish"
fish -c "echo -e "function fish_greeting\n    fastfetch\nend" >> ~/.config/fish/config.fish"
fish -c "echo 'thefuck --alias | source' >> ~/.config/fish/config.fish"
sed -i '/^# require_confirmation = True/s/^# //' ~/.config/thefuck/settings.py