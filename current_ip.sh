#!/bin/bash

# Define encrypted and decrypted log file paths
encrypted_log="ip_current.log.gpg"
decrypted_log="current_ip.log"
gpg_pass="Find_me"  # Change this to your actual password

# Check if encrypted log file exists
if [[ ! -f "$encrypted_log" ]]; then
    echo "❌ Encrypted log file not found: $encrypted_log"
    exit 1
fi

# Decrypt and save logs to a file
echo "🔓 Decrypting log file..."
gpg --batch --yes --passphrase "$gpg_pass" -d "$encrypted_log" > "$decrypted_log"

# Verify if decryption was successful
if [[ $? -eq 0 ]]; then
    echo "✅ Decryption completed. Logs saved to: $decrypted_log"
else
    echo "❌ Decryption failed."
    exit 1
fi

