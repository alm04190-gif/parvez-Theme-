#!/data/data/com.termux/files/usr/bin/bash
set -e

# কালার কোডসমূহ
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
RESET='\033[0m'

clear

# মেইন ব্যানার (স্পষ্ট ParveZ ফন্ট এবং মাল্টি-কালার)
echo -e "${RED}    ____                           ____${RESET}"
echo -e "${YELLOW}   / __ \\____ _________  ___  ____/_  /${RESET}"
echo -e "${GREEN}  / /_/ / __ \`/ ___/ | / / _ \\/_  // / ${RESET}"
echo -e "${CYAN} / ____/ /_/ / /   | |/ /  __/ / // /__${RESET}"
echo -e "${BLUE}/_/    \\__,_/_/    |___/\\___/ /___/___/${RESET}"

# "Powered by All in One" টাইপিং অ্যানিমেশন (নতুন কালার)
TEXT="                          Powered by All in One"
for (( i=0; i<${#TEXT}; i++ )); do
    echo -ne "${YELLOW}${TEXT:$i:1}${RESET}"
    sleep 0.02
done
echo -e "\n"

echo -e "${GREEN}A sleek Termux theme with a smart prompt,"
echo -e "syntax highlighting, and a dynamic animated"
echo -e "banner that changes every session.${RESET}\n"

# ইউজারের কাছ থেকে নাম ইনপুট নেওয়া (ফিক্সড: এখন আর স্কিপ করবে না)
echo -e "${CYAN}[?] Enter your name for the terminal prompt & banner:${RESET}"
read -rp "❯ " INPUT_NAME < /dev/tty
NAME="${INPUT_NAME:-User}"

rm -rf $PREFIX/etc/motd

# নতুন ওয়েটিং মেসেজ
echo -e "${YELLOW}[*] Please wait some moments... setting up everything.${RESET}"

# প্যাকেজ আপডেট এবং অটোমেটিক ডিপেন্ডেন্সি ইনস্টল (সম্পূর্ণ সাইলেন্ট)
pkg update -y -q > /dev/null 2>&1
DEPS=(git tte fish eza bat starship)

for p in "${DEPS[@]}"; do
  if ! command -v "$p" >/dev/null 2>&1; then
    pkg install -y -q "$p" > /dev/null 2>&1
  fi
done

TMPDIR="${TMPDIR:-/tmp}"
DIR="$TMPDIR/ParvezTheme"
rm -rf "$DIR"

# রিপোজিটরি ক্লোন (কোনো কিছু লেখা উঠবে না)
git clone -q https://github.com/alm04190-gif/parvez-Theme- "$DIR" > /dev/null 2>&1

ASSETS="$DIR/assets"

if [ "$(basename "$SHELL")" != "fish" ]; then
  chsh -s fish > /dev/null 2>&1
fi

mkdir -p ~/.config/fish ~/.config ~/.termux

cp "$ASSETS/config.fish" ~/.config/fish/config.fish
cp "$ASSETS/font.ttf" ~/.termux/font.ttf
cp "$ASSETS/colors.properties" ~/.termux/colors.properties

# ইনপুট দেওয়া নামটা থিমে সেট করা হচ্ছে
sed "s/user-name/$NAME/g" "$ASSETS/starship.toml" > ~/.config/starship.toml
sed "s/user-name/$NAME/g" "$ASSETS/motd" > ~/.config/morphshell

echo -e "${GREEN}[✓] Hey ${NAME}, Theme installed successfully! Just reset your Termux.${RESET}"
