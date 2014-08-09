#!/bin/bash

#Version 1.4
#This script will download between 360 MB and 660 MB's of data depending on your OS.
#Tested on Ubuntu 14.04 64-bit (final release), Lubuntu 64-bit (final release), Xubuntu 64-bit (final release) and Elementary OS Luna.

#Defining variables
os=$(cat /etc/issue.net | awk '{print $1}')

#checking os
if [[ "$os" == "elementary" ]]
then
echo "Found Elementary OS"
elif [ -d /usr/share/lubuntu ]
then
echo "Found Lubuntu"
elif [ -d /usr/share/xubuntu ]
then
echo "Found Xubuntu"
else
echo "Found Ubuntu"
fi

echo "Adding Repositories and installing programs.
Please type your password!"

#adding repo's
sudo add-apt-repository -y ppa:ubuntu-wine/ppa
sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder

#Update repo list and current software
sudo apt-get update
sudo apt-get -y dist-upgrade

#install programs
if [[ $os == "elementary" ]]
then
echo "Installing extra packages to Elementary OS"
sudo apt-get -y install audacity simplescreenrecorder gedit thunderbird vlc conky virtualbox griffith filezilla gksu flashplugin-installer easytag curl ubuntu-restricted-extras youtube-dl git-gui hddtemp lm-sensors clementine pidgin asunder icedtea-7-plugin openjdk-7-jre deluge wine1.7 libreoffice libreoffice-gtk
elif [ -d /usr/share/lubuntu ]
then
echo "Installing extra packages to Lubuntu"
sudo apt-get -y install audacity simplescreenrecorder gedit thunderbird vlc conky virtualbox griffith filezilla gksu flashplugin-installer easytag curl ubuntu-restricted-extras youtube-dl git-gui hddtemp lm-sensors clementine asunder icedtea-7-plugin openjdk-7-jre deluge wine1.7 libreoffice libreoffice-gtk
elif [ -d /usr/share/xubuntu ]
then
echo "Installing extra packages to Xubuntu"
sudo apt-get -y install audacity simplescreenrecorder gedit vlc conky virtualbox griffith filezilla gksu flashplugin-installer easytag curl ubuntu-restricted-extras youtube-dl git-gui hddtemp lm-sensors clementine asunder icedtea-7-plugin openjdk-7-jre deluge wine1.7 libreoffice libreoffice-gtk
else
echo "Installing extra packages to Ubuntu"
sudo apt-get -y install audacity simplescreenrecorder compizconfig-settings-manager vlc conky virtualbox griffith filezilla gksu flashplugin-installer easytag curl ubuntu-restricted-extras youtube-dl git-gui hddtemp lm-sensors clementine pidgin asunder icedtea-7-plugin openjdk-7-jre deluge wine1.7
fi

#uninstall programs
if [[ $os == "elementary" ]]
then
echo "Removing unwanted packages from Elementary OS"
sudo apt-get -y autoremove empathy totem noise scratch-text-editor geary midori-granite
elif [ -d /usr/share/lubuntu ]
then
echo "Removing unwanted packages from Lubuntu"
sudo apt-get -y autoremove leafpad audacious transmission-common transmission-gtk firefox sylpheed abiword gnumeric gnome-mplayer
elif [ -d /usr/share/xubuntu ]
then
echo "Removing unwanted packages from Xubuntu"
sudo apt-get -y autoremove transmission-common transmission-gtk firefox gmusicbrowser parole abiword gnumeric mousepad 
else
echo "Removing unwanted packages from Ubuntu"
sudo apt-get -y autoremove rhythmbox empathy totem transmission-common transmission-gtk firefox
fi

#Checking if the computer is a laptop and installing TLP if it is
if [ -d /sys/class/power_supply/BAT0 ]
then
echo "Installing TLP power management"
sudo add-apt-repository -y ppa:linrunner/tlp
sudo apt-get update
sudo apt-get -y install tlp
sudo service tlp start
else
echo "Battery not found. Will not install TLP"
fi

#making temporary download folder
mkdir /tmp/script-files/

#Checking OS architecture
if [ $MACHTYPE = x86_64-pc-linux-gnu ]
then

#Getting install files for Chrome, Steam and Dropbox 64-bit
wget -P /tmp/script-files/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb http://media.steampowered.com/client/installer/steam.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb

else
#Getting install files for Chrome, Steam and Dropbox 32-bit
wget -P /tmp/script-files/ https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb http://media.steampowered.com/client/installer/steam.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_i386.deb
fi

#Installing packages
sudo dpkg -i /tmp/script-files/*.deb
sudo apt-get -f -y install
rm /tmp/script-files/*.deb

#get griffith to work properly
wget -P /tmp/script-files/ http://www.strits.dk/files/validators.py
sudo mv /tmp/script-files/validators.py /usr/share/griffith/lib/db/validators.py

#fix Griffiths Export PDF to create a better PDF
wget -P /tmp/script-files/ http://www.strits.dk/files/PluginExportPDF.py
sudo mv /tmp/script-files/PluginExportPDF.py /usr/share/griffith/lib/plugins/export/PluginExportPDF.py

#fix griffiths IMDB plugin
wget -P /tmp/script-files/ http://www.strits.dk/files/PluginMovieIMDB.py
sudo mv /tmp/script-files/PluginMovieIMDB.py /usr/share/griffith/lib/plugins/movie/PluginMovieIMDB.py

#enable DVD playback
sudo /usr/share/doc/libdvdread4/install-css.sh

#remove unwanted lenses
if [[ $os == "elementary" ]]
then
echo "This is Elementary OS, will not remove unity lenses, because they are not there."
elif [ -d /usr/share/lubuntu ]
then
echo "This is Lubuntu, will not remove unity lenses, because they are not there."
elif [ -d /usr/share/xubuntu ]
then
echo "This is Xubuntu, will not remove unity lenses, because they are not there."
else
echo "Removing unwanted unity lenses."
sudo apt-get -y autoremove unity-lens-music unity-lens-video

#disable guest session
sudo sh -c 'echo "allow-guest=false" >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf'

fi

#deleting temporary download folder
rm -rf /tmp/script-files/

#tell user what programs where installed and which where uninstalled
if [[ $os == "elementary" ]]
then
echo "Programs installed succesfully on Elementary OS:
Handbrake
Audacity
Simplescreenrecorder
VLC Media Player
Conky
Virtualbox
Griffith
Gedit
Thunderbird
Filezilla
Flash Player
EasyTag
Restricted Extras
Youtube-dl
Git Gui
Hddtemp
Lm-sensors
Clementine
Java Plugin
Chrome
Dropbox 1.6
Steam
Wine 1.7
Video and DVD plugins
Libre Office"
if [ -d /sys/class/power_supply/BAT0 ]
then echo "TLP power management"
fi

echo "Programs uninstalled succesfully:
Totem
Empathy
Noise
Scratch
Geary
Midori"
elif [ -d /usr/share/lubuntu ]
then
echo "Programs installed succesfully on Lubuntu:
Handbrake
Audacity
Simplescreenrecorder
VLC Media Player
Conky
Virtualbox
Griffith
Gedit
Thunderbird
Filezilla
Flash Player
EasyTag
Restricted Extras
Youtube-dl
Git Gui
Hddtemp
Lm-sensors
Clementine
Java Plugin
Chrome
Dropbox 1.6
Steam
Wine 1.7
Video and DVD plugins
Libre Office"
if [ -d /sys/class/power_supply/BAT0 ]
then echo "TLP power management"
fi

echo "Programs uninstalled succesfully:
Leafpad
Audacious
Transmission
Firefox
Sylpheed
Abiword
Gnumeric
Gnome-Mplayer"
elif [ -d /usr/share/xubuntu ]
then
echo "Programs installed succesfully on Xubuntu:
Handbrake
Audacity
Simplescreenrecorder
VLC Media Player
Conky
Virtualbox
Griffith
Gedit
Filezilla
Flash Player
EasyTag
Restricted Extras
Youtube-dl
Git Gui
Hddtemp
Lm-sensors
Clementine
Java Plugin
Chrome
Dropbox 1.6
Steam
Wine 1.7
Video and DVD plugins
Libre Office"
if [ -d /sys/class/power_supply/BAT0 ]
then echo "TLP power management"
fi

echo "Programs uninstalled succesfully:
Transmission
Firefox
Gmusicbrowser
Parole
Abiword
Gnumeric
Mousepad"
else
echo "Programs installed succesfully on Ubuntu:
Handbrake
Audacity
Simplescreenrecorder
VLC Media Player
Conky
Virtualbox
Griffith
Filezilla
Flash Player
EasyTag
Restricted Extras
Youtube-dl
Git Gui
Hddtemp
Lm-sensors
Clementine
Pidgin
Java Plugin
Chrome
Dropbox 1.6
Steam
Wine 1.7
Video and DVD plugins"
if [ -d /sys/class/power_supply/BAT0 ]
then echo "TLP power management"
fi

echo "Programs uninstalled succesfully:
Transmission
Firefox
Rhythmbox
Empathy
Totem"
fi
