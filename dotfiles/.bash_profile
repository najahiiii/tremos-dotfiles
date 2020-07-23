: "${HOME:=/data/data/com.termux/files/home}"
: "${PREFIX:=/data/data/com.termux/files/usr}"
: "${TMPDIR:=/data/data/com.termux/files/usr/tmp}"
export HOME PREFIX TMPDIR

export LOCAL_PREFIX="$HOME/.local"
export PATH="$LOCAL_PREFIX/bin:$HOME/bin:$PREFIX/bin:$PREFIX/bin/applets:$PATH"
export EDITOR="$PREFIX/bin/nano"

# Required for gpg sign
export GPG_TTY="$(tty)"

# Python c_Cache
export PYTHONPYCACHEPREFIX="$HOME/.cache/cpython/"

# Neoftech
clear && fastfetch

# Aliases
alias scon="ssh -i $HOME/storage/shared/.ssh/najahi ${1}"
alias sfcon="sftp -i $HOME/storage/shared/.ssh/najahi ${1}"

## Load bashrc if shell is interactive.
if [[ "$-" == *"i"* ]]; then
	if [ -r "${HOME}/.bashrc" ]; then
		. "${HOME}"/.bashrc
	fi
fi

# User
export USER="najahi"

# Relog
alias relog="source $HOME/.bash_profile"

# base64 -d
function dec() {
    read -p "Input: " url
    export out=$(echo ${url} | sed 's:.*url=::' | sed 's#&.*##g' | base64 -d)
    echo 'Decrypted URL:' $out
    unset url
}

function decshortid() {
    read -p "Input: " url
    export out=$(echo ${url} | sed 's:.*shortid=::' | sed 's#&.*##g' | base64 -d)
    echo 'Decrypted URL:' $out
    unset url
}
