#!/bin/bash

[[ "$UID" -ne 0 ]] && {
    echo "Script must be run as root."
    exit 1
}

log_file="ip_current.log"
encrypted_log="ip_current.log.gpg"
gpg_pass="Find_me"  # Change this to your actual password

install_packages() {
    local distro
    distro=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    distro=${distro//\"/}

    case "$distro" in
        *"Ubuntu"* | *"Debian"*)
            apt-get update
            apt-get install -y curl tor gnupg
            ;;
        *"Fedora"* | *"CentOS"* | *"Red Hat"* | *"Amazon Linux"*)
            yum update
            yum install -y curl tor gnupg
            ;;
        *"Arch"*)
            pacman -S --noconfirm curl tor gnupg
            ;;
        *)
            echo "Unsupported distribution: $distro. Please install curl and tor manually."
            exit 1
            ;;
    esac
}

if ! command -v curl &>/dev/null || ! command -v tor &>/dev/null; then
    echo "Installing curl and tor"
    install_packages
fi

if ! systemctl --quiet is-active tor.service; then
    echo "Starting Tor service..."
    systemctl start tor.service
fi

get_ip() {
    local url="https://checkip.amazonaws.com"
    ip=$(curl -s -x socks5h://127.0.0.1:9050 "$url" | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
    echo "$ip"
}

encrypt_logs() {
    gpg --batch --yes --passphrase "$gpg_pass" -c "$log_file"
}


change_ip() {
    echo "Restarting Tor service to get a new IP..."
    systemctl restart tor.service
    sleep 5  # Allow Tor to reconnect

    old_ip=$(cat "$current_ip_file" 2>/dev/null || echo "No previous IP")

    # Keep checking until we get a different IP
    while true; do
        sleep 5
        new_ip=$(get_ip)
        if [[ "$new_ip" != "$old_ip" && -n "$new_ip" ]]; then
            break
        fi
        echo "Waiting for a different IP..."
    done

    # Append to log file
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - New IP: $new_ip" >> "$log_file"

    # Encrypt logs
    encrypt_logs
    
    rm -f "$log_file"

    echo -e "\033[34mNew IP address: $new_ip\033[0m"
}

clear
cat << EOF
  ___ ____        ____ _   _    _    _   _  ____ _____ ____  
 |_ _|  _ \      / ___| | | |  / \  | \ | |/ ___| ____|  _ \ 
  | || |_) |____| |   | |_| | / _ \ |  \| | |  _|  _| | |_) |
  | ||  __/_____| |___|  _  |/ ___ \| |\  | |_| | |___|  _ < 
 |_ _|_|         \____|_| |_/_/   \_\_| \_|\____|_____|_| \_\ 
                                                                                                       
EOF

while true; do
    read -rp $'\033[34mEnter time interval in seconds (type 0 for infinite IP changes): \033[0m' interval
    read -rp $'\033[34mEnter number of times to change IP address (type 0 for infinite IP changes): \033[0m' times

    if [ "$interval" -eq "0" ] || [ "$times" -eq "0" ]; then
        echo "Starting infinite IP changes..."
        while true; do
            change_ip
            interval=$(shuf -i 10-20 -n 1)
            sleep "$interval"
        done
    else
        for ((i = 0; i < times; i++)); do
            change_ip
            sleep "$interval"
        done
    fi
done

