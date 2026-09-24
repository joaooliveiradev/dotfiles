#!/usr/bin/env bash
set -e

dotfilesPath="$(cd "$(dirname "$0")" && pwd)/zorin"

# Links target -> source, backing up real files/dirs that are in the way
link() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        mv "$target" "$target.bak.$(date +%s)"
    fi

    ln -s "$source" "$target"
    echo "  $target -> $source"
}

# -------------------- MAIN FUNCTION --------------------
main() {
    if [[ "$1" == "clean" ]]; then
        clearAllLinks
        exit 0
    fi

    echo "Adding zorin symbolic links"

    link "$dotfilesPath/ghostty" ~/.config/ghostty
    link "$dotfilesPath/zsh/.zshrc" ~/.zshrc
    link "$dotfilesPath/mise/config.toml" ~/.config/mise/config.toml
    link "$dotfilesPath/zed" ~/.config/zed
    link "$dotfilesPath/devilspie2" ~/.config/devilspie2
    link "$dotfilesPath/autostart/devilspie2.desktop" ~/.config/autostart/devilspie2.desktop
    link "$dotfilesPath/vscode/settings.json" ~/.config/Code/User/settings.json
    link "$dotfilesPath/vscode/keybidings.json" ~/.config/Code/User/keybindings.json

    # Claude: only link versioned items; runtime data (credentials, sessions, history) stays in ~/.claude
    if [ -L ~/.claude ]; then
        rm ~/.claude
    fi
    mkdir -p ~/.claude
    for item in settings.json CLAUDE.md skills hooks agents commands statusline-command.sh; do
        [ -e "$dotfilesPath/.claude/$item" ] && link "$dotfilesPath/.claude/$item" ~/.claude/"$item"
    done
}

# -------------------- CLEAN FUNCTION --------------------
clearAllLinks() {
    echo "Removing created symlinks..."

    for target in ~/.config/ghostty ~/.zshrc ~/.config/mise/config.toml ~/.config/zed \
        ~/.config/devilspie2 ~/.config/autostart/devilspie2.desktop \
        ~/.config/Code/User/settings.json ~/.config/Code/User/keybindings.json \
        ~/.claude/{settings.json,CLAUDE.md,skills,hooks,agents,commands,statusline-command.sh}; do
        [ -L "$target" ] && rm "$target"
    done
    return 0
}

main "$@"
