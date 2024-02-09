#!/bin/bash

check_install_figlet() {
    if command -v figlet &> /dev/null; then
        echo "Figlet is already installed."
    else
        echo "Figlet is not installed. Installing now..."
        sudo apt-get update
        sudo apt-get install -y figlet
        echo "Figlet has been installed."
    fi
}

# Function to display the banner using figlet
display_banner() {
    echo -e "\e[1;32m"
    figlet -f slant "CyberGuard Sentinel"
    echo -e "\e[0;36m"
    echo -e "\e[0m"
    echo ""
}

# Function to display the menu
display_menu() {
    echo "*********************"
    echo "* Choose an option: * "
    echo "*********************"
    echo "1. Engage Firewall "
    echo "2. Disengage Firewall "
    echo "3. Exit"
}

# Function to start firewall configuration
start_firewall_config() {
    # Reset and disable ufw before configuring rules
    ufw --force reset
    ufw --force disable

    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing

    # Allow SSH, HTTP, HTTPS, and DNS
    ufw allow 22     # SSH
    ufw allow 80     # HTTP
    ufw allow 443    # HTTPS
    ufw allow out 53 # DNS

    # Limit rate of incoming SSH connections
    ufw limit 22/tcp

    # Enable ufw
    ufw --force enable

    # Display the configured rules
    echo "Firewall rules configured:"
    ufw status numbered

    echo "Firewall configuration completed."
}

# Function to disengage the firewall
disengage_firewall() {
    echo "Disengaging the firewall. All traffic will be allowed."
    ufw --force reset
    ufw --force disable
    echo "Firewall disengaged."
}

# Main function to run the script
main() {
    check_install_figlet
    display_banner
    display_menu

    while true; do
        read -p "Enter your choice (1, 2, or 3): " choice

        case $choice in
            1)
                start_firewall_config
                break
                ;;
            2)
                disengage_firewall
                break
                ;;
            3)
                echo "Exiting the script. Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

main



