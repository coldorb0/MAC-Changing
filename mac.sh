#!/bin/sh


change_mac() { 
while true; do
	service network-manager stop 2>/dev/null | echo "......"
	NEW_MAC=$(macchanger -A "$IFACE" | tail -n 1 | sed 's/  //g')
	echo " * $NEW_MAC"
	echo " * if you want stop press CTRL + C"
	service network-manager start 2>/dev/null | echo "......"
	sleep 60
	ifconfig -a | grep "encap:Ethernet" | awk '{print " * " $1, $5}' | grep "$IFACE"
done
}

distro=`awk '{print $1}' /etc/issue`

clear
if [ $(id -u) != "0" ]; then

      echo [!]::[cek root] ;
      sleep 2
      echo [✔]Check User = $USER ;
      echo [✔]Distro = $distro ;
      sleep 1
      echo Hellow harus dalam Mode Root ;
      echo ""
      sleep 1
      exit
else
   echo [!]::[Check Dependencies]: ;
   sleep 1
   echo [✔]::[Distro]: $distro ;
   echo [✔]::[Check User]: $USER ;
fi

#Check Macchanger
which macchanger > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
	echo "[ ✔ ] macchanger........................[ found ]"
	sleep 2
else
	echo ""
	echo "[ X ] macchanger -> Tidak ada                   ]"
	echo "[ ! ] Harus Install dulu bang           ]"
	apt-get install macchanger -y
	sleep 2
fi
ifconfig -a | grep "encap:Ethernet" | awk '{print " * " $1, $5}'
echo -n "Select network interfaces ["
echo -n $(ifconfig -a | grep Ethernet | awk '{print $1}')
read -p "] > " IFACE

change_mac
