#!/bin/bash

# Root Check
if [ "$(id -u)" != "0" ]; then
echo "Please run as root"
exit 1
fi

clear
echo "===================================="
echo "      ZAW SSH MANAGER INSTALL"
echo "===================================="

sleep 2

# Update System
apt update -y
apt upgrade -y

# Install Basic Packages
apt install wget curl figlet screen unzip -y

clear
figlet "ZAW VPN"

echo "Installing Required Packages..."
sleep 2

apt install python3 python3-pip -y
apt install net-tools -y
apt install socat -y
apt install cron -y

clear
echo "Setting Firewall"

ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8080/tcp

clear
echo "Creating Menu System..."

cat <<EOF >/usr/bin/menu
#!/bin/bash
clear
echo "=============================="
echo "       ZAW VPS MANAGER"
echo "=============================="
echo "1. Create SSH User"
echo "2. Delete SSH User"
echo "3. List Users"
echo "4. Restart SSH"
echo "0. Exit"
echo "=============================="
read -p "Select: " option

case \$option in

1)
read -p "Username: " user
read -p "Password: " pass
useradd -e \$(date -d "+7 days" +"%Y-%m-%d") -s /bin/false -M \$user
echo "\$user:\$pass" | chpasswd
echo "User Created"
;;

2)
read -p "Username: " user
userdel \$user
echo "User Deleted"
;;

3)
cut -d: -f1 /etc/passwd
;;

4)
systemctl restart ssh
echo "SSH Restarted"
;;

0)
exit
;;

*)
echo "Invalid"
;;

esac
EOF

chmod +x /usr/bin/menu

clear
echo "===================================="
echo " INSTALL COMPLETE"
echo "===================================="
echo ""
echo "Main Command: menu"
echo ""
