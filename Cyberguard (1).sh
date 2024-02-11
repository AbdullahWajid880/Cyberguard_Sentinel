#!/bin/bash
#ABDULLAH WAJID 024 SECTION A
LOG_FILE="Cyberguard.log" #this will make a log file in the directory where our script is present  for ease we can give a path

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
    log_message "Starting firewall configuration."
    # Reset and disable ufw before configuring rules
    ufw --force reset
    ufw --force disable

    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing

    # Allow SSH, HTTP, HTTPS, and DNS
    ufw allow 22     # SSH These are all the ports which can be customised according to the need :)
    ufw allow 80     # HTTP
    ufw allow 443    # HTTPS
    ufw allow out 53 # DNS

    # Limit rate of incoming SSH connections
    ufw limit 22/tcp

    # Enable ufw
    ufw --force enable

    # Display the configured rules
    log_message "Firewall rules configured:"
    ufw status numbered >> "$LOG_FILE"

    log_message "Firewall configuration completed."
}

# Function to disengage the firewall
disengage_firewall() {
    log_message "Disengaging the firewall. All traffic will be allowed."
    ufw --force reset
    ufw --force disable
    log_message "Firewall disengaged."
}

# Function to log messages
log_message() {
    timestamp=$(date +"%Y-%m-%d %T")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Function to validate user login
validate_login() {
    read -s -p "Enter password: " password
    echo ""
 
    if [ "$password" != "kali" ]; then
        echo "Incorrect password. Exiting."
        exit 1
    fi
}

# Main function to run the script
main() {
    check_install_figlet
    display_banner
    display_menu

    while true; do
        read -p "Enter your choice (1, 2, or 3): " choice

        case $choice in
            1) #if we want to run the script untill we want we just need to remove the break argument form the case statement
                validate_login
                start_firewall_config
                break
                ;;
            2)
                validate_login
                disengage_firewall
                break  #
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
