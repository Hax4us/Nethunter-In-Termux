#!/data/data/com.termux/files/usr/bin/bash

####################
# Symlinks to true #
####################

symlinks() {
sym=()
sym+=('usr/sbin/groupadd')
sym+=('usr/sbin/groupdel')
sym+=('usr/bin/groups')
sym+=('usr/sbin/useradd')
sym+=('usr/sbin/usermod')
sym+=('usr/sbin/userdel')
sym+=('usr/bin/chage')
sym+=('usr/bin/mesg')  
sym+=('usr/bin/gpasswd')
sym+=('usr/bin/chfn')
 for f in ${sym[@]};do
  echo "Creating symlinks $f"
  ln -sf ${DESTINATION}/bin/true ${DESTINATION}/${f}
  done
  }

########################
# Adding User & groups #
########################

addgroups(){
	grps=()
	grps+=('ssl-cert:x:111')
	grps+=('postgres:x:115')
	if [ $SETARCH = armhf ]; then
	grps+=('lightdm:x:111')
	grps+=('messagebus:x:110')
else
	grps+=('lightdm:x:112')
	fi
	grps+=('rtkit:x:111')
	grps+=('pulse:x:111')
	grps+=('geoclue:x:113')
        grps+=('
	for g in ${grps[@]}; do
		echo "Creating groups $g"
		sed -i "$ a $g" $DESTINATION/etc/group
		done
	}

adduser() {
	usr=()
	usr+=('usbmux:x:108:46:Usbmux:/var/lib/usbmux:/bin/bash:/bin:/usr/sbin')
	if [ $SETARCH = arm64 ]; then
	usr+=('lightdm:x:107:112::/usr/bin:/usr/sbin:/bin')
else
	usr+=('lightdm:x:105:111:/usr/bin:/usr/sbin:/bin')
	fi
	usr+=('rtkit:x:111:111::/usr/bin/:/usr/sbin/:/bin')
	usr+=('pulse:x:111:111::/usr/bin/:/usr/sbin:/bin')
	if [ $SETARCH = armhf ]; then
	usr+=('messagebus:x:106:110::/var/run/dbus:/usr/sbin/nologin')
	fi
	usr+=('postgres:x:115:115::/usr/bin:/bin:/usr/sbin')
	usr+=('geoclue:x:113:113::/usr/bin:/bin:/usr/sbin')
	for u in ${usr[@]}; do
		echo "Creating users $u"
		sed -i "$ a $u" $DESTINATION/etc/passwd
		done
	} 

###############
#    Main     #
###############

#addgroups
#adduser
#symlinks
