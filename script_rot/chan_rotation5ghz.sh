#!/bin/bash
# -*- ENCODING: UTF-8 -*-

iface1='wlan0'
iface2='wlan1'
iface3='wlan2'
iface4='wlan3'

echo "parando servicio dhcpcd..."
service dhcpcd stop
sleep 10
echo "bajando interfaces wifi $iface1, $iface2, $iface3 y $iface4"
ip link set $iface1 down
ip link set $iface2 down
ip link set $iface3 down
ip link set $iface4 down
sleep 2
echo "cambiando interfaces wifi $iface1, $iface2, $iface3 y $iface4 a modo monitor..."
iw dev $iface1 set type monitor
iw dev $iface2 set type monitor
iw dev $iface3 set type monitor
iw dev $iface4 set type monitor
sleep 2
echo "levantando interfaz wifi $iface1, $iface2, $iface3 y $iface4..."
ip link set $iface1 up
ip link set $iface2 up
ip link set $iface3 up
ip link set $iface4 up
sleep 2
echo "reiniciando servicio dhcpcd..."
service dhcpcd restart
sleep 4

echo "comenzando rotación de canales wifi..."
chans24_1=(1 2 3 4 5 6 7)
chans24_2=(8 9 10 11 12 13)
chans5_1=(36 40 44 48 52 56 60 64 100)
chans5_2=(104 108 112 116 120 124 128 132 136 140)
count24_1=0
count24_2=0
count5_1=0
count5_2=0
while [ true ]
do
	iwconfig $iface1 channel ${chans24_1[$count24_1]}
	iwconfig $iface2 channel ${chans24_2[$count24_2]}
	iwconfig $iface3 channel ${chans5_1[$count5_1]}
	iwconfig $iface4 channel ${chans5_2[$count5_2]}
	echo "canal de $iface1(canales 1-7 de 2.4Ghz): ${chans24_1[$count24_1]}"
	echo "canal de $iface2(canales 8-13 de 2.4Ghz): ${chans24_2[$count24_2]}"
	echo "canal de $iface3(canales 36-100 de 5Ghz): ${chans5_1[$count5_1]}"
	echo "canal de $iface4(canales 104-140 de 5Ghz): ${chans5_2[$count5_2]}"
	((count24_1++))
	((count24_2++))
	((count5_1++))
	((count5_2++))

	if [ $count24_1 -gt 6 ]
	then
		count24_1=0
	fi

	if [ $count24_2 -gt 5 ]
	then
		count24_2=0
	fi

	if [ $count5_1 -gt 8 ]
	then
		count5_1=0
	fi

	if [ $count5_2 -gt 9 ]
	then
		count5_2=0
	fi

	sleep 3
done
