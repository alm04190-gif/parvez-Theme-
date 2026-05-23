#!/data/data/com.termux/files/usr/bin/bash

# কালার কোডসমূহ
SKY_BLUE='\033[38;5;117m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

clear

# মেইন ব্যানার
echo -e "${SKY_BLUE}    ____                           ____"
echo -e "   / __ \\____ _________  ___  ____/_  /"
echo -e "  / /_/ / __ \`/ ___/ | / / _ \\/_  // / "
echo -e " / ____/ /_/ / /   | |/ /  __/ / // /__"
echo -e "/_/    \\__,_/_/    |___/\\___/ /___/___/${RESET}"

# "Powered by All in One" টাইপিং অ্যানিমেশন
TEXT="                          Powered by All in One"
for (( i=0; i<${#TEXT}; i++ )); do
    echo -ne "${CYAN}${TEXT:$i:1}${RESET}"
    sleep 0.01
done
echo -e "\n"

# বাকি সবকিছু সাদা (White) কালারে হবে
echo -e "${WHITE}A sleek Termux theme with a smart prompt,"
echo -e "syntax highlighting, and a dynamic animated"
echo -e "banner that changes every session.${RESET}\n"

# ইউজারের কাছ থেকে নাম ইনপুট নেওয়া
echo -e "${WHITE}[?] Enter your name for the terminal prompt & banner:${RESET}"
read -rp "❯ " INPUT_NAME < /dev/tty
NAME="${INPUT_NAME:-User}"

rm -rf $PREFIX/etc/motd

# ওয়েটিং মেসেজ
echo -e "${WHITE}[*] Please wait some moments... setting up everything.${RESET}"

# ফিক্স: tte প্যাকেজ পাওয়ার জন্য প্রথমে tur-repo ইন্সটল করা হচ্ছে
pkg update -y || true
if ! command -v tur-repo >/dev/null 2>&1; then
  pkg install tur-repo -y || true
fi

# এবার বাকি সব ডিপেন্ডেন্সি অটোমেটিক ইন্সটল হবে
DEPS=(git tte fish eza bat starship)

for p in "${DEPS[@]}"; do
  if ! command -v "$p" >/dev/null 2>&1; then
    pkg install -y "$p" || true
  fi
done

TMPDIR="${TMPDIR:-/tmp}"
DIR="$TMPDIR/ParvezTheme"
rm -rf "$DIR"

# গিটহাব থেকে ক্লোন 
git clone https://github.com/alm04190-gif/parvez-Theme- "$DIR" || { echo -e "\n${WHITE}[!] Error: Check your internet connection.${RESET}"; exit 1; }

ASSETS="$DIR/assets"

if [ "$(basename "$SHELL")" != "fish" ]; then
  chsh -s fish || true
fi

mkdir -p ~/.config/fish ~/.config ~/.termux

cp "$ASSETS/config.fish" ~/.config/fish/config.fish
cp "$ASSETS/font.ttf" ~/.termux/font.ttf
cp "$ASSETS/colors.properties" ~/.termux/colors.properties

sed "s/user-name/$NAME/g" "$ASSETS/starship.toml" > ~/.config/starship.toml
sed "s/user-name/$NAME/g" "$ASSETS/motd" > ~/.config/morphshell

# টেলিগ্রাম কমিউনিটিতে জয়েন করার অপশন
echo -e "\n${WHITE}${BOLD}Join Our Community ---> \e]8;;https://t.me/all_in_one_63\aClick Here\e]8;;\a${RESET}\n"

# সাকসেস মেসেজ এবং টার্মাক্স রিসেট কমান্ড
echo -e "${WHITE}[✓] Hey ${NAME}, Theme installed successfully!${RESET}"
echo -e "${WHITE}[*] Reset your Termux...${RESET}"
read -rp "Press [ENTER] to restart Termux" DUMMY < /dev/tty

# টার্মাক্স রিস্টার্ট
exec login
