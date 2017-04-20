#!/usr/bin/env sh

# === CONFIG ===

APT_INSTALLABLES=(git g++ gcc cmake tmux htop zsh)

# === END CONFIG ===

DIRNAME=$(dirname "$0")
cd "$DIRNAME"
ROOT_DIR=$(pwd)

is_installed() {
    which $1 > /dev/null
    echo $?
}

APT_INSTALLABLES_STRING=""
for var in "${APT_INSTALLABLES[@]}"
do
    if [ $(is_installed $var) ]; then
        echo "$var is already installed, skipping"
    else
        echo "$var is not installed, installing..."
        APT_INSTALLABLES_STRING="$var $APT_INSTALLABLES_STRING"
    fi
done

if [ "$APT_INSTALLABLES_STRING" != "" ]; then
    echo "Installing $APT_INSTALLABLES_STRING using apt-get..."
    sudo apt-get install -y "$APT_INSTALLABLES"
fi

for var in "${APT_INSTALLABLES[@]}"
do
    if [ ! $(is_installed $var) ]; then
        echo "Unable to install $var!"
        exit 1
    fi
done

echo "Installing oh-my-zsh. You will be prompted for your password to change the default shell to zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing zsh theme"
if [ ! -d "$HOME/.oh-my-zsh/themes/" ]; then
    echo "$HOME/.oh-my-zsh/themes/ does not exist!"
    exit 1
fi

echo "$(curl -fsSL -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/gablank/environment_setup/master/awenhaug.zsh-theme)" > "$HOME/.oh-my-zsh/themes/awenhaug.zsh-theme"

if [ ! -f "$HOME/.zshrc" ]; then
    echo "$HOME/.zshrc does not exist!"
    exit 1
fi

TEMPFILE="$ROOT_DIR/zshrctmp"
cat "$HOME/.zshrc" | sed s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"awenhaug\"/ > "$TEMPFILE" && mv "$TEMPFILE" "$HOME/.zshrc"

if [ ! $? ]; then
    echo "Something went wrong while trying to change the zsh theme."
    echo "You can do this manually by changing the line ZSH_THEME in .zshrc"
    exit 1
fi
