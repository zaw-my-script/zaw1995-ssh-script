#!/bin/bash

clear
echo "================================="
echo "     ZAW NETMOD VPN INSTALL"
echo "================================="

# Update server
apt update -y
apt upgrade -y

# Install packages
apt install -y openssh-server curl wget cron

systemctl enable ssh
systemctl restart ssh

IP=$(curl -s ifconfig.me)

# Create menu
cat > /usr/bin/menu << 'EOF'
#!/bin/bash

IP=$(curl -s ifconfig.me)

clear
echo "================================="
echo "        ZAW VPS PANEL"
echo "================================="
echo "1. Create SSH Account"
echo "2. Create Trial Account"
echo "3. Delete SSH User"
echo "4. List SSH Users"
echo "5. Restart SSH"
echo "6. Server Info"
echo "0. Exit"
echo "================================="
read -p "Select Menu : " menu

case $menu in

1)
read -p "Username : " user
read -p "Password : " pass
read -p "Expired (days): " days

exp=$(date -d "$days days" +"%Y-%m-%d")

useradd -e $exp -s /bin/false -M $user
echo "$user:$pass" | chpasswd

clear
echo "=============================="
echo " SSH ACCOUNT CREATED"
echo "=============================="
echo "Host : $IP"
echo "Port : 22"
echo "Username : $user"
echo "Password : $pass"
echo "Expire : $exp"
echo "=============================="
;;

2)
user=trial$(tr -dc A-Z0-9 </dev/urandom | head -c4)
pass=123
exp=$(date -d "1 day" +"%Y-%m-%d")

useradd -e $exp -s /bin/false -M $user
echo "$user:$pass" | chpasswd

clear
echo "=============================="
echo " TRIAL ACCOUNT"
echo "=============================="
echo "Host : $IP"
echo "Port : 22"
echo "Username : $user"
echo "Password : $pass"
echo "Expire : $exp"
echo "=============================="
;;

3)
read -p "Input Username : " user
userdel $user
echo "User Deleted"
;;

4)
echo "==== SSH USERS ===="
cut -d: -f1 /etc/passwd
;;

5)
systemctl restart ssh
echo "SSH Restarted"
;;

6)
echo "Server IP : $IP"
echo "SSH Port : 22"
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

clear
echo "================================="
echo " INSTALL COMPLETE"
echo "================================="
echo "Command : menu"
echo "Server IP : $IP"
echo "Port : 22"
echo "================================="
