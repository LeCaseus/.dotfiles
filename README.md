# dotfiles

Personal dotfiles for my Fedora 44 desktop.

---

## System Overview

| Component | Choice |
|---|---|
| OS | Fedora 44 (Custom OS) |
| Compositor | [Niri](https://github.com/YaLTeR/niri) 26.04 (YaLTeR COPR) |
| Desktop Shell | [Noctalia](https://github.com/noctalia) (bar, launcher, lockscreen, notifications, idle, clipboard, static wallpaper) |
| Greeter | greetd + tuigreet |
| Shell | fish |
| Terminal | Ghostty |
| GPU | NVIDIA + AMD iGPU |
| Display Protocol | Wayland + XWayland satellite |

---

## Software Stack

### Native (DNF)

- **Browser:** Firefox
- **Files:** Nautilus, Yazi
- **Communication:** Vesktop, Thunderbird, WhatsApp
- **Media:** PhotoQt, Feishin, linux-wallpaperengine
- **Music server:** Navidrome (running on localhost:4533)
- **Research:** Zotero, Jamovi
- **Creative:** Natron, MusicBrainz Picard
- **Dev/tools:** Helix, btop, btrfs-assistant, Arduino IDE
- **P2P:** Nicotine+
- **Archive:** Ark
- **Theme tools:** nwg-look (GTK3), qt6ct (Qt)

### Flatpak

- Steam + Gamescope + MangoHud
- Lutris
- OBS Studio
- Blender 5.0
- GIMP 3.2
- qBittorrent
- VLC
- Zoom
- Feishin
- Thunderbird
- MusicBrainz Picard
- Nicotine+
- PhotoQt
- Zotero
- Jamovi
- Arduino IDE v2
- Czkawka
- CPU-X

---

## Theming

| Layer | Tool/Setting |
|---|---|
| Color scheme | Faithful wallpaper color  (via Noctalia) |
| Icons | Fluent-green-dark (fluent-icon-theme) |
| Cursor | Silksong cursor theme |
| GTK3 | nwg-look |
| Qt | qt6ct |
| Dark mode | Noctalia + GTK settings files |

**Icon install:**
```bash
sudo dnf copr enable dusansimic/themes
sudo dnf install fluent-icon-theme
```
Set `Fluent-dark` in nwg-look (GTK) and qt6ct (Qt).

**Fonts:** Fira Code, P052, Twemoji

---

## Portals & System Integration

- `xdg-desktop-portal` + `xdg-desktop-portal-gnome` (primary — most compatible with Niri)
- Polkit kf6 + Noctalia polkit plugin
- wl-clipboard + cliphist
- mimeapps.list configured

> Architecture note: I went for a Gnome-leaning app stack on Niri compositor. Nautilus, gnome portal, and GTK apps where available since the gnome portal handles ScreenCast and file pickers. Qt apps themed independently via qt6ct.

---

## Cloud & Sync

- **OneDrive** — syncing `~/` with `skip_dotfiles` and `skip_dir` configured

---

## Boot Optimizations

These changes were made outside `~/` to reduce boot time. Documented here for reference. (or incase I forget)

### Kernel parameters — quiet boot

```bash
sudo grubby --update-kernel=ALL --args="quiet loglevel=3"
```

Stops boot messages printing to screen. Logs still accessible via `journalctl`.

**Revert:** `sudo grubby --update-kernel=ALL --remove-args="quiet loglevel=3"`

---

### Disabled services

```bash
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl disable dnf-makecache.timer
sudo systemctl disable ModemManager.service
```

| Service | Reason disabled |
|---|---|
| NetworkManager-wait-online | Blocked boot until network was fully up; network still connects in background |
| dnf-makecache.timer | DNF was refreshing package metadata cache at boot; not needed |
| ModemManager | Mobile broadband manager; no modem hardware present |

**Revert any of them:** `sudo systemctl enable <service-name>`

---

### GRUB timeout

Set `GRUB_TIMEOUT=0` in `/etc/default/grub`, then rebuilt config:

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

Boots straight to default entry. To access the GRUB menu when needed, hold **Shift** or spam **Esc** immediately after BIOS handoff.

**Revert:** Set `GRUB_TIMEOUT=5` in `/etc/default/grub` and rebuild.

---

### Boot time (post-optimization)

```
firmware:   ~7s    (BIOS/UEFI — not reducible without BIOS tuning)
loader:     ~6.6s  (GRUB — reduced from 8.7s after timeout change)
kernel:     ~944ms
initrd:     ~6.5s  (dracut + hardware enumeration — expected)
userspace:  ~4.2s  (healthy)
─────────────────
total:      ~26s
```

Firmware and initrd times are largely hardware-bound.

---

## Known Issues & Ongoing Notes

### niri-session deprecation warning

`niri-session` calls `systemctl --user import-environment` without a variable list, which triggers a systemd deprecation warning on login and shutdown. Tracked upstream at [niri#254](https://github.com/niri-wm/niri/issues/254). Harmless — left as-is pending upstream fix.

A hacky workaround exists (redirect stderr in greetd config), not applied. Waiting for a proper fix.

### Gray screen + three dots before tuigreet

Expected. The gray is Niri's compositor surface initializing as a backdrop for tuigreet. The three dots are tuigreet's loading indicator. Not a bug.

### Services noted but not yet disabled

| Service | Notes |
|---|---|
| `sshd` | In critical boot chain at ~519ms. Safe to disable if SSH into this machine isn't needed: `sudo systemctl disable sshd` |
| `avahi-daemon` | mDNS/Bonjour. Not needed on a personal desktop, safe to disable |
| `abrtd` | Fedora crash reporter. Safe to disable if not submitting bug reports |
| `firewalld` | Keep — provides firewall |

---

## Pending / Future

- [ ] Firefox "Open With" extension for Office Online
- [ ] Navidrome external access (Tailscale or Cloudflare Tunnel) for music sharing
- [ ] Greeter theming (tuigreet is functional but plain)
- [ ] Noctalia Terra repo GPG key cleanup
- [ ] Slow shutdown — not yet investigated
