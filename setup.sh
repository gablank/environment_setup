#!/usr/bin/env sh

#APT_INSTALLABLES="git g++ gcc cmake tmux htop zsh"
APT_INSTALLABLES="git tmux htop zsh"

echo "Installing $APT_INSTALLABLES using apt-get..."

sudo apt-get install -y $APT_INSTALLABLES

echo "Installing oh-my-zsh. You will be prompted for your password to change the default shell to zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


echo "Installing zsh theme"
if [ ! -d ".oh-my-zsh/themes/" ]; then
    echo ".oh-my-zsh/themes/ does not exist!"
    exit 1
fi

cp awenhaug.zsh-theme .oh-my-zsh/themes/

if [ ! -f ".zshrc" ]; then
    echo ".zshrc does not exist!"
    exit 1
fi

cat .zshrc | sed s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"awenhaug\"/ > .zshrc
