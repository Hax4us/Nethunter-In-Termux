# Nethunter-In-Termux
This is a script by which you can install Kali nethunter (Kali Linux) in your termux application without rooted phone 
### Steps For Installation
1. Download script in **HOME** `curl -LO https://raw.githubusercontent.com/Hax4us/Nethunter-In-Termux/master/kalinethunter`
2. Give execution permission `chmod +x kalinethunter`
3. Run script `./kalinethunter`
4. Now just start kali nethunter `startkali`

### Compulsory Steps For First Time Use (Only for Fisrt Time After Installation)
1. So after `startkali`, execute this command `wget https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2018.1_all.deb`
2. `apt install ./kali-archive-keyring_2018.1_all.deb`

### In Case Of SSL error: certificate verify failed
Rerun script with extra parameter `--insecure` or copy paste this command `./kalinethunter --insecure`

#### Here is guide to setup LXDE 
https://www.hax4us.com/2018/07/how-to-install-lxde-in-kali-nethunter.html?m=1

#### You have any idea to improve ? So Just give PR
