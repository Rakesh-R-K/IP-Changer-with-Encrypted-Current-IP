IP Changer with Encrypted Current IP

📌 Overview

This Bash script automates IP address changes using the Tor network and securely encrypts the current IP for added privacy. It allows users to set change intervals, supports multiple Linux distributions, and includes a decryption script to retrieve the current IP.

✨ Features

🔄 Automated IP Change: Changes IP address dynamically through the Tor network.

🔒 Encrypted Current IP: The currently assigned IP is securely encrypted using GPG.

🎯 Customizable: Allows users to specify time intervals and repetitions for IP changes.

🛠 Multi-Distro Support: Works on Ubuntu, Debian, Fedora, CentOS, Red Hat, Arch, and Amazon Linux.

🚀 Installation

Prerequisites

Ensure you have bash, curl, tor, and gpg installed.
If not, the script will install them automatically.

Clone Repository

git clone https://github.com/Rakesh-R-K/IP-Changer-with-Encrypted-Current-IP.git
cd ip-changer
chmod +x ip_changer.sh current_ip.sh

🛠 Usage

Start the IP Changer

sudo ./ip_changer.sh

Follow the prompts to set the time interval and number of IP changes.

Retrieve Current IP (Decrypted)

./current_ip.sh

This will decrypt and display the stored current IP.

🔐 Encryption & Decryption

Encryption happens automatically after each IP change.

Decryption is handled by current_ip.sh, which retrieves the latest encrypted IP.

📌 Source

This script was inspired by gr33n37's IP Changer.

⚠️ Disclaimer

This tool is for educational and privacy-related purposes only. Misuse of this tool is strictly prohibited.

📜 License

This project is open-source under the MIT License.

🤝 Contributing

Feel free to fork this project and submit pull requests!
