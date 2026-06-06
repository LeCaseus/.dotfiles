# A Comprehensive Linux Setup Guide

This is a personal document with the purpose of guiding the installation process of my exact linux setup on different machines. This also assumes that a **Minimal Installation** was selected from the **Fedora Everything** ISO, which boots into a TTY upon installation.

> **NOTE:** I have yet to make a simple install script for just the dotfiles so to anyone else reading this, stay tuned, but skip ahead to the dotfiles section for now.

[Desktop Screenshot](dotassets/3.png)

---

## 1. Base System Prep

Welcome to the TTY! If you cannot run the succeeding commands, it means the wifi driver was probably not installed or something else went wrong entirely. Go back to the ISO and reinstall the distro.

### Updating the system

First things first, make sure to update the system to receive the latest versions that Fedora is shipping because the ISO installer may or may not have an outdated shipment.

```bash
sudo dnf upgrade --refresh -y
```

### Installing the essential repositories

| Repo       | Purpose                                                                                                             | Command                                                                                                                                                                                                                  |
| ---------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| RPM Fusion | Required for NVIDIA and generally a good option to enable generally for other stuff Fedora doesn't ship by default. | `sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y` |
| Terra repo | Needed by Noctalia-shell for the latest updates. (I believe I tried the native dnf but the package was outdated)    | `sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y`                                                                                                      |
| Niri COPR  | Niri Compositor obviously                                                                                           | `sudo dnf copr enable yalter/niri -y`                                                                                                                                                                                    |

---

## 2. The Skeleton Crew

This section contains the core compositor stack to get the desktop up and running. Think of it as the skeleton of the system if you will, before everything else is fleshed out.

```bash
sudo dnf install niri noctalia xdg-desktop-portal-gnome lxpolkit wl-clipboard cliphist akmod-nvidia xorg-x11-drv-nvidia-cuda prime-run greetd xwayland-satellite foot fish helix -y
```

**NOTES:**

- You COULD choose another portal and polkit but `xdg-desktop-portal-gnome` gives the best Niri compatibility (and gives an easier time wiring up) for file pickers, screen sharing, and app permissions, while `lxpolkit` is just a minimal fallback since noctalia also has a polkit agent plugin that I use.
- I also only need `prime-run` so that Minecraft detects the dGPU instead of the iGPU. Skip it otherwise.
- Noctalia, being the desktop shell, does most of the heavy lifting. This is fine unless picking another stack.
- XWayland satellite only for X11 compatibilty to Wayland but I prefer to avoid X11 applications. I will also avoid theming QT and will mainly use GTK apps but do whatever.
- Niri installs dependencies by default such as agreety and fuzzel, which we will uninstall manually after the first clone/configuration with the dotfiles or just leave it be.

### Set fish as the default shell

```bash
chsh -s $(which fish)
```

Reboot for it to take effect. As such, all subsequent commands from here assumes fish is used unless noted otherwise. I will also use `hx` primarily for file editing but `nano` is still always an option and alacritty which is niri's default until my dotfiles.

---

## 3. My App Stack

This section will include the rest of the programs and applications that are essential to my workflow and are frequently used.

### System & CLI Tools

```fish
sudo dnf install fastfetch btop cava yazi ncdu duf imv chafa ffmpeg gpu-screen-recorder mpv rsync rclone prettier nwg-look yt-dlp -y
# marksman binary (preferred over DNF):
curl -L -o ~/.local/bin/marksman https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-x64
chmod +x ~/.local/bin/marksman
# or mdpls for built-in markdown web rendering
cargo install --git https://github.com/euclio/mdpls
# Download the latest .rpm from the SubTUI releases page first, then:
sudo rpm -i ~/Downloads/SubTUI_*_linux_amd64.rpm
```

Here is a quick overview what each application does:

| Tool                         | Purpose                                                                       |
| ---------------------------- | ----------------------------------------------------------------------------- |
| fastfetch                    | displays and flex system information                                          |
| btop                         | displays system processes                                                     |
| cava                         | cross-platform audio visualizer                                               |
| yazi                         | main lightweight file manager                                                 |
| ncdu                         | acts like windirstat and analyzes which directories are taking the most space |
| duf                          | analyze system storage as a whole                                             |
| imv                          | minimal and lightweight image viewer                                          |
| chafa                        | used for converting images into ASCII art for fastfetch                       |
| ffmpeg & gpu-screen-recorder | my alternative for OBS although ffmpeg is also used for other things          |
| mpv                          | media viewer alternative to VLC. I picked this because subTUI depends on it.  |
| subtui                       | TUI based music player for my navidrome server                                |
| rsync & rclone               | local and cloud syncing options                                               |
| marksman/mdpls/prettier      | LSP and formatter for markdown editing in helix                               |
| nwg-look                     | GUI for editing GTK themes. skip if you prefer the terminal                   |
| yt-dlp                       | download music and videos from YouTube                                        |

### Graphics & Creative Applications

```fish
sudo dnf install gimp inkscape krita blender -y
```

> Blender doubles as a video editor here. I tried DaVinci Resolve but ran into too many complications getting it working on Linux, so Blender it is for now.

### Browser & Gaming Applications

```fish
flatpak install flathub com.valvesoftware.Steam com.github.Vencord.Vesktop io.github.zen_browser.zen org.qbittorrent.qBittorrent -y
sudo dnf install lutris wine gamescope mangohud -y
sudo tar -xzf OpenJDK25U-jdk_x64_linux_hotspot_25.0.3_9.tar.gz -C /usr/lib/jvm
sudo alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-25.0.3+9/bin/java 1
sudo alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-25.0.3+9/bin/javac 1
sudo alternatives --config java   # select JDK 25
```

> I installed JDK manually via tarball instead of DNF to have full control over the version. This is mainly for SKLauncher (Minecraft).

**Vesktop/Discord rich presence fix:**

```fish
flatpak override --user --filesystem=xdg-run/app/com.discordapp.Discord com.github.Vencord.Vesktop
```

### WhatsApp (built from source)

There's no official Linux client so I built this one from source. It's a bit of a process but it works fine:

```fish
git clone https://github.com/mimbrero/whatsapp-desktop-linux.git
cd whatsapp-desktop-linux
sudo dnf install npm -y
npm install
npm run build
```

Then I created a `.desktop` entry at `~/.local/share/applications/whatsapp.desktop` pointing to the built binary so it shows up in the Noctalia launcher.

---

## 4. Dotfiles

This is where most of the heavy lifting happens. Almost everything visual and behavioral is already baked in so once this is done the setup basically configures itself. I use a bare git repo approach:

```fish
git clone --bare <your-dotfiles-repo-url> ~/.dotfiles
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots checkout
dots config --local status.showUntrackedFiles no
```

The dotfiles cover Niri, Noctalia, fish, starship, foot, fastfetch, helix, yazi, wireplumber, and a few scripts in `.local/bin`. After checkout, most things should just work without touching anything manually.

> If checkout throws conflicts, it just means some default config files are already sitting in those paths. Back them up or delete them and run checkout again.

---

## 5. Cursor Setup (Silksong)

The Silksong cursor is a custom set built from `.ani` files and symlinked manually. It's backed up in the dotfiles under `.local/share/icons/Silksong/` so if the dotfiles are cloned correctly this should already be there. This section is mostly just in case I need to rebuild it from scratch.

```bash
mkdir -p ~/.local/share/icons/Silksong/cursors
hx ~/.local/share/icons/Silksong/index.theme
```

`index.theme`:

```ini
[Icon Theme]
Name=Silksong
Comment=Silksong cursor theme
```

Then symlink all the cursor names into the `cursors/` directory:

```bash
cd ~/.local/share/icons/Silksong/cursors
ln -s "Hornet normal" default
ln -s "Hornet normal" left_ptr
ln -s "Hornet normal" arrow
ln -s "Hornet link" pointer
ln -s "Hornet link" hand1
ln -s "Hornet link" hand2
ln -s "Hornet text" text
ln -s "Hornet text" xterm
ln -s "Hornet text" ibeam
ln -s "Hornet move" move
ln -s "Hornet move" fleur
ln -s "Hornet move" all-scroll
ln -s "Hornet busy" watch
ln -s "Hornet busy" wait
ln -s "Hornet work" progress
ln -s "Hornet work" left_ptr_watch
ln -s "Hornet unavailable" not-allowed
ln -s "Hornet unavailable" no-drop
ln -s "Hornet unavailable" forbidden
ln -s "Hornet help" help
ln -s "Hornet help" question_arrow
ln -s "Hornet precision" crosshair
ln -s "Hornet precision" cross
ln -s "Hornet horz" ew-resize
ln -s "Hornet horz" col-resize
ln -s "Hornet horz" sb_h_double_arrow
ln -s "Hornet vert" ns-resize
ln -s "Hornet vert" row-resize
ln -s "Hornet vert" sb_v_double_arrow
ln -s "Hornet dgn1" nwse-resize
ln -s "Hornet dgn1" nw-resize
ln -s "Hornet dgn1" se-resize
ln -s "Hornet dgn2" nesw-resize
ln -s "Hornet dgn2" ne-resize
ln -s "Hornet dgn2" sw-resize
ln -s "Hornet alt" context-menu
ln -s "Hornet location" cell
ln -s "Hornet person" pointing_hand
```

Apply it:

```bash
gsettings set org.gnome.desktop.interface cursor-theme "Silksong"
gsettings set org.gnome.desktop.interface cursor-size 24
```

---

## 6. Theming

Most of this is already handled by the dotfiles. This section covers the stuff that still needs to be done manually through GUI tools or gsettings.

### GTK

Open `nwg-look` and set the theme to **Graphite dark rimless** and icons to **Papirus Dark**.

```fish
nwg-look
```

### Noctalia Color Scheme

Open Noctalia settings → Color Scheme Creator plugin → load the custom Sith palette. It's personal so I can't really describe it beyond that — but it's in the dotfiles config if backed up correctly.

### Font Config

I needed a few extra font packages for proper emoji and symbol rendering. The `fonts.conf` itself is in the dotfiles under `~/.config/fontconfig/`:

```fish
sudo dnf install twitter-twemoji-fonts google-noto-sans-symbols2-fonts google-noto-sans-math-fonts gdouros-symbola-fonts -y
```

### Greeter

Configure `/etc/greetd/config.toml` for autologin via `initial_session`:

```toml
[terminal]
vt = 1

[default_session]
command = "agreety --cmd fish"

[initial_session]
command = "env VK_ICD_FILES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json niri-session"
user = "yourusername"
```

> The env variables I set to prevent niri from using my NVIDIA dGPU because I noticed it was running a process at 2MiB via `nvidia-smi` which was a bit annoying.

---

## 7. System Tweaks

### GRUB Kernel Parameters

Added these to `GRUB_CMDLINE_LINUX` in `/etc/default/grub` mostly for gaming performance and to stop some stutters I was getting:

```bash
amd_pstate=active split_lock_detect=off pcie_aspm.policy=performance usbcore.autosuspend=-1 nowatchdog nmi_watchdog=0
```

Rebuild after editing:

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

| Parameter                      | Effect                                                              |
| ------------------------------ | ------------------------------------------------------------------- |
| `amd_pstate=active`            | AMD P-State driver via CPPC instead of legacy acpi-cpufreq          |
| `split_lock_detect=off`        | Prevents stutters/crashes in games and anti-cheat under Proton/Wine |
| `pcie_aspm.policy=performance` | Disables PCIe link power saving, reduces latency spikes             |
| `usbcore.autosuspend=-1`       | Disables USB auto-suspend, prevents peripheral wake lag             |
| `nowatchdog nmi_watchdog=0`    | Disables hardware watchdog timers, removes periodic CPU overhead    |

**Revert:** remove the parameters and rebuild.

### Quiet Boot

```bash
sudo grubby --update-kernel=ALL --args="quiet loglevel=3"
```

Just stops the boot messages flooding the screen. Logs are still there via `journalctl` if something breaks.

**Revert:** `sudo grubby --update-kernel=ALL --remove-args="quiet loglevel=3"`

### GRUB Timeout

Set `GRUB_TIMEOUT=0` in `/etc/default/grub` then rebuild. Boots straight to the default entry. If I ever need the GRUB menu I just hold **Shift** or spam **Esc** right after BIOS handoff.

**Revert:** Set `GRUB_TIMEOUT=5` and rebuild.

### Disabled Services

These were adding unnecessary time to startup. Disabling them shaved a few seconds off:

```bash
sudo systemctl disable dnf-makecache.timer
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl disable abrtd.service
sudo systemctl disable ModemManager.service
```

| Service                              | Reason                                                         |
| ------------------------------------ | -------------------------------------------------------------- |
| `dnf-makecache.timer`                | DNF metadata refresh on boot — unnecessary at startup          |
| `NetworkManager-wait-online.service` | Waits for full network before proceeding — unneeded on desktop |
| `abrtd.service`                      | ABRT crash reporter                                            |
| `ModemManager.service`               | Mobile broadband manager — no modem present                    |

### Boot Time (after all of this)

```
firmware:   ~7s    (BIOS/UEFI — not reducible without BIOS tuning)
loader:     ~6.6s  (GRUB — reduced from 8.7s after timeout change)
kernel:     ~944ms
initrd:     ~6.5s  (dracut + hardware enumeration — expected)
userspace:  ~4.2s  (healthy)
─────────────────
total:      ~26s
```

The firmware and initrd times are basically hardware-bound so I left those alone.

---

## 8. NVIDIA Power Management

This enables RTD3 (PCIe Runtime D3) power management for the RTX 3050 so the dGPU can suspend when it's not doing anything.

> Worth noting: Niri holds `/dev/nvidia0` open during a session so the dGPU will still show as `active` while logged in regardless. These configs still matter for workload-level power gating though.

### udev rule

```bash
sudo tee /etc/udev/rules.d/80-nvidia-pm.rules << 'EOF'
SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
EOF
```

### Kernel module options

```bash
echo 'options nvidia NVreg_DynamicPowerManagement=0x02' | sudo tee /etc/modprobe.d/nvidia-power.conf
echo 'options nvidia_drm modeset=1 fbdev=1' | sudo tee /etc/modprobe.d/nvidia-drm-modeset.conf
echo -e 'nvidia\nnvidia_modeset\nnvidia_uvm\nnvidia_drm' | sudo tee /etc/modules-load.d/nvidia.conf
sudo dracut --force
```

| Option                              | Effect                                         |
| ----------------------------------- | ---------------------------------------------- |
| `NVreg_DynamicPowerManagement=0x02` | Fine-grained power gating between workloads    |
| `modeset=1 fbdev=1`                 | DRM kernel mode setting — required for Wayland |

**Revert:** Remove files in `/etc/udev/rules.d/`, `/etc/modprobe.d/`, and `/etc/modules-load.d/`, then rebuild dracut.

Reference: [NVIDIA RTD3 documentation](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/dynamicpowermanagement.html)

---

## 9. Audio

PipeWire + WirePlumber handles audio. Fedora minimal should pull this in as a dependency so no extra install needed there.

### Switching mic input (internal → headphone mic)

The mic doesn't auto-switch when plugging in headphones so I have to do it manually. First, list all available sources and their ports:

```bash
pactl list sources
```

Then switch the active port:

```bash
pactl set-source-port <source-name> <port-name>
```

On my machine specifically:

```bash
pactl set-source-port alsa_input.pci-0000_05_00.6.analog-stereo analog-input-headset-mic
```

To make it persistent there's a WirePlumber config in `~/.config/wireplumber/wireplumber.conf.d/` — already in the dotfiles. If something breaks after a change:

```bash
systemctl --user restart pipewire wireplumber
```

---

## 10. Cloud & Music Stack

### rclone (OneDrive)

I use OneDrive mainly for iPhone photo backup and shared family folders. I don't sync everything — active files stay local. rclone mounts it on demand:

```fish
rclone config   # interactive setup, add OneDrive as a remote
rclone mount onedrive: ~/OneDrive --daemon
```

### Navidrome (self-hosted music server)

> This whole music server setup is temporary. Once I get a NAS, this moves there.

Config lives at `/etc/navidrome/navidrome.toml` — point `MusicFolder` at the local music library and enable the service:

```fish
sudo systemctl enable --now navidrome
```

Accessible at `http://localhost:4533`. I use SubTUI as the TUI client for playback.

---

## 11. Media & Downloads

### yt-dlp

Already installed in section 3. Quick reference for the commands I actually use:

**Audio (music, best quality m4a):**

```fish
yt-dlp -x --audio-format m4a --audio-quality 0 --embed-metadata --embed-thumbnail <URL>
```

Works with YouTube Music playlists too. For age-restricted content, pass browser cookies:

```fish
yt-dlp --cookies-from-browser firefox -x --audio-format m4a --audio-quality 0 --embed-metadata --embed-thumbnail <URL>
```

**Video (up to 4K):**

```fish
yt-dlp -f "bestvideo[height<=2160]+bestaudio" <URL>
```

---

## 12. Known Issues

### niri-session Deprecation Warning

`niri-session` calls `systemctl --user import-environment` without a variable list which throws a systemd deprecation warning on login and shutdown. It's harmless. Tracked upstream at [niri#254](https://github.com/niri-wm/niri/issues/254) — leaving it as-is until there's a fix.

### setfont: ERROR kdfontop.c:212 put_font_kdfontop: Unable to load such font with such kernel version

Shows up in the TTY on newer kernels. It's a kernel-side issue, not something I caused. Since I boot straight into a Wayland session it doesn't actually affect anything — just alarming the first time you see it.
