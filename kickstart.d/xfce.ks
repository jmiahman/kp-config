# Kickstart file for Kororaa Remix (GNOME) x86_64
# To use this for 32bit build, :4,$s/x86_64/i386/g
# and build with 'setarch i686 livecd-creator ...'

#
# KP:DESCRIPTION:START
#
# var KP_RELEASE_META_LABEL=gnome
#
#
# KP:DESCRIPTION:END
#

%include %%KP_KICKSTART_DIR%%/base.ks


#version=DEVEL
install

#
# PACKAGES
#

%packages
@admin-tools
@base
@base-x
@british-support
@core
@dial-up
@fonts
@hardware-support
@xfce-desktop
@printing
#@office

#Install 3rd party repo releases
adobe-release
#livna-release
rpmfusion-free-release
rpmfusion-nonfree-release

#Rebranding requirements
-fedora-logos
-fedora-release
-fedora-release-notes
korora-extras
korora-release
korora-logos
korora-release-notes

egtk-gtk2-theme
egtk-gtk3-theme
elementary-icon-theme

#Package for checksumming livecd on boot, installer, memtest
anaconda
isomd5sum

#Extra packages
abiword
#alacarte
bash-completion
beesu
#control-center
cups-pdf
#evince
#evolution
#evolution-mapi
firefox
#fprintd-pam
#gconf-editor
gdm
#gimp
git
#gnome-disk-utility
#gnome-games
#gnome-packagekit-extra
#gnome-shell
gnumeric
gparted
gtk-murrine-engine
#gtk-aurora-engine
#gwibber
htop
#inkscape
#java-1.6.0-openjdk
#java-1.6.0-openjdk-plugin
#k3b
#k3b-extras-freeworld
#libobasis3.3-extension-presenter-screen
#libreoffice3-*
#libreoffice3.3-redhat-menus
#libimobiledevice
#libsane-hpaio
liveusb-creator
mozilla-adblock-plus
mozilla-flashblock
mozilla-xclear
#nautilus-actions
#nautilus-extensions
#nautilus-image-converter
#nautilus-open-terminal
#nautilus-pastebin
#nautilus-search-tool
#nautilus-sendto
#openoffice.org-pdfimport
#openoffice.org-presenter-screen
#openoffice.org-xsltfilter
p7zip
p7zip-plugins
pidgin
#pidgin-rhythmbox
polkit-desktop-policy
#samba
#samba-winbind
shotwell
simple-scan
system-config-printer
#tilda
#transmission-gtk
vim
wget
yumex
#yum-plugin-fastestmirror
yum-plugin-security
yum-updatesd

#Multimedia (KDE will use Xine by default, but also suport Gstreamer)
alsa-plugins-pulseaudio
#audacity-freeworld
-brasero
faac
ffmpeg
flac
frei0r-plugins
#gecko-mediaplayer
#deja-dup
#gnome-mplayer
#gnome-mplayer-nautilus
gstreamer-ffmpeg
gstreamer-plugins-bad
gstreamer-plugins-bad-free
gstreamer-plugins-bad-free-extras
gstreamer-plugins-bad-nonfree
gstreamer-plugins-good
gstreamer-plugins-ugly
#HandBrake-gui
lame
libdvdcss
libdvdnav
libdvdread
libmatroska
libmpg123
#me-tv (this pulls in xine-ui)
#mencoder
#Miro
#mozilla-vlc
mpg321
#nautilus-sound-converter
#openshot
PackageKit-gstreamer-plugin
#pitivi
pulseaudio-module-bluetooth
rhythmbox
#soundconverter
#transcode
vlc
vorbis-tools
x264
xine-lib-extras
xine-lib-extras-freeworld
xvidcore

#Flash deps
pulseaudio-libs.i686
alsa-plugins-pulseaudio.i686
libcurl.i686
nspluginwrapper.i686

#Development tools for out of tree modules
gcc
kernel-devel
dkms
time

#Out of kernel GPL drivers
#akmod-VirtualBox-OSE
#akmod-wl (I don't think this is GPLv2!)
#kmod-staging
%end

%post

echo -e "\n*****\nPOST SECTION\n*****\n"

#Set resolv.conf
echo "nameserver 192.168.28.1" >> /etc/resolv.conf

#Let's get a copy of the source
git clone git://kororaa.git.sourceforge.net/gitroot/kororaa/kororaa kororaa-source

#export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

#Kororaa customisations
#Set Kororaa branding
#Shouldn't be needed now that we're using our own kororaa-release and kororaa-logos RPMs.
#sed -i 's/^Generic.*/Kororaa\ Remix 14\ (Nemo)/g' /etc/fedora-release /etc/issue /etc/issue.net
#sed -i 's/generic/kororaa/g' /etc/system-release-cpe

#Shouldn't be needed now that we're using our own kororaa-release and kororaa-logos RPMs.
#for x in normalish standard wide ; do convert -fill black -draw 'color 0,0 reset' /usr/share/backgrounds/laughlin/default/$x/laughlin.png /usr/share/backgrounds/laughlin/default/$x/laughlin.png ; done
#cp kororaa-source/artwork/fedora-logo.png /usr/share/pixmaps/fedora-logo.png
#cp kororaa-source/artwork/fedora-logo-small.png /usr/share/pixmaps/fedora-logo-small.png
#cp kororaa-source/artwork/fedora-logo.png /usr/share/pixmaps/system-logo-white.png
#cp kororaa-source/artwork/fedora-logo-sprite.svg /usr/share/pixmaps/fedora-logo-sprite.svg
#cp kororaa-source/artwork/fedora-logo-sprite.svg /usr/share/pixmaps/fedora-logo-sprite.svg

#Changing backgrounds
#for x in normalish standard wide ; do composite -gravity SouthEast -geometry +50+50 /usr/share/pixmaps/fedora-logo-small.png /usr/share/backgrounds/laughlin/default/$x/laughlin.png /usr/share/backgrounds/laughlin/default/$x/laughlin.png ; done
#composite -gravity SouthEast -geometry +50+50 kororaa-source/kororaa-logos/pixmaps/kororaa-penguin-for-1280x1024.png /usr/share/backgrounds/laughlin/default/normalish/laughlin.png /usr/share/backgrounds/laughlin/default/normalish/laughlin.png ; done
#composite -gravity SouthEast -geometry +50+50 kororaa-source/kororaa-logos/pixmaps/kororaa-penguin-for-1920x1200.png /usr/share/backgrounds/laughlin/default/wide/laughlin.png /usr/share/backgrounds/laughlin/default/wide/laughlin.png ; done
#composite -gravity SouthEast -geometry +50+50 kororaa-source/kororaa-logos/pixmaps/kororaa-penguin-for-2048x1536.png /usr/share/backgrounds/laughlin/default/standard/laughlin.png /usr/share/backgrounds/laughlin/default/standard/laughlin.png ; done
#composite -gravity SouthEast -geometry +50+50 /usr/share/pixmaps/fedora-logo-small.png /usr/share/backgrounds/laughlin/default/standard/laughlin.png /usr/share/backgrounds/laughlin/default/standard/laughlin.png
#composite -gravity SouthEast -geometry +50+50 /usr/share/pixmaps/fedora-logo-small.png /usr/share/backgrounds/laughlin/default/wide/laughlin.png /usr/share/backgrounds/laughlin/default/wide/laughlin.png

#Plymouth artwork
#Shouldn't be needed now that we're using our own kororaa-release and kororaa-logos RPMs.
#for x in 06 07 08 09 10 11 12 13 14 15 ; do rm -f /usr/share/plymouth/themes/charge/throbber-$x.png ; cp kororaa-source/artwork/plymouth/throbber-$x.png /usr/share/plymouth/themes/charge/throbber-$x.png ; done

#Remove Fedora GDM theme
sudo -u gdm gconftool-2 --set --type string /apps/gdm/simple-greeter/logo_icon_name fedora-logo

#Get Elementary icons and theme
#wget http://kororaa.org/files/elementary-icons-2.5.tar.bz2
#tar -xvf elementary-icons-2.5.tar.bz2 -C /usr/share/icons/
#rm -f elementary-icons-2.5.tar.bz2
#wget http://kororaa.org/files/elementary-gtk-2.0.tar.bz2
#tar -xvf elementary-gtk-2.0.tar.bz2 -C /usr/share/themes/
#rm -f elementary-gtk-2.0.tar.bz2

#Set themes
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type string /apps/metacity/general/theme elementary
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type string /desktop/gnome/interface/gtk_theme elementary
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type string /desktop/gnome/interface/icon_theme elementary

#Remove elementary nautilus theme - doesn't work properly on vanilla nautilus.
#sed -i 's/^include\ "Apps\/nautilus.rc"/#include\ "Apps\/nautilus.rc"/g' /usr/share/themes/elementary/gtk-2.0/gtkrc

#Fix gedit's name.. this has bugged me for AGES!
sed -i 's/^X-GNOME-FullName=gedit\ Text\ Editor/X-GNOME-FullName=Text\ Editor/g' /usr/share/applications/gedit.desktop
sed -i 's/^X-GNOME-FullName[en_GB]=gedit\ Text\ Editor/X-GNOME-FullName[en_GB]=Text\ Editor/g' /usr/share/applications/gedit.desktop

#Get and set up the Kororaa Adobe flash and NVIDIA driver installers
#cp kororaa-source/tools/add-remove-extras.sh /usr/local/bin/add-remove-extras.sh
#chmod a+x /usr/local/bin/add-remove-extras.sh
#cp kororaa-source/tools/add-remove-extras.desktop /usr/local/share/applications/add-remove-extras.desktop
#sed -i 's/kdesu/beesu/g' /usr/local/share/applications/add-remove-extras.desktop
#chmod a+x /usr/local/share/applications/add-remove-extras.desktop

#Copy add-remove-extras to the desktop
mkdir /etc/skel/Desktop
cp /usr/share/applications/add-remove-extras.desktop /etc/skel/Desktop/
chmod a+x /etc/skel/Desktop/add-remove-extras.desktop

#Copy Help document to desktop
#cp kororaa-source/doco/Help.pdf /etc/skel/Desktop/
ln -sf /usr/share/doc/kororaa-release-notes-14/Help.pdf /etc/skel/Desktop/Help.pdf

#Build out of kernel modules (so it's not done on first boot)
echo "****BUILDING AKMODS****"
/usr/sbin/akmods --force

#Download repo files for those without a release package to install
#cp kororaa-source/repos/atrpms.repo /etc/yum.repos.d/atrpms.repo
#cp kororaa-source/repos/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
#cp kororaa-source/repos/kororaa.repo /etc/yum.repos.d/kororaa.repo
#cp kororaa-source/repos/ksplice-uptrack.repo /etc/yum.repos.d/ksplice-uptrack.repo
#cp kororaa-source/repos/libreoffice.repo /etc/yum.repos.d/libreoffice.repo
#cp kororaa-source/repos/virtualbox.repo /etc/yum.repos.d/virtualbox.repo
#cp kororaa-source/repos/fedora-yum-rawhide.repo /etc/yum.repos.d/fedora-yum-rawhide.repo

#Import keys
for x in kororaa livna adobe-linux rpmfusion-free-fedora rpmfusion-nonfree-fedora ; do rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-$x ; done
#Chrome (this should prob just go in the repo file instead)
wget https://dl-ssl.google.com/linux/linux_signing_key.pub
rpm --import linux_signing_key.pub
rm linux_signing_key.pub
#Ksplice key
#wget https://www.ksplice.com/yum/RPM-GPG-KEY-ksplice
#rpm --import RPM-GPG-KEY-ksplice
#rm RPM-GPG-KEY-ksplice
#ATRPMs key
#wget http://atrpms.net/RPM-GPG-KEY.atrpms
#rpm --import RPM-GPG-KEY.atrpms
#rm RPM-GPG-KEY.atrpms

#Don't allow Adobe to install reader (auto pulled in by flash).. yuck.
echo "exclude=AdobeReader*" >> /etc/yum.repos.d/adobe-linux-i386.repo

#Set yum to autoclean orphans on package removal and to only keep one old kernel around
#sed -i '/^\[main\]$/a clean_requirements_on_remove=1' /etc/yum.conf
sed -i 's/^installonly_limit=.*/installonly_limit=2/g' /etc/yum.conf

#Set up default Firefox profile with goodies like adblockplus, plasma notify, xclear, flashblock, etc.
#wget http://kororaa.org/files/firefox-extensions.tar.bz2

#Set up firefox extensions and prefs. Just do both, it should fail on the other archs, echo doesn't seem to work properly.
#tar -xvf firefox-extensions.tar.bz2 -C /usr/lib64/firefox-3.6/defaults/profile/
cat >> /usr/lib64/firefox-3.6/defaults/profile/prefs.js << EOF
user_pref("browser.download.manager.showAlertOnComplete", false);
user_pref("browser.download.manager.showWhenStarting", false);
user_pref("browser.download.useDownloadDir", false);
user_pref("extensions.dss.switchPending", true);
user_pref("downbar.function.version", "0.9.8");
user_pref("intl.accept_languages", "en-au,en-us,en");
EOF
chown -Rf root:root /usr/lib64/firefox-3.6/defaults/profile/

#32 bit
tar -xvf firefox-extensions.tar.bz2 -C /usr/lib/firefox-3.6/defaults/profile/
cat >> /usr/lib/firefox-3.6/defaults/profile/prefs.js << EOF
user_pref("browser.download.manager.showAlertOnComplete", false);
user_pref("browser.download.manager.showWhenStarting", false);
user_pref("browser.download.useDownloadDir", false);
user_pref("extensions.dss.switchPending", true);
user_pref("extensions.lastSelectedSkin", "oxygen");
user_pref("downbar.function.version", "0.9.8");
user_pref("intl.accept_languages", "en-au,en-us,en");
EOF
chown -Rf root:root /usr/lib/firefox-3.6/defaults/profile/

#Remove KDE addons
#rm -Rf /usr/lib*/firefox-3.6/defaults/profile/extensions/plasmanotify@andreas-demmer.de
#rm -Rf /usr/lib*/firefox-3.6/defaults/profile/extensions/\{C1F83B1E-D6EE-11DE-B441-1AD556D89593\}

#rm firefox-extensions.tar.bz2

#Patch the Firefox bookmarks and start page
#cp kororaa-source/doco/bookmarks.html /usr/lib64/firefox-3.6/defaults/profile/bookmarks.html
#cp kororaa-source/doco/bookmarks.html /usr/lib/firefox-3.6/defaults/profile/bookmarks.html
mv /usr/lib64/firefox-3.6/defaults/profile/bookmarks.html /usr/lib64/firefox-3.6/defaults/profile/bookmarks-fedora.html
ln -sf /usr/lib64/firefox-3.6/defaults/profile/bookmarks-kororaa.html /usr/lib64/firefox-3.6/defaults/profile/bookmarks.html
rm /usr/lib/firefox-3.6/defaults/profile/bookmarks.html
ln -sf /usr/lib/firefox-3.6/defaults/profile/bookmarks-kororaa.html /usr/lib/firefox-3.6/defaults/profile/bookmarks.html
sed -i 's/start.fedoraproject.org//' /usr/lib*/firefox-3.6/browserconfig.properties

#Sudoers modifications
#echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/01_kororaa
#echo "Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin" >> /etc/sudoers.d/01_kororaa
#chmod 0440 /etc/sudoers.d/01_kororaa

#User modification, add first user to wheel, adm and lp groups
cat >> /etc/rc.local << EOF
for x in desktop_admin_r wheel adm lp ; do gpasswd -a \$(tail -n1 /etc/passwd |awk -F ":" {'print \$1'}) \$x ; done
for x in livesys livesys-late ; do chkconfig $x off ; done
sed -i '/^for.*/d' /etc/rc.local /etc/rc.d/rc.local /etc/rc.d/rc*.d/S99rc-local
sed -i '/^sed.*/d' /etc/rc.local /etc/rc.d/rc.local /etc/rc.d/rc*.d/S99rc-local
EOF

#Fix cups issues
sed -i 's/^SystemGroup.*/SystemGroup\ sys\ root\ wheel/g' /etc/cups/cupsd.conf
sed -i 's/^<\/Location>/\ \ Allow\ From\ 127.0.0.1\n<\/Location>/g' /etc/cups/cupsd.conf

#GNOME modifications
#GNOME - Set default apps: vlc, firefox
ln -sf /usr/share/applications/mimeapps.list-gnome /usr/share/applications/mimeapps.list
#cp /usr/share/applications/defaults.list /usr/local/share/applications/mimeapps.list
#sed -i 's/Default\ Applications/Added\ Associations/g' /usr/local/share/applications/mimeapps.list
#sed -i 's/totem.desktop/vlc.desktop/g' /usr/local/share/applications/mimeapps.list
#sed -i 's/brasero-ncb.desktop/k3b.desktop/g' /usr/local/share/applications/mimeapps.list
#sed -i 's/openoffice.org/libreoffice/g' /usr/local/share/applications/mimeapps.list
#sed -i 's/gnome-gnumeric.desktop/libreoffice-calc.desktop/g' /usr/local/share/applications/mimeapps.list

#GNOME - Set default apps, other GNOME tweaks.
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type string /desktop/gnome/applications/media/exec vlc
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type string /apps/gnome-power-manager/ui/icon_policy always

#Set gnome-shell by default - changed my mind. Boot to normal, unless they pass "gnome-shell" to kernel line (or turn on manually).
#gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type string /desktop/gnome/session/required_components/windowmanager gnome-shell

#Set touchpad two finger scroll, disable when typing, tap to click.
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type int /desktop/gnome/peripherals/touchpad/scroll_method 2
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type bool /desktop/gnome/peripherals/touchpad/disable_while_typing true
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --set --type bool /desktop/gnome/peripherals/touchpad/tap_to_click true

#Polkit changes to let wheel users do admin work
#cp kororaa-source/polkit/10-kororaa-overrides.pkla /var/lib/polkit-1/localauthority/50-local.d/10-kororaa-overrides.pkla
#/sbin/restorecon '/var/lib/polkit-1/localauthority/50-local.d/10-kororaa-overrides.pkla'

#Update locate database
/usr/bin/updatedb

#Rebuild initrd to remove Generic branding (necessary?)
/sbin/dracut -f

#Set vim background to be dark
echo "set bg=dark" >> /etc/vimrc

#Set colourful bash
echo "alias ls='ls --color=auto'" >> /etc/skel/.bashrc
echo "alias vim='vi'" >> /etc/skel/.bashrc
echo 'export PS1="\[\033[01;32m\]\u\[\033[1;32m\]@\[\033[01;32m\]\h\[\033[01;34m\] \W\[\033[01;32m\] \[\033[01;34m\]\$\[\033[00m\] "' >> /etc/skel/.bashrc

#Set cgroup hack
cat >> /etc/skel/.bashrc << EOF
if [ "\$PS1" ] ; then
        mkdir -m 0700 -p /cgroup/cpu/user/\$$ 2>/dev/null
        echo 1 > /cgroup/cpu/user/\$$/notify_on_release 2>/dev/null
        echo \$$ > /cgroup/cpu/user/\$$/tasks 2>/dev/null
fi
EOF

#Get script to remove cgroups
#cp kororaa-source/tools/rm-cgroup.sh /usr/local/bin/rm-cgroup.sh
#chmod a+x /usr/local/bin/rm-cgroup.sh

#Tell system to set up cgroups
cat >> /etc/rc.local << EOF
#Set up "200 line patch", in bash
mkdir /cgroup/cpu 2>/dev/null
mount -t cgroup -o cpu none /cgroup/cpu 2>/dev/null
mkdir -p -m 0777 /cgroup/cpu/user 2>/dev/null
echo "/usr/bin/rm-cgroup.sh" > /cgroup/cpu/release_agent 2>/dev/null
EOF

#Set history search
#echo '"\e[1;5A": history-search-backward' >> /etc/skel/.inputrc
#echo '"\e[1;5B": history-search-forward' >> /etc/skel/.inputrc

#Let's run prelink
/usr/sbin/prelink -av -mR -q

#LiveCD stuff (like creating user) is done by fedora-live-base.ks
#Modify LiveCD stuff, i.e. set autologin, enable installer (this is done in /etc/rc.d/init.d/livesys)
cat >> /etc/rc.d/init.d/livesys << EOF

#Set up autologin
sed -i '/^\[daemon\]/a TimedLoginEnable=true\nTimedLogin=liveuser\nTimedLoginDelay=5' /etc/gdm/custom.conf

# don't use prelink on a running KDE live image
sed -i 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink

#un-mute sound card (some issues reported)
amixer set Master 85% unmute

#chmod a+x /home/liveuser/Desktop/liveinst.desktop
chmod +x /usr/share/applications/liveinst.desktop
chown -Rf liveuser:liveuser /home/liveuser/Desktop
restorecon -R /home/liveuser/

EOF

#yum update

#Finally, clean up resolv.conf hack
echo "" > /etc/resolv.conf

#Clean up git
rm -Rf kororaa-source
yum clean all

%end

