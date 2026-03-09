#!/bin/bash

clear
echo "================================"
echo "        ZAW VPN PANEL"
echo "================================"

apt update -y
apt install -y nginx curl wget

systemctl enable nginx
systemctl start nginx

cat > /usr/bin/menu << 'EOF'
#!/bin/bash
clear

echo "================================"
echo "        ZAW VPN MANAGER"
echo "================================"

echo "01 SSH / WS MENU"
echo "02 VMESS MENU"
echo "03 VLESS MENU"
echo "04 TROJAN MENU"
echo "05 SOCKS MENU"
echo "06 ZIVPN MENU"

echo "---------------"
echo "07 DNS PANEL"
echo "08 DOMAIN PANEL"
echo "09 IPV6 PANEL"
echo "10 VPS STATUS"

echo "88 REBOOT VPS"
echo "00 EXIT"

read -p "Select Menu : " menu

case $menu in

1)
echo "SSH MENU"
;;

2)
echo "VMESS MENU"
;;

3)
echo "VLESS MENU"
;;

4)
echo "TROJAN MENU"
;;

5)
echo "SOCKS MENU"
;;

6)
echo "ZIVPN MENU"
;;

88)
reboot
;;

0)
exit
;;

*)
echo "Wrong Input"
;;

esac
EOF

chmod +x /usr/bin/menu

echo "Install Complete"
echo "Type : menu"
