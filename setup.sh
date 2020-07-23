#!/data/data/com.termux/files/usr/bin/bash

set -e

SCRIPT_DIR=$(dirname "$(realpath "$0")")
HOME="/data/data/com.termux/files/home"
PREFIX="/data/data/com.termux/files/usr"

if [ "$(uname -o)" != "Android" ]; then
	echo -e "This script must be executed within Termux !"
	exit 1
fi

echo -e "Installing configuration files and scripts will"
echo -e "remove existing ones. Directories like '~/.config'"
echo -e "or '~/.local' will be completely erased and replaced."
read -re -p "Do you want to proceed ? (y/n): " CHOICE

if [[ "$CHOICE" != [Yy] ]]; then
	echo -e "Aborting !"
	exit 1
fi

if [ -f "$SCRIPT_DIR/packages.txt" ]; then
	echo -e "[@] Installing necessary packages:"
	pkg install -y $(cat "$SCRIPT_DIR/packages.txt" | grep -vP '^(?:\s+)?#')
fi

# Just replace objects in $HOME.
if [ -d "$SCRIPT_DIR/dotfiles" ]; then
	echo -e "[@] Writing dotfiles for \$HOME:"
	while IFS= read -r -d '' file; do
		dst_file_path="${HOME}/$(basename "$file")"

		if [ "$(basename "$file")" = ".gnupg" ] && [ -d "$dst_file_path" ]; then
			echo -e "Not overwriting existing '.gnupg' directory..."
			continue
		fi

		if [ -d "$file" ]; then
			echo -e "Installing directory '\${HOME}/$(basename "$file")'..."
		else
			echo -e "Installing file '\${HOME}/$(basename "$file")'..."
		fi

		rm -rf "$dst_file_path"
		cp -a "$file" "$dst_file_path"
	done < <(find "$SCRIPT_DIR/dotfiles" -mindepth 1 -maxdepth 1 -print0)
	unset file dst_file_path
fi

# Files in $PREFIX should be handled carefully.
if [ -d "$SCRIPT_DIR/prefix-files" ]; then
	echo -e "[@] Writing dotfiles for \$PREFIX:"
	cd "$SCRIPT_DIR/prefix-files" && {
		while IFS= read -r -d '' file; do
			file=$(echo "$file" | sed 's/^\.\///')
			echo -e "Installing file '\${PREFIX}/${file}'..."
			mkdir -p "${PREFIX}/$(dirname "$file")"
			cp -f "$file" "${PREFIX}/${file}"
		done < <(find . -type f -print0)
		unset file dst_file_path
	}
fi

# Request permission for shared storage access.
# termux-setup-storage

# Final touch.
echo -e "Done!"
for i in {10..1}; do
	echo -n "$i." && sleep 1;
done
am stopservice com.termux/.app.TermuxService
