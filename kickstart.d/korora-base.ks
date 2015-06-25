# korora-base.ks
#
# Defines the basics for all kickstarts in the fedora-live branch
# Does not include package selection (other then mandatory)
# Does not include localization packages or configuration
#
# Does includes "default" language configuration (kickstarts including
# this template can override these settings)

timezone Etc/UTC --isUtc --ntpservers=0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org
auth --enableshadow --passalgo=sha512 --enablefingerprint
selinux --enforcing
firewall --enabled --service=ipp-client,mdns,samba,samba-client,ssh
xconfig --startxonboot
part / --size 10240 --fstype ext4
services --enabled=ksmtuned,lirc,NetworkManager,restorecond,spice-vdagentd --disabled=abrtd,abrt-ccpp,abrt-oops,abrt-vmcore,abrt-xorg,capi,iprdump,iprinit,iprupdate,iscsi,iscsid,isdn,libvirtd,multipathd,netfs,network,nfs,nfslock,pcscd,rpcbind,rpcgssd,rpcidmapd,rpcsvcgssd,sendmail,sm-client,sshd

%include korora-repo.ks
%include korora-common-packages.ks

%post

# disable all abrt services, we can't upload to bugzilla
for x in abrtd abrt-ccpp abrt-oops abrt-vmcore abrt-xorg ; do
  systemctl disable $x
done

# import keys
echo -e "\n***\nIMPORTING KEYS\n***"
for x in 20 21 22
do
  for y in adobe fedora-$x-primary fedora-$x-secondary google-chrome google-earth google-talkplugin korora-$x-primary korora-$x-secondary rpmfusion-free-fedora-$x-primary rpmfusion-nonfree-fedora-$x-primary virtualbox
  do
    KEY="/etc/pki/rpm-gpg/RPM-GPG-KEY-${y}"
    if [ -r "${KEY}" ];
    then
      rpm --import "${KEY}" && echo "IMPORTED: $KEY (${y})"
    else
      echo "IMPORT KEY NOT FOUND: $KEY (${y})"
    fi
  done
done

# enable magic keys
echo "kernel.sysrq = 1" >> /etc/sysctl.conf

# make home dir
mkdir /etc/skel/{Documents,Downloads,Music,Pictures,Videos}

# set the korora plymouth theme
sed -i s/^Theme=.*/Theme=korora/ /etc/plymouth/plymouthd.conf

cat >> /etc/rc.d/init.d/livesys << EOF

# disable fedora welcome screen
rm -f /usr/share/applications/fedora-welcome.desktop
rm -f ~liveuser/.config/autostart/fedora-welcome.desktop

EOF

%end
