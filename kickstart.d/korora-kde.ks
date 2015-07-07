%include fedora-live-kde.ks
%include korora-base.ks

services --enabled=kdm --disabled=sddm

#
# PACKAGES
#

%packages

-NetworkManager*-gnome
-desktop-backgrounds-basic
-f22-backgrounds-kde
-f22-kde-theme
-kdegames
-synaptic
-system-config-printer
@firefox
@kde-apps
@kde-desktop
@kde-telepathy
@libreoffice
HandBrake-gui
adwaita-gtk3-theme
amarok
apper
backintime-kde
bluedevil
calibre
choqok
darktable
digikam
dolphin-root-actions
font-manager
hugin-base
k3b-extras-freeworld
kalarm
kamoso
kaudiocreator
kde-l10n-*
kde-plasma-daisy
kde-plasma-nm*
kde-plasma-yawp
kde-print-manager
kde-settings
kde-settings-ksplash
kde-settings-plasma
kde-settings-pulseaudio
kde-workspace-ksplash-themes
kdeartwork
kdeartwork-wallpapers
kdebase-workspace-ksplash-themes
kdegames-minimal
kdemultimedia-extras-freeworld
kdenlive
kdeplasma-addons
kdiff3
kdm
kid3
kio-ftps
kio_mtp
kipi-plugins
kjots
konversation
korora-settings-kde
krdc
krename
krusader
ktimetracker
ktorrent
libmpg123
libreoffice-kde
linphone
mariadb-embedded
mariadb-libs
mariadb-server
okular
phonon-backend-vlc
python3-PyQt4
qt-recordmydesktop
qtcurve-gtk2
qtcurve-kde4
skanlite
system-config-users
xine-lib-extras
xine-lib-extras-freeworld
yakuake

%end

%post

echo -e "\n*****\nPOST SECTION\n*****\n"

#this is fixed now 21-2
# work around KDE bug
#mkdir -p /etc/skel/.kde/share/config
#cat > /etc/skel/.kde/share/config/kwalletrc << \EOF
#[Wallet]
#Launch Manager[$d]
#EOF

systemctl enable kdm.service

# KP - build out of kernel modules (so it's not done on first boot)
#echo -e "\n***\nBUILDING AKMODS\n***"
#/usr/sbin/akmods --force

#KDE - stop Klipper from starting
#sed -i 's/AutoStart:true/AutoStart:false/g' /usr/share/autostart/klipper.desktop

# KP - start yum-updatesd
systemctl enable yum-updatesd.service

# KP - update locate database
/usr/bin/updatedb

# KP - let's run prelink (makes things faster)
echo -e "***\nPRELINKING\n****"
/usr/sbin/prelink -av -mR -q

EOF

%end