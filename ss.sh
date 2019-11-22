#!/bin/bash

## Kırmızı  = '\e[1;34m'
## Mavi     = '\e[1;34m'
## Beyaz    = '\e[1;37m'
## Yeşil    = '\e[1;32m'

function get_status { systemctl status $1 | grep Active: | awk -F" " '{ print $2 }' }

function get_name { systemctl status $1 | head -1 | cut -c 3- | sed 's/^.*- //' }

function get_colored {
	if [ $(get_status $1) == "active" ]
	then
		echo -e "\e[1;32m" $(get_status $1) "\e[1;37m"
	elif [ $(get_status $1) == "inactive" ]
	then
		echo -e "\e[1;31m" $(get_status $1) "\e[1;37m"
	fi
}


if [ -n $@ ]
then
	echo "Merhaba, bu betiğin çalışması için parametre olarak durumunu öğrenmek istediğiniz servislerin isimlerini girmlisiniz"
else
then
	for i in $@
	do
		printf "%s \t %s \n" "$(get_name $i) $(get_colored $i)"
	done
fi

for j in $@
do
	durum=$(get_status $j)
	if [ $durum == "inactive" ]
	then
		echo "$(get_name $j) servisi başlatılsın mı? $var_yesno" 
		read var_yesno
		if [ $var_yesno == "y" ]
		then
			systemctl start $j
		fi
	fi
done
