#!/data/data/com.termux/files/usr/bin/bash -e
# Copyright ©2018 by Hax4Us. All rights reserved.  🌎 🌍 🌏 🌐 🗺
#
# https://hax4us.com
################################################################################
# Updated By: LJohnson2484
# Modified Date: 11/21/24
################################################################################

# colors
red='\033[1;31m'
yellow='\033[1;33m'
blue='\033[1;34m'
reset='\033[0m'

# Clean up
pre_cleanup() {
        find $HOME -name "kali*" -type d -exec rm -rf {} \; || :
}

post_cleanup() {
        find $HOME -name "kali*" -type f -exec rm -rf {} \; || :
} 

# Utility function for Unknown Arch
#####################
#    Decide Chroot  #
#####################

setchroot() {
	chroot=full
}

#####################
#    SETARCH        #
#####################
unknownarch() {
	printf "${red} [*] Unknown Architecture :("
	printf "\n${reset}"
	exit
}

# Utility function for detect system
checksysinfo() {
	printf "$blue [*] Checking host architecture ..."
	case $(getprop ro.product.cpu.abi) in
		arm64-v8a)
			SETARCH=arm64;;
		armeabi|armeabi-v7a)
			SETARCH=armhf;;
		*)
			unknownarch;;
	esac
        printf "\n [*] SETARCH = ${SETARCH}"
}

# Check if required packages are present
checkdeps() {
	printf "\n${blue} [*] Updating apt cache..."
	apt update -y &> /dev/null
	echo "\n [*] Checking for all required tools..."

	for i in proot tar axel; do
		if [ -e $PREFIX/bin/$i ]; then
			echo "\n  • ${i} is OK"
		else
			echo "\nInstalling ${i}..."
			apt install -y $i || 
                        {
				printf "\n${red} ERROR: check your internet connection or apt"
				printf "\n Exiting...${reset}\n"
				exit
			}
		fi
	done
	apt upgrade -y
}

# URLs of all possibls architectures
seturl() {
	URL="https://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-${chroot}-${SETARCH}.tar.xz"
}

# Utility function to get tar file
gettarfile() {
    seturl
    printf "\n$blue} [*] Fetching tar file"
    printf "\n from ${URL}"
    cd $HOME
    rootfs="kali-nethunter-rootfs-${chroot}-${SETARCH}.tar.xz"
    printf "\n [*] Placing ${rootfs}"
    DESTINATION=$HOME/chroot/kali-$SETARCH
    printf "\n into {$DESTINATION}"
    printf "${reset}\n"
    if [ ! -f "$rootfs" ]; then
        axel ${EXTRAARGS} --alternate "$URL"
    else
        printf "${red} [!] continuing with already downloaded image,"
        printf "\n if this image is corrupted or half downloaded then "
        printf "\n delete it manually to download a fresh image."
        printf "${reset}\n"
    fi
}

# Utility function to get SHA
getsha() {
	printf "\n${blue} [*] Getting SHA ... $reset\n"
    if [ -f kali-nethunter-rootfs-${chroot}-${SETARCH}.tar.xz.sha512sum ]; then
        rm kali-nethunter-rootfs-${chroot}-${SETARCH}.tar.xz.sha512sum
    fi
	axel ${EXTRAARGS} 
             --alternate "${URL}.sha512sum" \\
             -o $rootfs.sha512sum
}

# Utility function to check integrity
checkintegrity() {
	printf "\n${blue} [*] Checking integrity of file..."
	prinf "\n [*] The script will immediately terminate in case of integrity failure"
	printf "${reset}\n"
	sha512sum -c $rootfs.sha512sum || \\
        {
		printf "${red} Sorry :( to say your downloaded linux file was corrupted"
                printf "\n or half downloaded, but don'''t worry, just rerun my script"
                printf "${reset}\n"
		exit 1
	}
}

# Utility function to extract tar file
extract() {
	printf "\n${blue} [*] Extracting ${rootfs}"
        printf "\n into ${DESTINATION}"
        printf "${reset}\n"
	proot --link2symlink \\
              tar -xf $rootfs \\
              -C $HOME 2> /dev/null || :
}

# Utility function for login file
createloginfile() {
	bin=$PREFIX/bin/startkali.sh
        printf "\n${blue} [*] Creating ${bin}"
        printf "${reset}\n"
	cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash -e
unset LD_PRELOAD

# colors
red='\033[1;31m'
yellow='\033[1;33m'
blue='\033[1;34m'
reset='\033[0m'

#####################
#    SETARCH        #
#####################
unknownarch() {
	printf "\n${red} [*] Unknown Architecture :("
	printf "${reset}\n"
	exit
}

# Utility function for detect system
checksysinfo() {
	printf "\n$blue [*] Checking host architecture ..."
	case $(getprop ro.product.cpu.abi) in
		arm64-v8a)
			SETARCH=arm64;;
		armeabi|armeabi-v7a)
			SETARCH=armhf;;
		*)
			unknownarch;;
	esac
        printf "\n [*] SETARCH = ${SETARCH}"
}
if [ ! -f $DESTINATION/root/.version ]; then
    touch $DESTINATION/root/.version
fi
user=kali
home=$DESTINATION/home/$user
LOGIN="sudo -u \$user /bin/bash"
if [[ ("\$#" != "0" && ("\$1" == "-r")) ]]; then
    user=root
    home=$DESTINATION/$user
    LOGIN="/bin/bash --login"
    shift
fi

cmd="proot \\
    --link2symlink \\
    -0 \\
    -r ${DESTINATION} \\
    -b /dev \\
    -b /proc \\
    -b ${DESTINATION}/dev:/dev/shm \\
    -b /sdcard \\
    -b ${HOME} \\
    -w ${home} \\
    ${PREFIX}/bin/env -i \\
    HOME=${home} TERM=${TERM} \\
    LANG=${LANG} \\
    PATH=${DESTINATION}/bin:${home}/bin:${DESTINATION}/sbin:${home}/sbin:${DESTINATION}\etc:${home}/bin \\
    ${LOGIN}"

args="${@}"
if [ "${#}" == 0 ]; then
    exec $cmd
else
    $cmd -c "${args}"
fi
EOM
	chmod 700 $bin
}

printline() {
	printf "\n${blue}"
	echo " #---------------------------------#"
}

# Start
clear
EXTRAARGS=""
if [[ ! -z $1 ]]; then
    EXTRAARGS=$1
    if [[ $EXTRAARGS != "--insecure" ]]; then
		EXTRAARGS=""
    fi
fi

printf "\n${yellow} You are going to install Kali Nethunter"
printf "\n In Termux Without Root ;) Cool"

pre_cleanup
checksysinfo
checkdeps
setchroot
gettarfile
getsha
checkintegrity
extract
createloginfile
post_cleanup

printf "\n${blue} [*] Configuring Kali For You ..."

# Utility function for resolv.conf
resolvconf() {
	#create resolv.conf file 
	printf "\nnameserver 8.8.8.8\nnameserver 8.8.4.4" > $DESTINATION/etc/resolv.conf
} 
resolvconf

################
# finaltouchup #
################

finalwork() {
	[ -e $HOME/finaltouchup.sh ] && rm $HOME/finaltouchup.sh
	echo
	axel -a https://github.com/Hax4us/Nethunter-In-Termux/raw/master/finaltouchup.sh
	DESTINATION=$DESTINATION SETARCH=$SETARCH bash $HOME/finaltouchup.sh
} 
finalwork

printline
printf "\n${yellow} Now you can enjoy Kali Nethuter in your Termux :)"
printf "\n Don't forget to like my hard work for termux and many other things"
printline
printline
printf "\n${blue} [*] My official email:${yellow} lkpandey950@gmail.com"
printf "\n${blue} [*] My website:${yellow} https://hax4us.com"
printf "\n${blue} [*] My YouTube channel:${yellow} https://youtube.com/hax4us"
printline
printf "${reset}\n"
