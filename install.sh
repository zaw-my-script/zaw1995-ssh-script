#!/bin/bash

clear
echo "================================="
echo "   NetMod VPN SSH Panel Install"
echo "================================="

# Update
apt update -y
apt upgrade -y

# Install SSH
apt install -y openssh-server
systemctl enable ssh
systemctl start ssh

# Install tools
apt install -y curl wget cron

# Get IP
IP=$(curl -s ifconfig.me)

# Create menu
cat > /usr/bin/menu << END
#!/bin/bash
clear
echo "=============================="
echo "      NETMOD VPN PANEL"
echo "=============================="
echo "1. Create SSH Account"
echo "2. Create Trial Account"
echo "3. Delete User"
echo "4. Check Login User"
echo "5. Restart SSH"
echo "0. Exit"
echo "=============================="
read -p "Select Menu : " menu

case \$menu in
1)
read -p "Username : " user
read -p "Password : " pass
read -p "Expired (days): " days
useradd -e \$(date -d "\$days days" +"%Y-%m-%d") -s /bin/false -M \$user
echo "\$user:\$pass" | chpasswd

echo "=============================="
echo "SSH ACCOUNT CREATED"
echo "Host : $IP"
echo "Port : 22"
echo "Username : \$user"
echo "Password : \$pass"
echo "=============================="
;;

2)
user=trial\$(tr -dc A-Z0-9 </dev/urandom | head -c4)
pass=123
useradd -e \$(date -d "1 day" +"%Y-%m-%d") -s /bin/false -M \$user
echo "\$user:\$pass" | chpasswd

echo "=============================="
echo "TRIAL ACCOUNT"
echo "Host : $IP"
echo "Port : 22"
echo "Username : \$user"
echo "Password : \$pass"
echo "=============================="
;;

3)
read -p "Username : " user
userdel \$user
echo "User Deleted"
;;

4)
who
;;

5)
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
END

chmod +x /usr/bin/menu

clear
echo "================================="
echo "INSTALL COMPLETE"
echo "================================="
echo "Command : menu"
echo "Server IP : $IP"
echo "SSH Port : 22"
echo "================================="
