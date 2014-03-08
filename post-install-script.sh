#!/bin/bash

#Version 1.2
#This script will download about 343 MB's of data, install 24 (25 if on a laptop) programs and remove 4.
#Tested on Ubuntu 13.10 64-bit running on Virtualbox. Tested on laptop with 14.04 Beta 1 64-bit.


echo "Adding Repositories and installing programs.
Please type your password!"

#enable username on panel
gsettings set com.canonical.indicator.session show-real-name-on-panel true

#get regular scrollbars
gsettings set com.canonical.desktop.interface scrollbar-mode normal

#stop Nautilus
killall nautilus

#adding repo's
sudo add-apt-repository -y ppa:ubuntu-wine/ppa
#sudo add-apt-repository -y ppa:stebbins/handbrake-releases (might be in default repo's in Trusty)
sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder

#Update repo list
sudo apt-get update

#install programs
sudo apt-get -y install audacity simplescreenrecorder compizconfig-settings-manager vlc conky virtualbox unity-tweak-tool griffith handbrake filezilla gksu flashplugin-installer easytag ubuntu-restricted-extras clementine pidgin asunder icedtea-7-plugin openjdk-7-jre vuze wine1.7

#not ready for Saucy or Trusty yet
# handbrake-gtk (using raring .deb in a later command, might be in Trusty default repo's)

#uninstall programs
sudo apt-get -y autoremove rhythmbox empathy firefox totem transmission-common transmission-gtk

#these are disabled to test if they are needed when Ubuntu is installed with 3rd party software
#gstreamer0.10-plugins-ugly gstreamer0.10-ffmpeg libxine1-ffmpeg gxine mencoder libdvdread4 totem-mozilla icedax tagtool id3tool lame nautilus-script-audio-convert libmad0 mpg321

#Checking if the computer is a laptop and installing TLP if it is (not ready for Trusty yet, using Saucy package)
if [ -d /sys/class/power_supply/BAT0 ]
then
#sudo add-apt-repository -y ppa:linrunner/tlp
#sudo apt-get update
#sudo apt-get -y install tlp tlp-rdw
wget https://launchpad.net/~linrunner/+archive/tlp/+files/tlp_0.4-1~saucy_all.deb https://launchpad.net/~linrunner/+archive/tlp/+files/tlp-rdw_0.4-1~saucy_all.deb
sudo dpkg -i *.deb
sudo apt-get -f -y install
rm *.deb
sudo service tlp start
fi

#Checking OS architecture
if [ $MACHTYPE = x86_64-pc-linux-gnu ]
then

#Getting install files for Chrome, Steam, Dropbox and Handbrake 64-bit
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb http://media.steampowered.com/client/installer/steam.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb #https://launchpad.net/~stebbins/+archive/handbrake-releases/+files/handbrake-gtk_0.9.9ppa1~raring1_amd64.deb

else
#Getting install files for Chrome, Steam, Dropbox and Handbrake 32-bit
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb http://media.steampowered.com/client/installer/steam.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_i386.deb #https://launchpad.net/~stebbins/+archive/handbrake-releases/+files/handbrake-gtk_0.9.9ppa1~raring1_i386.deb
fi

#Installing packages
sudo dpkg -i *.deb
sudo apt-get -f -y install
rm *.deb

#get griffith to work properly
wget http://www.strits.dk/files/validators.py
sudo mv validators.py /usr/share/griffith/lib/validators.py

#fix Griffiths Export PDF to create a better PDF
wget http://www.strits.dk/files/PluginExportPDF.py
sudo mv PluginExportPDF.py /usr/share/griffith/lib/plugins/export/PluginExportPDF.py

#enable DVD playback
sudo /usr/share/doc/libdvdread4/install-css.sh

#remove unwanted lenses
sudo apt-get -y autoremove unity-lens-shopping unity-lens-music unity-lens-video unity-lens-gwibber unity-lens-photo

#disable guest session
sudo sh -c 'echo "allow-guest=false" >> /etc/lightdm/lightdm.conf'

#start Nautilus again
nautilus &

echo "Programs installed succesfully:
Handbrake (not in Saucy yet, installed Raring package instead. Might be in Trusty's default repo)
Audacity
Simplescreenrecorder
Compiz
VLC Media Player
Conky
Virtualbox
Unity Tweak Tool
Griffith
Filezilla
Flash Player
EasyTag
Restricted Extras
Clementine
Java Plugin
Chrome
Dropbox 1.6
Steam
Wine 1.7
Video and DVD plugins"

if [ -d /sys/class/power_supply/BAT0 ]
then echo "TLP power management (not ready for Trusty yet, using Saucy package)"
fi

echo 
"Programs uninstalled succesfully:
Rhythmbox
Empathy
Firefox
Totem
Transmission"
