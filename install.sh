#!/bin/bash

# Uconsole-i3 Installation Script
# This script automates the installation of i3-gaps and configuration

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root for package installation
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Note: This script needs sudo privileges for package installation${NC}"
fi

echo -e "${GREEN}=== Uconsole-i3 Installation Script ===${NC}\n"

# Step 1: Install dependencies
echo -e "${YELLOW}[1/7] Installing dependencies...${NC}"
sudo apt update
sudo apt install -y dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev \
    libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev \
    libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev \
    libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev \
    libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 \
    libxcb-shape0-dev meson ninja-build i3blocks i3status rofi \
    fonts-font-awesome maim xclip copyq xdotool feh pamixer picom \
    numlockx libx11-dev libxft-dev libxext-dev

echo -e "${GREEN}✓ Dependencies installed${NC}\n"

# Step 2: Clone and build i3-gaps
echo -e "${YELLOW}[2/7] Building i3-gaps...${NC}"
BUILD_DIR="$HOME/Documents/i3-gaps"
if [ -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}Directory $BUILD_DIR exists. Updating...${NC}"
    cd "$BUILD_DIR"
    git pull || true
else
    mkdir -p ~/Documents
    cd ~/Documents
    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps
fi

cd "$BUILD_DIR"
mkdir -p build && cd build
if [ -f "build.ninja" ]; then
    echo -e "${YELLOW}Previous build found. Rebuilding...${NC}"
    sudo ninja
else
    meson ..
    sudo ninja install
fi

echo -e "${GREEN}✓ i3-gaps built and installed${NC}\n"

# Step 3: Configure LXDE autostart
echo -e "${YELLOW}[3/7] Configuring LXDE autostart...${NC}"
DESKTOP_CONF="/etc/xdg/lxsession/LXDE-pi/desktop.conf"
AUTOSTART_FILE="/etc/xdg/lxsession/LXDE-pi/autostart"

if [ -f "$DESKTOP_CONF" ]; then
    echo -e "${YELLOW}Updating $DESKTOP_CONF${NC}"
    sudo sed -i 's/window_manager=.*/window_manager=i3/' "$DESKTOP_CONF" || {
        echo "[Session]" | sudo tee -a "$DESKTOP_CONF" > /dev/null
        echo "window_manager=i3" | sudo tee -a "$DESKTOP_CONF" > /dev/null
    }
    echo -e "${GREEN}✓ Desktop configuration updated${NC}"
else
    echo -e "${RED}Warning: $DESKTOP_CONF not found. Skipping...${NC}"
fi

if [ -f "$AUTOSTART_FILE" ]; then
    echo -e "${YELLOW}Updating $AUTOSTART_FILE${NC}"
    # Comment out lxpanel and pcmanfm if not already commented
    sudo sed -i 's/^@lxpanel/#@lxpanel/' "$AUTOSTART_FILE" 2>/dev/null || true
    sudo sed -i 's/^@pcmanfm/#@pcmanfm/' "$AUTOSTART_FILE" 2>/dev/null || true
    echo -e "${GREEN}✓ Autostart configuration updated${NC}"
else
    echo -e "${RED}Warning: $AUTOSTART_FILE not found. Skipping...${NC}"
fi

# Step 4: Install Suckless Terminal (st)
echo -e "${YELLOW}[4/7] Installing Suckless Terminal...${NC}"
ST_DIR="$HOME/Documents/st"
if [ -d "$ST_DIR" ]; then
    echo -e "${YELLOW}st directory exists. Updating...${NC}"
    cd "$ST_DIR"
    git pull || true
    sudo make clean install
else
    cd ~/Documents
    if [ -d "st" ]; then
        cd st
        git pull || true
        sudo make clean install
    else
        git clone https://github.com/LukeSmithxyz/st
        cd st
        sudo make install
    fi
fi
echo -e "${GREEN}✓ Suckless Terminal installed${NC}\n"

# Step 5: Create i3 config directory
echo -e "${YELLOW}[5/7] Setting up i3 configuration...${NC}"
I3_CONFIG_DIR="$HOME/.config/i3"
mkdir -p "$I3_CONFIG_DIR"
mkdir -p "$I3_CONFIG_DIR/wallp"
mkdir -p "$HOME/Pictures"  # For screenshots

echo -e "${GREEN}✓ Configuration directories created${NC}\n"

# Step 6: Copy configuration files
echo -e "${YELLOW}[6/7] Copying configuration files...${NC}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy main config file
if [ -f "$SCRIPT_DIR/config" ]; then
    cp "$SCRIPT_DIR/config" "$I3_CONFIG_DIR/"
    echo -e "${GREEN}✓ Config file copied${NC}"
else
    echo -e "${RED}Error: config file not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Copy i3blocks config
if [ -f "$SCRIPT_DIR/i3blocks.conf" ]; then
    cp "$SCRIPT_DIR/i3blocks.conf" "$I3_CONFIG_DIR/"
    echo -e "${GREEN}✓ i3blocks.conf copied${NC}"
fi

# Copy scripts
if [ -d "$SCRIPT_DIR/scripts" ]; then
    mkdir -p "$I3_CONFIG_DIR/scripts"
    cp "$SCRIPT_DIR/scripts"/* "$I3_CONFIG_DIR/scripts/" 2>/dev/null || true
    chmod +x "$I3_CONFIG_DIR/scripts"/* 2>/dev/null || true
    echo -e "${GREEN}✓ Scripts copied${NC}"
fi

# Copy wallpapers
if [ -d "$SCRIPT_DIR/wallp" ]; then
    cp -r "$SCRIPT_DIR/wallp"/* "$I3_CONFIG_DIR/wallp/" 2>/dev/null || true
    echo -e "${GREEN}✓ Wallpapers copied${NC}"
fi

echo -e "${GREEN}✓ Configuration files copied${NC}\n"

# Step 7: Final checks and recommendations
echo -e "${YELLOW}[7/7] Finalizing installation...${NC}"

# Check if Pictures directory exists for screenshots
if [ ! -d "$HOME/Pictures" ]; then
    mkdir -p "$HOME/Pictures"
    echo -e "${GREEN}✓ Created Pictures directory for screenshots${NC}"
fi

echo -e "\n${GREEN}=== Installation Complete! ===${NC}\n"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Log out and log back in, or restart your system"
echo -e "2. i3 will start automatically"
echo -e "3. If prompted, press Enter to accept the default key binding"
echo -e "4. Press $mod + d to open the application launcher (rofi)"
echo -e "\n${YELLOW}Configuration location:${NC} $I3_CONFIG_DIR"
echo -e "${YELLOW}To reload config after changes:${NC} $mod + Shift + c"
echo -e "\n${GREEN}Enjoy your i3 experience!${NC}\n"

