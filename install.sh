#!/data/data/com.termux/files/usr/bin/bash
set -e

# নতুন স্টাইলিশ কালার কোড
SKY_BLUE='\033[38;5;117m'
PURPLE='\033[38;5;135m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear

# মেইন ব্যানার (লাইন বাই লাইন অ্যানিমেশনের জন্য ভেরিয়েবল)
BANNER="${SKY_BLUE}
 ██████╗  █████╗ ██████╗ ██╗   ██╗███████╗███████╗
 ██╔══██╗██╔══██╗██╔══██╗██║   ██║██╔════╝╚══███╔╝
 ██████╔╝███████║██████╔╝██║   ██║█████╗    ███╔╝ 
 ██╔═══╝ ██╔══██║██╔══██╗╚██╗ ██╔╝██╔══╝   ███╔╝  
 ██║     ██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗
 ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝${RESET}"

# ব্যানার স্লাইডিং অ্যানিমেশন
while IFS= read -r line; do
    echo -e "$line"
    sleep 0.05
done <<< "$BANNER"

# "Powered by All in One" টাইপিং অ্যানিমেশন
TEXT="                          Powered by All in One"
for (( i=0; i<${#TEXT}; i++ )); do
    echo -ne "${PURPLE}${TEXT:$i:1}${RESET}"
    sleep 0.03
done
echo -e "\n"

echo -e "${GREEN}
A sleek Termux theme with a smart prompt,
syntax highlighting, and a dynamic animated
banner that changes every session.
${RESET}"

# ইউজারের কাছ থেকে নাম ইনপুট নেওয়া (ডিফল্ট নাম User রাখা হলো)
echo -e "${YELLOW}[?] Enter your name for the terminal banner:${RESET}"
read -rp "❯ " INPUT_NAME
NAME="${INPUT_NAME:-User}"

rm -rf $PREFIX/etc/motd

echo -e "${CYAN}[*] Updating packages and installing dependencies silently...${RESET}"
pkg update -y -q
DEPS=(git tte fish eza bat starship)

# ডিপেন্ডেন্সিগুলো কোনো আউটপুট ছাড়াই সাইলেন্টলি ইন্সটল হবে
for p in "${DEPS[@]}"; do
  if ! command -v "$p" >/dev/null 2>&1; then
    pkg install -y -q "$p"
  fi
done

TMPDIR="${TMPDIR:-/tmp}"
DIR="$TMPDIR/ParvezTheme"
rm -rf "$DIR"

# গিটহাব রিপোজিটরি সাইলেন্টলি ক্লোন হচ্ছে (ইউজার কিছুই দেখতে পাবে না)
git clone -q https://github.com/alm04190-gif/parvez-Theme- "$DIR"

ASSETS="$DIR/assets"

if [ "$(basename "$SHELL")" != "fish" ]; then
  chsh -s fish
fi

mkdir -p ~/.config/fish ~/.config ~/.termux

cp "$ASSETS/config.fish" ~/.config/fish/config.fish
cp "$ASSETS/font.ttf" ~/.termux/font.ttf
cp "$ASSETS/colors.properties" ~/.termux/colors.properties

sed "s/user-name/$NAME/g" "$ASSETS/starship.toml" > ~/.config/starship.toml
sed "s/user-name/$NAME/g" "$ASSETS/motd" > ~/.config/morphshell

echo -e "${GREEN}[✓] Hey ${NAME}, Theme installed successfully! Just reset your Termux.${RESET}"
