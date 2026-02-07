#!/bin/bash

# Uconsole-i3 Installation Script
# This script automates the installation of i3 and configuration for Raspberry Pi OS Trixie

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Note: This script needs sudo privileges for package installation${NC}"
fi

echo -e "${GREEN}=== Uconsole-i3 Installation Script ===${NC}\n"

OS_CODENAME=$(lsb_release -cs 2>/dev/null || echo "unknown")
echo -e "${YELLOW}Detected OS: ${OS_CODENAME}${NC}"

echo -e "${YELLOW}[1/6] Installing dependencies...${NC}"
sudo apt update

sudo apt install -y i3-wm i3blocks i3status rofi fonts-font-awesome \
    maim xclip copyq xdotool feh pamixer picom numlockx \
    x11-xserver-utils x11-xkb-utils \
    bluez wireguard-tools moc

echo -e "${GREEN}✓ Dependencies installed${NC}\n"

echo -e "${YELLOW}[2/6] Configuring desktop session for i3...${NC}"

DESKTOP_CONF="/etc/xdg/lxsession/LXDE-pi/desktop.conf"
AUTOSTART_FILE="/etc/xdg/lxsession/LXDE-pi/autostart"

if [ -f "$DESKTOP_CONF" ]; then
    echo -e "${YELLOW}Updating $DESKTOP_CONF${NC}"
    sudo sed -i 's/window_manager=.*/window_manager=i3/' "$DESKTOP_CONF" || {
        echo "[Session]" | sudo tee -a "$DESKTOP_CONF" > /dev/null
        echo "window_manager=i3" | sudo tee -a "$DESKTOP_CONF" > /dev/null
    }
    echo -e "${GREEN}✓ Desktop configuration updated${NC}"
elif [ -f "/etc/xdg/lxsession/rpd-x/desktop.conf" ]; then
    echo -e "${YELLOW}Updating Raspberry Pi desktop configuration${NC}"
    DESKTOP_CONF="/etc/xdg/lxsession/rpd-x/desktop.conf"
    sudo sed -i 's/window_manager=.*/window_manager=i3/' "$DESKTOP_CONF" || {
        echo "[Session]" | sudo tee -a "$DESKTOP_CONF" > /dev/null
        echo "window_manager=i3" | sudo tee -a "$DESKTOP_CONF" > /dev/null
    }
    echo -e "${GREEN}✓ Desktop configuration updated${NC}"
else
    echo -e "${RED}Warning: Desktop configuration not found. Skipping...${NC}"
fi

if [ -f "$AUTOSTART_FILE" ]; then
    echo -e "${YELLOW}Updating $AUTOSTART_FILE${NC}"
    sudo sed -i 's/^@lxpanel-pi/#@lxpanel-pi/' "$AUTOSTART_FILE" 2>/dev/null || true
    sudo sed -i 's/^@pcmanfm-pi/#@pcmanfm-pi/' "$AUTOSTART_FILE" 2>/dev/null || true
    echo -e "${GREEN}✓ Autostart configuration updated${NC}"
elif [ -f "/etc/xdg/lxsession/rpd-x/autostart" ]; then
    echo -e "${YELLOW}Updating Raspberry Pi autostart configuration${NC}"
    AUTOSTART_FILE="/etc/xdg/lxsession/rpd-x/autostart"
    sudo sed -i 's/^@lxpanel-pi/#@lxpanel-pi/' "$AUTOSTART_FILE" 2>/dev/null || true
    sudo sed -i 's/^@pcmanfm-pi/#@pcmanfm-pi/' "$AUTOSTART_FILE" 2>/dev/null || true
    echo -e "${GREEN}✓ Autostart configuration updated${NC}"
else
    echo -e "${RED}Warning: Autostart file not found. Skipping...${NC}"
fi

echo -e "${YELLOW}[3/6] Installing Suckless Terminal (st)...${NC}"
ST_DIR="$HOME/Documents/st"
if [ -d "$ST_DIR" ]; then
    echo -e "${YELLOW}st directory exists. Updating...${NC}"
    cd "$ST_DIR"
    git pull || true
    sudo make clean install 2>/dev/null || sudo make install
else
    cd ~/Documents
    if [ -d "st" ]; then
        cd st
        git pull || true
        sudo make clean install 2>/dev/null || sudo make install
    else
        git clone https://github.com/LukeSmithxyz/st
        cd st
        sudo make install
    fi
fi
echo -e "${GREEN}✓ Suckless Terminal installed${NC}\n"

echo -e "${YELLOW}[4/6] Setting up i3 configuration...${NC}"
I3_CONFIG_DIR="$HOME/.config/i3"
mkdir -p "$I3_CONFIG_DIR"
mkdir -p "$I3_CONFIG_DIR/wallp"
mkdir -p "$HOME/Pictures"

echo -e "${GREEN}✓ Configuration directories created${NC}\n"

echo -e "${YELLOW}[5/6] Copying configuration files...${NC}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -f "$SCRIPT_DIR/config" ]; then
    cp "$SCRIPT_DIR/config" "$I3_CONFIG_DIR/"
    echo -e "${GREEN}✓ Config file copied${NC}"
else
    echo -e "${RED}Error: config file not found in $SCRIPT_DIR${NC}"
    exit 1
fi

if [ -f "$SCRIPT_DIR/i3blocks.conf" ]; then
    cp "$SCRIPT_DIR/i3blocks.conf" "$I3_CONFIG_DIR/"
    echo -e "${GREEN}✓ i3blocks.conf copied${NC}"
fi

if [ -d "$SCRIPT_DIR/scripts" ]; then
    mkdir -p "$I3_CONFIG_DIR/scripts"
    cp "$SCRIPT_DIR/scripts"/* "$I3_CONFIG_DIR/scripts/" 2>/dev/null || true
    chmod +x "$I3_CONFIG_DIR/scripts"/* 2>/dev/null || true
    echo -e "${GREEN}✓ Scripts copied${NC}"
fi

if [ -d "$SCRIPT_DIR/wallp" ]; then
    cp -r "$SCRIPT_DIR/wallp"/* "$I3_CONFIG_DIR/wallp/" 2>/dev/null || true
    echo -e "${GREEN}✓ Wallpapers copied${NC}"
fi

echo -e "${GREEN}✓ Configuration files copied${NC}\n"

echo -e "${YELLOW}[6/6] Final checks and recommendations...${NC}"

if [ ! -d "$HOME/Pictures" ]; then
    mkdir -p "$HOME/Pictures"
    echo -e "${GREEN}✓ Created Pictures directory for screenshots${NC}"
fi

echo -e "\n${GREEN}=== Installation Complete! ===${NC}\n"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Log out and log back in, or restart your system"
echo -e "2. i3 will start automatically"
echo -e "3. If prompted, press Enter to accept the default key binding"
echo -e "4. Press \$mod + d to open the application launcher (rofi)"
echo -e "\n${YELLOW}Configuration location:${NC} $I3_CONFIG_DIR"
echo -e "${YELLOW}To reload config after changes:${NC} \$mod + Shift + c"
echo -e "\n${GREEN}Enjoy your i3 experience!${NC}\n"