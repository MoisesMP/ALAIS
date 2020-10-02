#!/bin/bash
set -e
##################################################################################################################
# BSPWM-Install-ArchLinux
# Author	:	Moises Montaño


# Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Default
DefaultColor='\e[39m'   # Default foreground color

b='\033[1m'
u='\033[4m'
bl='\E[30m'
r='\E[31m'
g='\E[32m'
y='\E[33m'
bu='\E[34m'
m='\E[35m'
c='\E[36m'
w='\E[37m'
endc='\E[0m'
enda='\033[0m'
spath="$( cd "$( dirname $0 )" && pwd )"


showlogo(){
  clear
echo ""
sleep 0.1
echo -e $Cyan   "    +${Yellow}------------------------------------------------------------------------------------------------${Cyan}+"
sleep 0.1
echo -e $Yellow   "    |                                                                                               $Yellow |"
sleep 0.1
echo -e "     |$Red                                  ARCH LINUX APP INSTALLER                                     $Yellow |" 
sleep 0.1
echo -e "     |$Red                                                                                               $Yellow |"  
sleep 0.1
echo -e "     |$Red              \e[1;37m  Created By Moises Montaño @MoisesMP: github.com/MoisesMP                       $Yellow |"
sleep 0.1
echo -e $Cyan   "    +${Yellow}------------------------------------------------------------------------------------------------${Cyan}+${Yellow}"            
}

#Install script if not installed
installScript(){
if [ ! -e "/usr/bin/ALAIS" ]; then
	echo -en "\e[32m[-] : Script is not installed. Do you want to install it ? (Y/N) !\e[0m"
	read install
	if [[ $install = Y || $install = y ]] ; then
		sudo mkdir -p /usr/bin/ALAIS
		sudo cp -r * /usr/bin/ALAIS
		sudo chmod +777 /usr/bin/ALAIS
		echo "Script should now be installed. Launching it !"
		sleep 1
    echo "You can run the script anytime by typing '' on the Terminal"
    sleep 2
		exit 1
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
else
	echo "Script is installed"
	sleep 1
fi
}

#Cheking Os Architecture
archicheck(){
if [[ $(uname -m ) = x86_64 ]]; then
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf  
else
  echo -e "\e[32m[-] multilab is already Enabled !\e[0m"
	#sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf 
fi

}

UpdateRepos(){
	sudo pacman -Syy
}


checkroot(){
	if [[ "$EUID" -ne 0 ]]; then
		Welcome
	else
		echo -e  "${Red} Please not run Script as root${DefaultColor}"
		#statements
	fi
}

aur_package=;
package=;
package_extra=;
readmore=;



checkgit(){
    if pacman -Qi git &> /dev/null; then
    	echo [✔]::[Git]: installation found!;
	else
		echo [x]::[warning]:this script require Git ;
		echo ""
		echo [!]::[please wait]: Installing Git ..  ;
		sudo pacman -S git --noconfirm
		echo ""
	fi
	sleep 1

}

checkyay(){
    if pacman -Qi yay &> /dev/null; then
    	echo [✔]::[Yay]: installation found!;
	else
		echo [x]::[warning]:this script require Yay ;
		echo ""
		echo [!]::[please wait]: Installing Yay ..  ;
		git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si 
		echo ""
	fi
	sleep 1
}

checkwget(){
    if pacman -Qi wget &> /dev/null; then
    	echo [✔]::[Wget]: installation found!;
	else
		echo [x]::[warning]:this script require Wget ;
		echo ""
		echo [!]::[please wait]: Installing Yay ..  ;
		sudo pacman -S wget --noconfirm
		echo ""
	fi
	sleep 1
}



package_install(){
    if pacman -Qi $package &> /dev/null; then
    	echo [✔]::[$package]: installation found!;
    	echo -en " ${y}Press Enter To Return To Menu${endc}"
    	read input
	else
		clear
		echo
    	echo -e " Currently Installing ${b}"$package"${enda}"
    	echo -e " Read about the application here: ${b}"$readmore"${endc}"
    	echo && echo -en " ${y}Press Enter To Continue${endc}"
    	read input
		echo -e [!]::[please wait]: Installing $package ..  ;
		sudo pacman -S --noconfirm $package
		if pacman -Qi $package &> /dev/null; then 
			echo -e " ${b}"$package"${enda} Was Successfully Installed"
		else
			echo -e "${Red} Error ${b}"$package"${enda} Not Install"
		fi
    	echo -en " ${y}Press Enter To Return To Menu${endc}"
    	read input
	fi
#sleep 1

}

desktop_package_install(){
    if pacman -Qi $package &> /dev/null; then
    	echo [✔]::[$package]: installation found!;
    	echo -en " ${y}Press Enter To Return To Menu${endc}"
    	echo
    	read input
	else
		clear
		echo
    	echo -e " Currently Installing ${b}"$package"${enda}"
    	echo -e " Read about the application here: ${b}"$readmore"${endc}"
    	echo && echo -en " ${y}Press Enter To Continue${endc}"
    	read input
		echo -e [!]::[please wait]: Installing $package ..  ;
		sudo pacman -S --noconfirm $package 
		echo -e "
            Y) Install "$package_extra" 
            N) Exit
            "
	    echo -en " Choose An Option: "
	    read option
	    case $option in
	        y) sudo pacman -S --noconfirm $package_extra ;;
	        Y) sudo pacman -S --noconfirm $package_extra ;;
	        n) sleep 1;;
	        N) sleep 1;;
	        *) echo " \"$option\" Is Not A Valid Option"; sleep 1;;
	    esac
		if pacman -Qi $package &> /dev/null; then 
			echo -e " ${b}"$package"${enda} Was Successfully Installed"
		else
			echo -e "${Red} Error ${b}"$package"${enda} Not Install"
		fi
    	echo -en " ${y}Press Enter To Return To Menu${endc}"
    	echo
    	read input
	fi
#sleep 1

}


aur_package_install(){
	if pacman -Qi $aur_package &> /dev/null; then
		echo [✔]::[$aur_package]: installation found!;
		echo -en " ${y}Press Enter To Return To Menu${endc}"
    	echo
    	read input
	else
		clear
		echo
    	echo -e " Currently Installing ${b}"$aur_package"${enda}"
    	echo -e " Read about the application here: ${b}"$readmore"${endc}"
    	echo && echo -en " ${y}Press Enter To Continue${endc}"
    	read input
		echo [!]::[please wait]: Installing $package ..  ;
		yay -S --noconfirm $aur_package
		if pacman -Qi $aur_package &> /dev/null; then 
			echo -e " ${b}"$aur_package"${enda} Was Successfully Installed"
		else
			echo -e "${Red} Error ${b}"$aur_package"${enda} Not Install"
		fi
    	echo -en " ${y}Press Enter To Return To Menu${endc}"
    	echo
    	read input 
	fi

}

showSystemApps(){
    showlogo
    echo -e " ${b} [System Apps]${enda}"
    echo -e "
            1) GParted
            2) G
            3) Terminals

            q)    Return To Menu"

    echo
    echo -en " Choose An Option: "
    read option
    case $option in
    	1) package=gparted && readmore=www.gparted.org && package_install;;
		3) showterminals;;
        8) package=picom && aur_package_install;;
        q) sleep 1;;
        *) echo " \"$option\" Is Not A Valid Option"; sleep 1; showSystemApps ;;
	esac
}

showTextEditors(){
	clear
    echo -e "${Yellow}------------------------------------------------${DefaultColor}"
    echo ""
    echo -e "                 ${b} [Text Editors]${enda}"
    echo ""
    echo -e "${Yellow}------------------------------------------------${DefaultColor}"
    echo -e "
            1) GEANY
            2) VIM
            3) KATE
            4) ATOM
            5) LEAFPAD

            ${Red}q)    Return To Menu${DefaultColor}"

    echo
    echo -en "${Blue} Choose An Option: ${DefaultColor}"
    read option
    case $option in
        1) package=geany && readmore=www.geany.org && package_install;;
        2) package=vim && readmore=www.vim.org && package_install;;
		3) package=kate && readmore=www.kate-editor.org && package_install;;
		4) package=atom && readmore=www.atom.io && package_install;;
		5) package=leafpad && readmore=tarot.freeshell.org/leafpad/ && package_install;;
        q) sleep 1;;
        *) echo " \"$option\" Is Not A Valid Option"; sleep 1; showTextEditors ;;
	esac
}

showVideoPlayers(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                ${b} [Video Players]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) VLC
			2) KMPlayer
			3) MPlayer
			4) Gnome MPlayer
			5) Plex ${Cyan}(Aur)${DefaultColor}
			6) Kodi

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) package=vlc && readmore=www.videolan.org/vlc && package_install;;
		2) package=kmplayer && readmore=www.kmplayer.kde.org/ && package_install;;
		3) package=mplayer && readmore=www.mplayerhq.hu && package_install;;
		4) package=gnome-mplayer && readmore=" " && package_install;;
		5) aur_package=plex-media-player && readmore=" " && aur_package_install;;
		6) package=kodi && readmore=" " && package_install;;
		q) showVideoApps;;
		*) echo " \"$option\" Is Not A Valid Option"; sleep 1; showVideoPlayers ;;
	esac

}



showVideoApps(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                 ${b} [Video Apps]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) Players
			2) Editors | Tools

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) showVideoPlayers;;
		q) sleep 1;;
		*) echo " \"$option\" Is Not A Valid Option"; sleep 1; showVideoApps;;
	esac

}

showAudioPlayers(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                   ${b} [Music Players]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) Lollypop
			2) Rhythmbox
			3) Clementine
			4) Pragha

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) package=lollypop && readmore=wiki.gnome.org/Apps/Lollypop && package_install;;
		2) package=rhythmbox && readmore=" " && package_install;;
		3) package=clementine && readmore=https://www.clementine-player.org/ && package_install;;
		4) package=pragha && readmore=https://pragha-music-player.github.io/ && package_install;;
		q) showAudioApps;;
		*) echo " \"$option\" Is Not A Valid Option"; sleep 1; showAudioPlayers ;;
	esac

}

showAudioEditors(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                ${b} [Editors | Tools]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) Audacity
			2) Easytag
			3) Soundconverter

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) package=audacity && readmore=" " && package_install;;
		2) package=easytag && readmore=https://wiki.gnome.org/Apps/EasyTAG && package_install;;
		3) package=soundconverter && readmore=" " && package_install;;
		q) showAudioApps;;
		*) echo "\"$option\" Is Not A Valid Option"; sleep 1; showAudioEditors;;
	esac
}


showAudioApps(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                  ${b} [Audio Apps]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) Players
			2) Editors | Tools

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) showAudioPlayers;;
		2) showAudioEditors;;
		q) sleep 1;;
		*) echo "\"$option\" Is Not A Valid Option"; sleep 1; showAudioApps;;
	esac
}

showterminals(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                  ${b} [Terminals]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) TILIX
			2) GNOME TERMINAL
			3) KONSOLE
			4) RXVT
			5) XTERM
			6) TMUX
			7) TILDA
			8) TERMINATOR

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: $DefaultColor}"
	read option
	case $option in
		1) package=tilix && readmore=gnunn1.github.io/tilix-web/ && package_install;;
		2) package=gnome-terminal && readmore=https://help.gnome.org/users/gnome-terminal/stable/ && package_install;;
		3) package=konsole && readmore=kde.org/applications/system/konsole/ && package_install;;
		4) package=rxvt-unicode && readmore=software.schmorp.de/pkg/rxvt-unicode.html && package_install;;
		5) package=xterm && readmore=invisible-island.net/xterm/ && package_install;;
		5) package=tmux && readmore=github.com/tmux/tmux/wiki && package_install;;
		7) package=tilda && readmore=github.com/lanoxx/tilda && package_install;;
		8) package=terminator && readmore=github.com/gnome-terminator/terminator && package_install;;
		q) sleep 1; showSystemApps;;
		*) echo " \"$option\" Is Not A Valid Option"; sleep 1; showterminals ;;
	esac
}

showdesktop_environment(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "               ${b} [Desktop Environment]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e " 
			1) MATE Dektop
			2) XFCE
			3) LXDE
			4) KDE Plasma
			5) GNOME
			6) CINNAMON
			7) LXQT
			8) BUDGIE Desktop
			9) DEEPIN Desktop

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) package=mate && package_extra=mate-extra && readmore=mate && desktop_package_install;;
		2) package="xfce4 xfce4-goodies network-manager-applet pulseaudio" && readmore=xfce4 && package_install;;
		3) package=lxde && readmore=LXDE && package_install;;
		4) package="plasma kde-applications plasma-wayland-session" && readmore=Plasma && package_install;;
		5) package=gnome && package_extra=gnome–extra && readmore=GNOME && desktop_package_install;;
		6) package=cinnamon && readmore=cinnamon && package_install;;
		7) package=lxqt && readmore=lxqt && package_install;;
		8) package=budgie-desktop && readmore=budgie-desktop && package_install;;
		9) package=deepin && package_extra=deepin-extra && readmore=DEEPIN && desktop_package_install;;
		q) sleep 1;;
		*) echo " \"$option\" Is Not A Valid Option"; sleep 1; showterminals ;;
	esac
}

showGames(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                    ${b} [Games]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo -e "
			1) Steam
			2) PlayOnLinux
			3) Lutris

			${Red}q)    Return To Menu${DefaultColor}"
	echo
	echo -en "${Blue}Choose An Option: ${DefaultColor}"
	read option
	case $option in
		1) package steam ;;
		2) package playonlinux && readmore=https://www.playonlinux.com/ && package_install;;
		3) package lutris && readmore=https://lutris.net/ && package_install;;
	esac
}

exitScript(){
  showlogo && echo -e "         Thank You For Using ${b}  Arch Linux App Installer Script ${enda}"
  echo
  sleep 1
  exit
}

updateSystem(){
	clear
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo ""
	echo -e "                  ${b} [  Update System  ]${enda}"
	echo ""
	echo -e "${Yellow}------------------------------------------------${DefaultColor}"
	echo && echo -en " ${y}Press Enter To Continue${endc}"
	read input
	sudo pacman -Syyu --noconfirm
	echo ""
	echo -e " ${b} Complete System Update."
	echo -en " ${y}Press Enter To Return To Menu${endc}"
	echo
	read input

}

main(){

while :
do

showlogo
echo ""
echo -e "${Blue}       User : ${DefaultColor}" $USER
echo ""
echo -e "      ${BCyan}[  Installer MENU ]${enda}"
echo -e "

	[1]   Desktop Environment            [9]   Internet Apps      
	[2]   Accessories Apps               [10]  Games      
	[3]   Development Apps               [11]  Web server
	[4]   Audio Apps                     [12]  Extra
	[5]   Video Apps                     [13]  Text Editors
	[6]   Office Apps                    [14]  Update System
	[7]   System Apps                    
	[8]   Graphics Apps                  

	${Red}[q]    Quit Script${DefaultColor}"   
        
        
        
echo
echo -en "        ${Blue}Select Option: ${DefaultColor}"
read option
case $option in
1) showdesktop_environment;;
2) ;;
3) ;;
4) showAudioApps;;
5) showVideoApps;;
7) showSystemApps;;
10) showGames;;
13) showTextEditors;;
14) updateSystem;; 
q) exitScript;;
*) echo " \"$option\" Is Not A Valid Option"; sleep 1 ;;

esac
done
}

Welcome(){
while :
do
clear
echo ""
sleep 0.1
echo -e "${Yellow}--------------------------------------------------------${DefaultColor}"
sleep 0.1
echo ""
sleep 0.1
echo -e "Welcome to the Arch Linux App Installer script by MoisesMP"
sleep 0.1
echo ""
sleep 0.1
echo -e "${Yellow}---------------------------------------------------------${DefaultColor}"
sleep 0.1
echo ""
sleep 0.1
echo -e "Script can be cancelled at any time with CTRL+C"
sleep 0.1
echo ""
sleep 0.1
echo -e "${Yellow}---------------------------------------------------------${DefaultColor}"
sleep 0.1
echo ""
sleep 0.1
echo && echo -en " ${y}Press Enter To Continue${endc}"
sleep 0.1
read input

clear

archicheck && UpdateRepos

#installScript

clear

checkyay
checkgit
checkwget

main
done
}


checkroot