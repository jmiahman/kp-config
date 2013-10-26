# kickstart file for Korora (KDE)
#
# KP:DESCRIPTION:START
#
# var KP_RELEASE_META_LABEL=kde
#
#
# KP:DESCRIPTION:END
#

%include %%KP_KICKSTART_DIR%%/minibase.ks

#
# PACKAGES
#

%packages

#test Firefox install

firefox

# make sure mariadb lands instead of MySQL (hopefully a temporary hack)
#mariadb-embedded
#mariadb-libs
#mariadb-server

# FIXME; apparently the glibc maintainers dislike this
nss-mdns

# (RE)BRANDING
korora-backgrounds-kde
kcm-gtk
oxygen-gtk

#
# EXTRA PACKAGES
#add-remove-extras
#akmods
alsa-utils
alsa-plugins-pulseaudio
apper
bash-completion
beesu
bluedevil
btrfs-progs
chrony
dolphin-root-actions
dragon
expect
font-manager
fprintd-pam
#frei0r-plugins
fuse
gparted
htop
jack-audio-connection-kit
java-1.7.0-openjdk
juk
kdeartwork
kde-plasma-daisy
kde-plasma-yawp
kde-settings
kde-settings-pulseaudio
kde-settings-ksplash
kde-workspace-ksplash-themes
kde-settings-plasma
kdemultimedia-extras-freeworld
kde-plasma-networkmanagement-mobile
kde-plasma-networkmanagement-openconnect
kde-plasma-networkmanagement-openvpn
kde-plasma-networkmanagement-pptp
kde-plasma-networkmanagement-vpnc
kdm
konversation
korora-settings-kde
kmix
libdvdcss
libdvdnav
libdvdread
libimobiledevice
liveusb-creator
mlocate
p7zip
p7zip-plugins
PackageKit-browser-plugin
PackageKit-command-not-found
plasma-applet-showdesktop
policycoreutils-gui
polkit-desktop-policy
prelink
pybluez
rawtherapee
screen
vim
xorg-x11-apps
xorg-x11-resutils
xsettings-kde
yumex
yum-plugin-priorities
yum-plugin-refresh-updatesd
yum-plugin-versionlock
yum-updatesd

#
# MULTIMEDIA
# Note: KDE will use Xine by default, but also support Gstreamer

faac
flac
gstreamer-ffmpeg
gstreamer-plugins-bad
gstreamer-plugins-bad-free
#gstreamer-plugins-bad-free-extras
gstreamer-plugins-bad-nonfree
gstreamer-plugins-good
gstreamer-plugins-ugly
kio-ftps
kio_mtp
lame
libmpg123
PackageKit-gstreamer-plugin
pavucontrol


# VLC  Maybe some day
#phonon-backend-vlc
#vlc
#vlc-extras

vorbis-tools

# No Xine for now
#xine-lib-extras
#xine-lib-extras-freeworld
#xine-plugin
#xine-lib-extras
#xine-lib-extras-freeworld


#
# development tools for out of tree modules
#gcc
#kernel-devel
#dkms
time

# Packages to be Removed
-gcc*
-ntp
-abrt*
-gnome-packagekit*
-desktop-backgrounds-basic
-kdegames
-synaptic
-system-config-printer
-kdepim*
-cups*
-kde-print-manager
-kde-print-manager-libs
-system-config-printer-*
-xscreensaver*
-kdeartwork-wallpapers 
-*sane-*
-digikam*
-freetype-infinality-devel
-freetype-devel
-*kipi*
-fluid-soundfont-lite-patches
-korora-videos
-cjkuni-uming-fonts
-libpinyin-data
-libkkc-data
-skkdic
-rawtherapee
-wqy-zenhei-fonts
-nhn-nanum-gothic-fonts
-hplip
-hpijs
-foomatic-db-ppds
-gutenprint
-gcc-c++

%end

%post

echo -e "\n*****\nPOST SECTION\n*****\n"

# KP - build out of kernel modules (so it's not done on first boot)
echo -e "\n***\nBUILDING AKMODS\n***"
/usr/sbin/akmods --force

# KP - import keys
echo -e "\n***\nIMPORTING KEYS\n***"
for x in fedora google-chrome virtualbox korora adobe rpmfusion-free-fedora-19-primary rpmfusion-nonfree-fedora-19-primary korora-19-primary korora-19-secondary rpmfusion-free-fedora-18-primary rpmfusion-nonfree-fedora-18-primary korora-18-primary
do
  KEY="/etc/pki/rpm-gpg/RPM-GPG-KEY-${x}"
  if [ -r "${KEY}" ];
  then
    rpm --import "${KEY}"
  else
    echo "IMPORT KEY NOT FOUND: $KEY (${x})"
  fi
done

#KDE - stop Klipper from starting
#sed -i 's/AutoStart:true/AutoStart:false/g' /usr/share/autostart/klipper.desktop

# KP - start yum-updatesd
systemctl enable yum-updatesd.service

# KP - update locate database
/usr/bin/updatedb

# KP - let's run prelink (makes things faster)
echo -e "***\nPRELINKING\n****"
/usr/sbin/prelink -av -mR -q

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDE"
EOF

# make oxygen-gtk the default GTK+ theme for root (see #683855, #689070, #808062)
cat > /root/.gtkrc-2.0 << EOF
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
include "/etc/gtk-2.0/gtkrc"
gtk-theme-name="oxygen-gtk"
EOF
mkdir -p /root/.config/gtk-3.0
cat > /root/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name = oxygen-gtk
EOF

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF
# KP - ensure liveuser desktop exists
mkdir ~liveuser/Desktop

if [ -e /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png ] ; then
    # use image also for kdm
    mkdir -p /usr/share/apps/kdm/faces
    cp /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png /usr/share/apps/kdm/faces/fedora.face.icon
fi

# make liveuser use KDE
echo "startkde" > /home/liveuser/.xsession
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# Shouldn't be needed now, fixed upstream by setting hostname on boot
## KP - run xhost + to ensure anaconda can start in live session
#cat >> /home/liveuser/.bashrc <<FOE
##!/bin/bash
#if [ -n "$(env |grep DISPLAY)" ]
#then
#  xhost +
#fi
#FOE

# set up autologin for user liveuser
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/kde/kdm/kdmrc

# set up user liveuser as default user and preselected user
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/kde/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=liveuser/' /etc/kde/kdm/kdmrc

# add liveinst.desktop to favorites menu
mkdir -p /home/liveuser/.kde/share/config/
cat > /home/liveuser/.kde/share/config/kickoffrc << MENU_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/apper.desktop,/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/firefox.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/konsole.desktop,/usr/share/applications/liveinst.desktop
MENU_EOF

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
#sed -i 's/Icon=liveinst/Icon=\/usr\/share\/icons\/Fedora\/scalable\/apps\/anaconda.svg/g' /usr/share/applications/liveinst.desktop

# chmod +x ~/Desktop/liveinst.desktop to disable KDE's security warning
chmod +x /usr/share/applications/liveinst.desktop

# copy over the icons for liveinst to hicolor
cp /usr/share/icons/gnome/16x16/apps/system-software-install.png /usr/share/icons/hicolor/16x16/apps/
cp /usr/share/icons/gnome/22x22/apps/system-software-install.png /usr/share/icons/hicolor/22x22/apps/
cp /usr/share/icons/gnome/24x24/apps/system-software-install.png /usr/share/icons/hicolor/24x24/apps/
cp /usr/share/icons/gnome/32x32/apps/system-software-install.png /usr/share/icons/hicolor/32x32/apps/
cp /usr/share/icons/gnome/48x48/apps/system-software-install.png /usr/share/icons/hicolor/48x48/apps/
cp /usr/share/icons/gnome/256x256/apps/system-software-install.png /usr/share/icons/hicolor/256x256/apps/
touch /usr/share/icons/hicolor/

# Set akonadi backend
mkdir -p /home/liveuser/.config/akonadi
cat > /home/liveuser/.config/akonadi/akonadiserverrc << AKONADI_EOF
[%General]
Driver=QSQLITE3
AKONADI_EOF

# Disable the update notifications of apper 
cat > /home/liveuser/.kde/share/config/apper << APPER_EOF
[CheckUpdate]
autoUpdate=0
distroUpgrade=0
interval=0
APPER_EOF

# Disable (apper's) plasma-applet-updater (#948099)
mkdir -p /home/liveuser/.kde/share/kde4/services/
sed -e "s|^X-KDE-PluginInfo-EnabledByDefault=true|X-KDE-PluginInfo-EnabledByDefault=false|g" \
   /usr/share/kde4/services/plasma-applet-updater.desktop > \
   /home/liveuser/.kde/share/kde4/services/plasma-applet-updater.desktop

# Disable some kded modules
# apperd: http://bugzilla.redhat.com/948099
cat > /home/liveuser/.kde/share/config/kdedrc << KDEDRC_EOF
[Module-apperd]
autoload=false
KDEDRC_EOF

# Disable kres-migrator
cat > /home/liveuser/.kde/share/config/kres-migratorrc << KRES_EOF
[Migration]
Enabled=false
KRES_EOF

# Disable nepomuk
cat > /home/liveuser/.kde/share/config/nepomukserverrc << NEPOMUK_EOF
[Basic Settings]
Start Nepomuk=false

[Service-nepomukfileindexer]
autostart=false
NEPOMUK_EOF

# KP - don't use prelink on a running KDE live image
mv /usr/sbin/prelink /usr/sbin/prelink-disabled
rm /etc/cron.daily/prelink

# KP - un-mute sound card (fixes some issues reported)
amixer set Master 85% unmute 2>/dev/null
amixer set PCM 85% unmute 2>/dev/null
pactl set-sink-mute 0 0
pactl set-sink-volume 0 50000


# KP - disable screensaver
mkdir -p /home/liveuser/.kde/share/config
cat > /home/liveuser/.kde/share/config/kscreensaverrc << SCREEN_EOF
[ScreenSaver]
Enabled=false
Lock=false
LockGrace=60000
PlasmaEnabled=false
Timeout=60
SCREEN_EOF

# KP - disable screen lock
cat > /home/liveuser/.kde/share/config/powerdevilrc << LOCK_EOF
[General]
configLockScreen=false
LOCK_EOF


# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

# small hack to enable plasma-netbook workspace on boot
if strstr "\`cat /proc/cmdline\`" netbook ; then
   mv /usr/share/autostart/plasma-desktop.desktop /usr/share/autostart/plasma-netbook.desktop
   sed -i 's/desktop/netbook/g' /usr/share/autostart/plasma-netbook.desktop
fi

# KP - disable yumupdatesd
systemctl stop yum-updatesd.service

# KP - disable jockey from autostarting
rm /etc/xdg/autostart/jockey*

# turn off PackageKit-command-not-found
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

# Turn on liveinst file
sed -i s/NoDisplay=true/NoDisplay=false/g /usr/local/share/applications/liveinst.desktop
EOF

%end
