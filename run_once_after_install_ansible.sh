#!/bin/bash

# Function to install Ansible on Fedora
install_on_fedora() {
    sudo dnf install -y ansible || { echo "Failed to install Ansible on Fedora"; exit 1; }
}

# Function to install Ansible on Ubuntu/Debian
install_on_ubuntu() {
    sudo apt update && sudo apt install -y ansible || { echo "Failed to install Ansible on Ubuntu/Debian"; exit 1; }
}

# Function to install Ansible on CentOS/RHEL
install_on_centos() {
    sudo yum install -y epel-release
    sudo yum install -y ansible || { echo "Failed to install Ansible on CentOS/RHEL"; exit 1; }
}

# Function to install Ansible on Arch Linux
install_on_arch() {
    sudo pacman -Syu --noconfirm ansible || { echo "Failed to install Ansible on Arch Linux"; exit 1; }
}

# Function to install Ansible on openSUSE
install_on_opensuse() {
    sudo zypper install -y ansible || { echo "Failed to install Ansible on openSUSE"; exit 1; }
}

# Function to install Ansible on macOS
install_on_mac() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    brew install ansible || { echo "Failed to install Ansible on macOS"; exit 1; }
}

# Check if Ansible is already installed
if command -v ansible >/dev/null 2>&1; then
    echo "Ansible is already installed."
    exit 0
fi

# Detect the OS and install Ansible accordingly
OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/fedora-release ]; then
            install_on_fedora
        elif [ -f /etc/lsb-release ]; then
            install_on_ubuntu
        elif [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
            install_on_centos
        elif [ -f /etc/arch-release ]; then
            install_on_arch
        elif [ -f /etc/os-release ] && grep -q "openSUSE" /etc/os-release; then
            install_on_opensuse
        else
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
    Darwin*)
        install_on_mac
        ;;
    CYGWIN*|MINGW*|MSYS*|Windows*)
        echo "Ansible cannot be installed as a control node on Windows."
        exit 1
        ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

# Check if playbook exists and run it
PLAYBOOK=~/.bootstrap/setup.yaml
if [ ! -f "${PLAYBOOK}" ]; then
    echo "Playbook file not found: ${PLAYBOOK}"
    exit 1
fi

ansible-playbook "${PLAYBOOK}" --become
echo "Ansible installation complete."
