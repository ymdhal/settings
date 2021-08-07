#/bin/bash

#-----------------------------------------------------------------------------------------------------
### USR ###
git_name="vymd"
git_mail="ymd.urchino@gmail.com"
clip2file_dir="C:/Users/yuzuh/Dropbox/Org/settings"
chrome_path="/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe"
python_path="/mnt/c/Users/yuzuh/AppData/Local/Programs/Python/Python39/python.exe"

#-----------------------------------------------------------------------------------------------------
### LOG ###
usr_home=$HOME
tmp_dir=$usr_home/tmp
git_dir=$usr_home/git
LOG_OUT=$tmp_dir/stdout_`date "+%Y%m%d_%H%M_%S"`.log
LOG_ERR=$tmp_dir/stderr_`date "+%Y%m%d_%H%M_%S"`.log

mkdir -p $tmp_dir
mkdir -p $git_dir
exec 1> >(tee -a $LOG_OUT)
exec 2> >(tee -a $LOG_ERR)

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
git config --global user.name $git_name
git config --global user.email $git_mail
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
mkdir -p $git_dir/spacemacs
cd $git_dir/spacemacs

git init
git config core.sparsecheckout true
git remote add origin https://github.com/ymdhal/settings.git
echo spacemacs > .git/info/sparse-checkout
git pull origin develop
ln -s $git_dir/spacemacs/spacemacs/init.el $usr_home/.spacemacs.d/init.el

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
echo "#!/bin/sh"         > $tmp_dir/sensible-browser.sh
echo -n "$chrome_path " >> $tmp_dir/sensible-browser.sh
echo '${@/\/mnt/\c/C:}' >> $tmp_dir/sensible-browser.sh

sudo cp $tmp_dir/sensible-browser.sh /usr/bin/sensible-browser
sudo chmod +x /usr/bin/sensible-browser

#-----------------------------------------------------------------------------------------------------
echo "### CAPTURE ###"

git clone https://github.com/ymdhal/pyscript.git -b clip2file_release1.0.1 $git_dir/pyscript
#git clone https://github.com/ymdhal/pyscript.git -b clip2file_release1.0.0 $clip2file_dir/pyscript

echo "#!/bin/sh"                           > $tmp_dir/clip2png.sh
echo -n "$python_path "                   >> $tmp_dir/clip2png.sh
echo -n "$clip2file_dir/clip2file.py -f " >> $tmp_dir/clip2png.sh
echo '$@'                                 >> $tmp_dir/clip2png.sh

echo "#!/bin/sh"                                          > $tmp_dir/snippingtool.sh
echo -n "exec /mnt/c/Windows/System32/SnippingTool.exe " >> $tmp_dir/snippingtool.sh
echo '$@'                                                >> $tmp_dir/snippingtool.sh

#sudo cp $git_dir/pyscript/clip2file.py $clip2file_dir/
md_clip2file_dir=${clip2file_dir/C\:/\/mnt\/c}
sudo cp $git_dir/pyscript/clip2file.py $md_clip2file_dir/

sudo cp $tmp_dir/clip2png.sh /usr/bin/clip2png
sudo cp $tmp_dir/snippingtool.sh /usr/bin/snippingtool
sudo chmod +x /usr/bin/clip2png
sudo chmod +x /usr/bin/snippingtool

#-----------------------------------------------------------------------------------------------------
echo "### PLANTUML ###"
sudo apt-get install -y openjdk-8-jre-headless
sudo apt-get install -y graphviz
mkdir -p $usr_home/.emacs.d/lib
wget http://sourceforge.net/projects/plantuml/files/plantuml.jar/download -O $usr_home/.emacs.d/lib/plantuml.jar

#-----------------------------------------------------------------------------------------------------
echo "### PYTHON ###"
sudo apt-get install -y python3-pip
sudo pip3 install virtualenvwrapper
echo "export WORKON_HOME=$HOME/.virtualenvs"            >> $usr_home/.profile
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> $usr_home/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh"       >> $usr_home/.profile

#-----------------------------------------------------------------------------------------------------
#echo "### MARKDOWN ###"
#sudo apt-get install -y nodejs npm
#sudo npm install n -g
#sudo n stable
#sudo apt-get purge -y nodejs npm
#sudo npm install -g vmd --unsafe-perm-true --allow-root
#sudo apt-get install -y libxss1

#-----------------------------------------------------------------------------------------------------
echo "### SOUND ###"
echo "export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}')" >> $usr_home/.profile

#-----------------------------------------------------------------------------------------------------
echo "### SOURCE ###"
source $usr_home/.profile

#-----------------------------------------------------------------------------------------------------
echo "### GLOBAL PYENV ###"
mkvirtualenv g_py3
#pip install -r $settings_path/requirements.txt
deactivate

#-----------------------------------------------------------------------------------------------------
echo "### TIMEZONE ###"
sudo dpkg-reconfigure tzdata



