#!/usr/bin/env bash
set -e

# -------------------- MAIN FUNCTION --------------------
main(){
selectedProfile="$1"
dotfilesPath="$PWD"

if [[ "$selectedProfile" == "clean" ]]; then
    clearAllLinks
    exit 0
fi

if [[ "$selectedProfile" != "manjaro" ]] && [[ "$selectedProfile" != "zorin" ]]; then
    echo "Invalid profile"
    echo "Use: ./install.sh <manjaro|zorin>"
    exit 1
fi

echo "You selected $selectedProfile"

# -------------------- SHARED PACKAGES --------------------
rm -rf ~/.config/alacritty
ln -s "$dotfilesPath/shared/alacritty" ~/.config/alacritty

rm -rf ~/.zshrc
ln -s "$dotfilesPath/shared/zsh/.zshrc" ~/.zshrc

# -------------------- MANJARO PACKAGES --------------------

if [[ "$selectedProfile" == "manjaro" ]]; then
    echo "Adding manjaro symbolic links"

    rm -rf ~/.config/rofi
    ln -s "$dotfilesPath/profiles/manjaro/rofi" ~/.config/rofi

    rm -rf ~/.config/i3
    ln -s "$dotfilesPath/profiles/manjaro/i3" ~/.config/i3

    rm -rf ~/.config/polybar
    ln -s "$dotfilesPath/profiles/manjaro/polybar" ~/.config/polybar

    rm -rf ~/.config/picom
    ln -s "$dotfilesPath/profiles/manjaro/picom" ~/.config/picom

    rm -rf ~/.config/Code/User/settings.json
    ln -s "$dotfilesPath/profiles/manjaro/vscode/settings.json" ~/.config/Code/User/settings.json

    rm -rf ~/.config/wallpapers
    ln -s "$dotfilesPath/shared/wallpapers" ~/.config/wallpapers
fi

# -------------------- ZORIN PACKAGES --------------------

if [[ "$selectedProfile" == "zorin" ]]; then
    echo "Adding zorin symbolic links"

    rm -rf ~/.config/zed
    ln -s "$dotfilesPath/profiles/zorin/zed" ~/.config/zed
fi
}


# -------------------- CLEAN FUNCTION --------------------
clearAllLinks() {
    echo "Removing created symlinks..."

    rm -rf ~/.config/alacritty
    rm -rf ~/.zshrc

    rm -rf ~/.config/rofi
    rm -rf ~/.config/i3
    rm -rf ~/.config/polybar
    rm -rf ~/.config/picom
    rm -rf ~/.config/Code/User/settings.json

    rm -rf ~/.config/zed
}

# Execute main function first
main "$@"
