#!/bin/bash
Permission() {
user=`whoami`
if [[ $user == 'root' ]]; then
	echo ""
else
	printf "Please run as root\n"
	exit
fi
}

about() {
printf "Create By     		        > 	IHA\nWritten Language	        > 	shell\nOperation System		> 	Linux\nGitHub 				>	https://github.com/IHA-arch\n"
}

warn() {
printf "When restore the backup put this script and the backup folder in the root directory, otherwise the backup is not restored completely\n"
}

Backup() {
rm -rf backup
mkdir backup
dic=`pwd`
printf "\e[0;31mStarting backup...\e[0m\n"
tar -czvf backup.tar.gz /home /etc /var /srv /root /usr
mv backup.tar.gz backup
dpkg --get-selections > backup/packages.log
cat /etc/apt/sources.list > backup/sources.list
apt-key exportall > backup/repositories.keys
printf "\e[0;31mSaved at $dic/backup\e[0m\n"
sleep 0.5
printf "\e[6;36mBackup complete\e[0m\n"
}

Restore() {
asdf=`pwd`
if [[ $asdf == '/' ]]; then
	printf ""
else
	warn
	printf "You are not root directory\n"
	printf "Your present working directory is `pwd`\n"
	exit
fi
if [[ -d "backup" ]]; then
	echo ""
else
	printf "Backup file not found\n"
	printf "The backup file and the script must be in the same directory\n"
	exit
fi
printf "\e[0;31mStarting restore...\e[0m\n"
dic=`pwd`
cp backup/backup.tar.gz $dic
tar -xzvf backup.tar.gz
cp backup/sources.list /etc/apt/sources.list
apt-key add backup/repositories.keys
apt-get update
apt-get install dselect
dselect update
dpkg --clear-selections
dpkg --set-selections < backup/packages.log
apt-get dselect-upgrade -y
rm backup.tar.gz
printf "\e[6;36mrestore complete\e[0m\n"
}


Permission
warn
printf "1	Backup\n"
printf "2	Restore\n"
printf "3 	Tool creator information\n"

read -p "Choice:" user_input
if [[ $user_input == 1 ]]; then
	Backup
elif [[ $user_input == 2 ]]; then
	Restore
elif [[ $user_input == 3 ]]; then
	about
else
	printf "choose only 1 or 2\n"
fi

