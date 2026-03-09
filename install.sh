#!/bin/bash

# Root Check
if [ "$(id -u)" != "0" ]; then
echo "Please run as root"
exit 1
fi

clear
echo "================================="
echo "      ZAW VPS INSTALLER"
echo "================================="
sleep 2

# Update system
apt update -y
apt upgrade -y

# Install required packages
apt install wget curl figlet net-tools nano screen -y

clear
figlet "ZAW VPS"

echo "Installing SSH Manager..."
sleep 2

# Create menu system
cat <<EOF > /usr/bin/menu
#!/bin/bash
clear
echo "=============================="
echo "        ZAW VPS MANAGER"
echo "=============================="
echo "1. Create SSH User"
echo "2. Delete SSH User"
echo "3. List SSH Users"
echo "4. Restart SSH"
echo "5. Server Info"
echo "0. Exit"
echo "=============================="
read -p "Select: " option

case \$option in

1)
read -p "Username: " user
read -p "Password: " pass
useradd -e \$(date -d "+7 days" +"%Y-%m-%d") -s /bin/false -M \$user
echo "\$user:\$pass" | chpasswd
echo "User Created Successfully"
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

5)
echo "Server IP:"
curl ifconfig.me
uptime
;;

0)
exit
;;

*)
echo "Invalid Option"
;;

esac
EOF

chmod +x /usr/bin/menu

clear
echo "================================="
echo " INSTALL COMPLETE"
echo "================================="
echo ""
echo "Command: menu"
echo ""
