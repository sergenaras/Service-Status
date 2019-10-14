#!/bin/bash

## Kırmızı  = '\e[1;34m'
## Mavi     = '\e[1;34m'
## Beyaz    = '\e[1;37m'
## Yeşil    = '\e[1;32m'

## servisin durumunu getirir
function get_status { 
	systemctl status $1 | grep Active: | awk -F" " '{ print $2 }' 
}

## servisin adını getirir
function get_name { 
	systemctl status $1 | head -1 | cut -c 3- | sed 's/^.*- //' 
}

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
elif [ $@ == "-s" ]
then
	echo "Buraya servis isimleri gelecek"
else
then
	## Argüman olarak verilen servislerin durumunu özet olarak verir
	for i in $@
	do
		printf "%s \t %s \n" "$(get_name $i) $(get_colored $i)"
	done
fi

## Bu servisler arasında çalışmayan varsa bunlar üzerinde açma işlemi yapar
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




#
#echo $(summary "httpd" "zabbix-server" "zabbix-agent" "mariadb")
