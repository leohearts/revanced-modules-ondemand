#!/usr/bin/env bash

set -e

pr() { echo -e "\033[0;32m[+] ${1}\033[0m"; }
ask() {
	local y
	for ((n = 0; n < 3; n++)); do
		pr "$1 [y/n]"
		if read -r y; then
			if [ "$y" = y ]; then
				return 0
			elif [ "$y" = n ]; then
				return 1
			fi
		fi
		pr "Asking again..."
	done
	return 1
}

pr "Ask for storage permission"
until
	yes | termux-setup-storage >/dev/null 2>&1
	ls /sdcard >/dev/null 2>&1
do sleep 1; done
if [ ! -f ~/.rvmm_"$(date '+%Y%m')" ]; then
	pr "Setting up environment..."
	yes "" | pkg update -y && pkg install -y openssl git wget jq openjdk-21 zip
	: >~/.rvmm_"$(date '+%Y%m')"
fi
mkdir -p /sdcard/Download/morphe-modules-ondemand/

if [ ! -d revanced-modules-ondemand ]; then
	pr "Cloning revanced-modules-ondemand."
	git clone https://github.com/leohearts/revanced-modules-ondemand --depth 1
	cd revanced-modules-ondemand
	sed -i '/^enabled.*/d; /^\[.*\]/a enabled = false' config.toml
	grep -q 'revanced-modules-ondemand' ~/.gitconfig 2>/dev/null \
		|| git config --global --add safe.directory ~/revanced-modules-ondemand
else
	cd revanced-modules-ondemand
	pr "Checking for revanced-modules-ondemand updates"
	git fetch
	if git status | grep -q 'is behind\|fatal'; then
		pr "revanced-modules-ondemand already is not synced with upstream."
		pr "Cloning revanced-modules-ondemand. config.toml will be preserved."
		cd ..
		cp -f revanced-modules-ondemand/config.toml .
		rm -rf revanced-modules-ondemand
		git clone https://github.com/leohearts/revanced-modules-ondemand --recurse --depth 1
		mv -f config.toml revanced-modules-ondemand/config.toml
		cd revanced-modules-ondemand
	fi
fi

[ -f ~/storage/downloads/morphe-modules-ondemand/config.toml ] \
	|| cp config.toml ~/storage/downloads/morphe-modules-ondemand/config.toml

if ask "Open config.toml to configure builds?\nAll are disabled by default, you will need to enable at first time building"; then
	am start -a android.intent.action.VIEW -d file:///sdcard/Download/morphe-modules-ondemand/config.toml -t text/plain
fi
until
	ask "Setup is done. Do you want to start building?"
do :; done
cp -f ~/storage/downloads/morphe-modules-ondemand/config.toml config.toml

./build.sh

cd build
PWD=$(pwd)
for op in *; do
	[ "$op" = "*" ] && {
		pr "glob fail"
		exit 1
	}
	mv -f "${PWD}/${op}" ~/storage/downloads/morphe-modules-ondemand/"${op}"
done

pr "Outputs are available in /sdcard/Download/morphe-modules-ondemand folder"
am start -a android.intent.action.VIEW -d file:///sdcard/Download/morphe-modules-ondemand -t resource/folder
sleep 2
am start -a android.intent.action.VIEW -d file:///sdcard/Download/morphe-modules-ondemand -t resource/folder