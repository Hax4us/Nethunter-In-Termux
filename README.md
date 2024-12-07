# Nethunter-In-Termux
This is a script by which you can install Kali nethunter (Kali Linux) in your termux application without rooted phone 
### Steps For Installation
1. Download script in **HOME** `curl -LO https://raw.githubusercontent.com/Hax4us/Nethunter-In-Termux/master/kalinethunter.sh`
2. Give execution permission `chmod +x kalinethunter.sh`
3. Run script `./kalinethunter.sh`

### Usage 
1. Use command `startkali` to start nethunter. Default user is __kali__ and default password is also __kali__.
2. if you want to start nethunter as a root user then use command `startkali -r`.

### VNC Guide
1. To start a vnc session `vnc start`
2. To stop a vnc session `vnc stop`
3. To check status ( Display and port number) of vnc session `vnc status`
4. If user is __kali__ then by default `vnc start` will start vncserver with `DISPLAY=:2` & `PORT=5902` and for root user `DISPLAY=:1` & `PORT=5901`


### In Case Of SSL error: certificate verify failed
Rerun script with extra parameter `--insecure` or copy paste this command `./kalinethunter.sh --insecure`

### In case of APT error in kali: the public key is not available: NO_PUBKEY
1. Copy the missing key shown. For example:
```bash
Err:1 http://kali.download/kali kali-rolling InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY ED444FF07D8D0BF6
```

The missing key would be `ED444FF07D8D0BF6`
2. Add key to keyserver `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6`
Just change the final part to the key you found missing


#### setup LXDE 
Default __DESKTOP__ is __XFCE4__ but you can setup __LXDE__ also https://www.hax4us.com/2018/07/how-to-install-lxde-in-kali-nethunter.html?m=1

#### You have any idea to improve ? So Just give PR
