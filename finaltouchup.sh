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
stubs+=('usr/bin/chfn')
 for f in ${stubs[@]};do
  echo "Creating symlinks $f"
  ln -sf ${DESTINATION}/bin/true ${DESTINATION}/${f}
  done
  }

########################
# Adding User & groups #
########################

addgroups(){
	grps=()
	grps=('ssl-cert:x:111')
	grps=('postgres:x:115')
	if [ $SETARCH = armhf ];	then
	grps=('messagebus:x:110')
	fi
	for g in ${grps[@]}; do
		echo "Creating groups $g"
		sed -i '$ a $g' $DESTINATION/etc/group
		done
	}

adduser() {
	usr=()
	if [ $SETARCH = armhf ]; then
	usr+=('messagebus:x:106:110::/var/run/dbus:/usr/sbin/nologin')
	fi
	usr+=('postgres:x:115:115::/usr/bin:/bin:/usr/sbin')
	for u in ${usr[@]}; do
		echo "Creating users $u"
		sed -i '$ a $u' $DESTINATION/etc/passwd
		done
	} 

###############
#    Main     #
###############

addgroups
adduser
