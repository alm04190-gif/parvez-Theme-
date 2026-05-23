#!/data/data/com.termux/files/usr/bin/bash
set -e

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

clear
echo -e "${CYAN}
  ____                          _____ 
 |  _ \\ __ _ _ ____   _____ ____|_  /
 | |_) / _\` | '__\\ \\ / / _ \\_  / / / 
 |  __/ (_| | |   \\ V /  __// / / /_ 
 |_|   \\__,_|_|    \\_/ \\___/___/____|
                                     
                          Powered by All in One
${RESET}"

echo -e "${GREEN}
A sleek Termux theme with a smart prompt,
syntax highlighting, and a dynamic animated
banner that changes every session.
${RESET}"

# আগের motd রিমুভ করা হচ্ছে
rm -rf $PREFIX/etc/motd

echo -e "${CYAN}[*] Updating packages and checking dependencies...${RESET}"
# প্যাকেজ আপডেট এবং অটোমেটিক ডিপেন্ডেন্সি ইনস্টল
pkg update -y -q
DEPS=(git tte fish eza bat starship)

for p in "${DEPS[@]}"; do
  if ! command -v "$p" >/dev/null 2>&1; then
    echo -e "${GREEN}[+] Installing $p${RESET}"
    pkg install -y "$p"
  fi
done

TMPDIR="${TMPDIR:-/tmp}"
DIR="$TMPDIR/ParvezTheme"
rm -rf "$DIR"

echo -e "${CYAN}[*] Cloning your repository...${RESET}"
# তোমার নিজের গিটহাব রিপোজিটরি ক্লোন করা হচ্ছে
git clone -q https://github.com/alm04190-gif/parvez-Theme- "$DIR"

ASSETS="$DIR/assets"

if [ "$(basename "$SHELL")" != "fish" ]; then
  echo -e "${GREEN}[*] Switching shell to fish${RESET}"
  chsh -s fish
fi

# ইউজারকে যাতে ম্যানুয়ালি নাম টাইপ করতে না হয় তাই ডিফল্ট নাম সেট করা হলো
NAME="Parvez"

mkdir -p ~/.config/fish ~/.config ~/.termux

cp "$ASSETS/config.fish" ~/.config/fish/config.fish
cp "$ASSETS/font.ttf" ~/.termux/font.ttf
cp "$ASSETS/colors.properties" ~/.termux/colors.properties

sed "s/user-name/$NAME/g" "$ASSETS/starship.toml" > ~/.config/starship.toml
sed "s/user-name/$NAME/g" "$ASSETS/motd" > ~/.config/morphshell

echo -e "${GREEN}[✓] Theme installed successfully! Just reset your Termux.${RESET}"
