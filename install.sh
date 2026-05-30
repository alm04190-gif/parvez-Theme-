#!/data/data/com.termux/files/usr/bin/bash

# ===== Colors =====
SKY_BLUE='\033[38;5;117m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

clear

# ===== Banner =====
echo -e "${SKY_BLUE}    ____                           ____"
echo -e "   / __ \\____ _________  ___  ____/_  /"
echo -e "  / /_/ / __ \`/ ___/ | / / _ \\/_  // / "
echo -e " / ____/ /_/ / /   | |/ /  __/ / // /__"
echo -e "/_/    \\__,_/_/    |___/\\___/ /___/___/${RESET}"

# ===== Animated Text =====
TEXT="                          Powered by All in One"

for (( i=0; i<${#TEXT}; i++ )); do
    echo -ne "${CYAN}${TEXT:$i:1}${RESET}"
    sleep 0.01
done

echo -e "\n"

# ===== Description =====
echo -e "${WHITE}A sleek Termux theme with a smart prompt,"
echo -e "syntax highlighting, and a dynamic animated"
echo -e "banner that changes every session.${RESET}\n"

# ===== User Name =====
echo -e "${WHITE}[?] Enter your name for the terminal prompt & banner:${RESET}"
read -rp "❯ " INPUT_NAME < /dev/tty

NAME="${INPUT_NAME:-User}"

# ===== Remove MOTD =====
rm -rf $PREFIX/etc/motd

# ===== Loading =====
echo -e "\n${WHITE}[*] Please wait... setting up everything.${RESET}"

# ===== Update Packages =====
pkg update -y && pkg upgrade -y

# ===== Install tur-repo =====
if ! command -v tur-repo >/dev/null 2>&1; then
    pkg install tur-repo -y
fi

# ===== Required Packages =====
DEPS=(git fish eza bat starship rust)

for p in "${DEPS[@]}"; do
    if ! command -v "$p" >/dev/null 2>&1; then
        echo -e "${CYAN}[*] Installing ${p}...${RESET}"
        pkg install -y "$p"
    fi
done

# ===== Cargo PATH =====
mkdir -p ~/.config/fish

if ! grep -q ".cargo/bin" ~/.config/fish/config.fish 2>/dev/null; then
    echo 'set -Ux PATH $HOME/.cargo/bin $PATH' >> ~/.config/fish/config.fish
fi

export PATH="$HOME/.cargo/bin:$PATH"

# ===== Install TTE =====
if ! command -v tte >/dev/null 2>&1; then
    echo -e "${CYAN}[*] Installing tte...${RESET}"
    cargo install tte
fi

# ===== Temp Directory =====
TMPDIR="${TMPDIR:-/tmp}"
DIR="$TMPDIR/ParvezTheme"

rm -rf "$DIR"

# ===== Clone Repo =====
echo -e "${CYAN}[*] Downloading theme files...${RESET}"

git clone https://github.com/alm04190-gif/parvez-Theme- "$DIR" || {
    echo -e "\n${RED}[!] Failed to clone repository.${RESET}"
    exit 1
}

ASSETS="$DIR/assets"

# ===== Set Fish Shell =====
if [ "$(basename "$SHELL")" != "fish" ]; then
    chsh -s fish || true
fi

# ===== Create Config Directories =====
mkdir -p ~/.config/fish
mkdir -p ~/.config
mkdir -p ~/.termux

# ===== Copy Assets =====
cp "$ASSETS/config.fish" ~/.config/fish/config.fish
cp "$ASSETS/font.ttf" ~/.termux/font.ttf
cp "$ASSETS/colors.properties" ~/.termux/colors.properties

# ===== Generate Config Files =====
sed "s/user-name/$NAME/g" "$ASSETS/starship.toml" > ~/.config/starship.toml

sed "s/user-name/$NAME/g" "$ASSETS/motd" > ~/.config/morphshell

# ===== Reload Termux Settings =====
termux-reload-settings >/dev/null 2>&1 || true

# ===== Telegram =====
echo -e "\n${WHITE}${BOLD}Join Our Community ---> \e]8;;https://t.me/all_in_one_63\at.me/all_in_one_63\e]8;;\a${RESET}\n"

# ===== Success =====
echo -e "${GREEN}[✓] Hey ${NAME}, Theme installed successfully!${RESET}"

echo -e "${WHITE}[*] Restarting Termux Session...${RESET}"

read -rp "Press [ENTER] to continue" DUMMY < /dev/tty

# ===== Restart Shell =====
exec fish
