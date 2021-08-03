#/bin/bash

#-----------------------------------------------------------------------------------------------------
### path ###
usr_name="vymd"
usr_mail="ymd.urchino@gmail.com"
settings_path="/mnt/c/Users/yuzuh/Dropbox/Org/settings"
chrome_path=""
python_path=""

init_el="spacemacs/init.el"

#-----------------------------------------------------------------------------------------------------
### LOG ###
usr_home=$HOME
tmp_dir=$usr_home/tmp
LOG_OUT=$tmp_dir/stdout.log
LOG_ERR=$tmp_dir/stderr.log

mkdir -p $tmp_dir
exec 1> >(tee -a $LOG_OUT)
exec 2>>$LOG_ERR

#-----------------------------------------------------------------------------------------------------
echo "### APT ###"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git

#-----------------------------------------------------------------------------------------------------
echo "### LANG ###"
sudo apt-get install -y language-pack-ja language-pack-gnome-ja
sudo update-locale LANG=ja_JP.UTF-8
     
#-----------------------------------------------------------------------------------------------------
echo "### VIM ###"
sudo apt-get install -y vim-gtk
echo "set clipboard=unnamed,autoselect" > $usr_home/.vimrc

#-----------------------------------------------------------------------------------------------------
echo "### GIT ###"
git config --global user.name $usr_name
git config --global user.email $usr_mail
git config --global core.filemode false

#-----------------------------------------------------------------------------------------------------
echo "### EMACS ###"
sudo add-apt-repository -y ppa:kelleyk/emacs
sudo apt-get update -y
sudo apt-get install -y emacs27 emacs27-el
sudo apt-get install -y cmigemo
sudo apt-get install -y emacs-mozc-bin
echo "xset -r 49" >> $usr_home/.profile

#-----------------------------------------------------------------------------------------------------
echo "### LATEX ###"
sudo apt-get install -y texlive-lang-japanese
sudo apt-get install -y texlive-fonts-recommended texlive-fonts-extra
sudo apt-get install -y dvipng

#-----------------------------------------------------------------------------------------------------
echo "### SPACEMACS ###"
git clone -b develop https://github.com/syl20bnr/spacemacs $usr_home/.emacs.d
mkdir -p $usr_home/.spacemacs.d
ln -s $settings_path/$init_el $usr_home/.spacemacs.d/init.el


#-----------------------------------------------------------------------------------------------------
echo "### FONT ###"
git clone https://github.com/edihbrandon/RictyDiminished.git $tmp_dir/font
mkdir -p $usr_home/.fonts
cp $tmp_dir/font/*.ttf $usr_home/.fonts
fc-cache -fv
 
#-----------------------------------------------------------------------------------------------------
echo "### WSL ###"
echo -e \
"[interop]
appendWindowsPath = false
" > $tmp_dir/wsl.conf
sudo cp $tmp_dir/wsl.conf /etc/wsl.conf
 
#-----------------------------------------------------------------------------------------------------
echo "### BROWSER ###"
echo -e \
'#!/bin/sh
exec /mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe "${@/\/mnt/\c/C:}"
' > $tmp_dir/sensible-browser.sh
sudo cp $tmp_dir/sensible-browser.sh /usr/bin/sensible-browser
sudo chmod +x /usr/bin/sensible-browser
 
#-----------------------------------------------------------------------------------------------------
echo "### CAPTURE ###"
echo -e \
"#!/bin/sh
exec /mnt/c/Users/yuzuh/AppData/Local/Programs/Python/Python39/python.exe 'C:/Users/yuzuh/Dropbox/Org/dotfiles/clip2file_win.py'
" > $tmp_dir/clip2png.sh

echo -e \
"#!/bin/sh
exec /mnt/c/Windows/System32/SnippingTool.exe '$@'
" > $tmp_dir/snippingtool.sh
     
sudo cp $tmp_dir/clip2png.sh /usr/bin/clip2png
sudo cp $tmp_dir/snippingtool.sh /usr/bin/snippingtool
sudo chmod +x /usr/bin/clip2png
sudo chmod +x /usr/bin/snippingtool
     
#-----------------------------------------------------------------------------------------------------
echo "### PLANTUML ###"
sudo apt-get install -y openjdk-8-jre-headless
sudo apt-get install -y graphviz
mkdir -p $usr_home/.emacs.d/lib
#cp $settings_path/plantuml.jar $usr_home/.emacs.d/lib/
wget http://sourceforge.net/projects/plantuml/files/plantuml.jar/download -O $usr_home/.emacs.d/lib/plantuml.jar

#-----------------------------------------------------------------------------------------------------
echo "### PYTHON ###"
sudo apt-get install -y python3-pip
sudo pip3 install virtualenvwrapper
echo "export WORKON_HOME=$HOME/.virtualenvs" >> $usr_home/.profile
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> $usr_home/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $usr_home/.profile

#-----------------------------------------------------------------------------------------------------
echo "### MARKDOWN ###"
sudo apt-get install -y nodejs npm
sudo npm install n -g
sudo n stable
sudo apt-get purge -y nodejs npm
sudo npm install -g vmd --unsafe-perm-true --allow-root
sudo apt-get install -y libxss1
     
#-----------------------------------------------------------------------------------------------------
echo "### SOUND ###"
echo "export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}')" >> $usr_home/.profile
     
#-----------------------------------------------------------------------------------------------------
echo "### SOURCE ###"
source $usr_home/.profile

#-----------------------------------------------------------------------------------------------------
echo "### GLOBAL PYENV ###"
mkvirtualenv g_py3
pip install -r $settings_path/requirements.txt
deactivate

#-----------------------------------------------------------------------------------------------------
echo "### TIMEZONE ###"
sudo dpkg-reconfigure tzdata



