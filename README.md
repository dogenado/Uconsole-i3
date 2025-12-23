# Uconsole-i3
i3 window manager configuration for Uconsole device 

![SCREENSHOT|300](./screen.png)
![SCREENSHOT2|300](./screen2.png)

## Usage
Feel free to fork and modify this configuration to suit your needs. If you're new to i3 like I am, take your time to understand how each section works and tailor it to your preferences.

The base template is coming from [icemodding](https://github.com/icemodding/i3). This is my first attempt at working with i3, so please be aware that this project may have bugs, be unfinished, or contain incomplete features.
Enjoy your i3 experience!


## Quick Installation

For automatic installation, use the provided script:
```bash
git clone git@github.com:dzaczek/Uconsole-i3.git
cd Uconsole-i3
chmod +x install.sh
./install.sh
```

## Manual Installation 

This configuration uses I3-GAPS [https://github.com/Airblader/i3](https://github.com/Airblader/i3)

### Installation i3 gaps:
```bash
sudo apt install dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev meson ninja-build

 cd ~/Documents
 # clone the repository
 git clone https://www.github.com/Airblader/i3 i3-gaps
 cd i3-gaps

 # compile
 mkdir -p build && cd build
 meson ..
 sudo ninja
```

### Configure LXDE for i3
Open `/etc/xdg/lxsession/LXDE-pi/desktop.conf` and change window_manager to i3:
```ini
[Session]
window_manager=i3
```

Open file `/etc/xdg/lxsession/LXDE-pi/autostart` and comment out lines lxpanel and pcmanfm:
```bash
sudo vim /etc/xdg/lxsession/LXDE-pi/autostart
```
```ini
#@lxpanel --profile LXDE-pi
#@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash
```
### Configure and install SuckLess Terminal
```bash
cd ~/Documents
git clone https://github.com/LukeSmithxyz/st
# OR FROM THERE git://git.suckless.org/st
cd st
sudo make install
```

### Copy this configuration
```bash
cd ~/.config/i3/
git clone git@github.com:dzaczek/Uconsole-i3.git .
sudo apt install maim xclip copyq xdotool feh pamixer picom rofi
```

### Additional Dependencies
```bash
sudo apt install maim xclip copyq xdotool feh pamixer picom rofi i3blocks i3status fonts-font-awesome
```

## Keyboard Shortcuts

**Note:** `$mod` is set to `Alt` (Mod1) in this configuration.

### Basic Operations
| Shortcut | Action |
|----------|--------|
| `$mod + Enter` | Open terminal (st) |
| `$mod + d` | Open application launcher (rofi) |
| `$mod + Shift + q` | Close focused window |
| `$mod + Shift + c` | Reload i3 configuration |
| `$mod + Shift + r` | Restart i3 |
| `$mod + Shift + e` | Exit i3 (with confirmation) |

### Window Focus & Movement
| Shortcut | Action |
|----------|--------|
| `$mod + j/k/l/;` | Focus left/down/up/right (vim-style) |
| `$mod + Arrow Keys` | Focus in direction |
| `$mod + Shift + j/k/l/;` | Move window left/down/up/right |
| `$mod + Shift + Arrow Keys` | Move window in direction |
| `$mod + a` | Focus parent container |
| `$mod + space` | Toggle focus between tiling/floating windows |

### Window Layout
| Shortcut | Action |
|----------|--------|
| `$mod + h` | Split horizontally |
| `$mod + v` | Split vertically |
| `$mod + s` | Stacking layout |
| `$mod + w` | Tabbed layout |
| `$mod + e` | Toggle split layout |
| `$mod + f` | Toggle fullscreen |
| `$mod + Shift + Space` | Toggle floating/tiling |
| `$mod + r` | Enter resize mode (then use j/k/l/; or arrows) |

### Floating Windows (Uconsole-specific)
| Shortcut | Action |
|----------|--------|
| `$mod + Shift + p` | Move window to right position (695x267px) |
| `$mod + Shift + m` | Move window to left position (695x267px) |

### Workspaces
| Shortcut | Action |
|----------|--------|
| `$mod + 1-9,0` | Switch to workspace 1-10 |
| `$mod + Shift + 1-9,0` | Move window to workspace 1-9,10 |
| `$mod + Home` | Switch to workspace 1 |
| `$mod + End` | Switch to workspace 10 |
| `$mod + Page Up` | Switch to previous workspace |
| `$mod + Page Down` | Switch to next workspace |

### Workspace Assignments
- Workspace 1: Terminal
- Workspace 2: Browser (Chrome/Firefox)
- Workspace 3: Telegram
- Workspace 4: Media player
- Workspace 5: Video player (VLC)
- Workspace 6: File manager (Thunar/VirtualBox)
- Workspace 7: Graphics (GIMP)
- Workspace 8: Downloads (qBittorrent)
- Workspace 9: Games
- Workspace 10: Recording (Simplescreenrecorder)

### Screenshots
#### Save to Files
| Shortcut | Action |
|----------|--------|
| `Print` | Screenshot entire screen → `~/Pictures/screenshot-*.png` |
| `$mod + Print` | Screenshot active window → `~/Pictures/screenshot-*-current.png` |
| `Shift + Print` | Screenshot selected area → `~/Pictures/screenshot-*-selected.png` |

#### Copy to Clipboard
| Shortcut | Action |
|----------|--------|
| `Ctrl + Print` | Screenshot entire screen → clipboard |
| `Ctrl + $mod + Print` | Screenshot active window → clipboard |
| `Ctrl + Shift + Print` | Screenshot selected area → clipboard |

### Audio Controls
| Shortcut | Action |
|----------|--------|
| `XF86AudioRaiseVolume` | Increase volume (+5%) |
| `XF86AudioLowerVolume` | Decrease volume (-5%) |
| `XF86AudioMute` | Toggle mute |
| `$mod + m` | Open MOC player in terminal |
| `XF86AudioPlay` | Play/Pause (MOC) |
| `XF86AudioPause` | Play/Pause (MOC) |
| `XF86AudioNext` | Next track (MOC) |
| `XF86AudioPrev` | Previous track (MOC) |
| `XF86AudioStop` | Stop (MOC) |

### Resize Mode
After pressing `$mod + r`, use:
| Shortcut | Action |
|----------|--------|
| `j / Left` | Shrink width |
| `k / Down` | Grow height |
| `l / Up` | Shrink height |
| `; / Right` | Grow width |
| `Enter / Escape` | Exit resize mode |

## Features

- **i3-gaps**: Window gaps for modern look
- **Rofi**: Application launcher
- **Suckless Terminal (st)**: Minimal terminal emulator
- **i3blocks**: Status bar with custom scripts
- **MOC**: Music player integration
- **Screenshot tools**: maim with file/clipboard support
- **Picom**: Compositor for transparency and effects
- **WireGuard VPN**: Status indicator in bar
- **Raspberry Pi monitoring**: Battery and temperature scripts
