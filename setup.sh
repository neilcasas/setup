#!/bin/bash

# 1. Update system
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y
if [ $? -ne 0 ]; then
  echo "System update failed. Exiting script."
  exit 1
fi
echo "Finished updating system."

# 2. Install curl
echo "Installing curl..."
sudo apt install curl -y
if [ $? -ne 0 ]; then
  echo "Failed to install curl. Exiting script."
  exit 1
fi
echo "Finished installing curl."

# 3. Install pip (Python's package installer)
echo "Installing pip..."
sudo apt install python3-pip -y
if [ $? -ne 0 ]; then
  echo "Failed to install pip. Exiting script."
  exit 1
fi
echo "Successfully installed pip."

# 4. Install Neovim
echo "Installing Neovim..."
sudo apt install neovim -y
if [ $? -ne 0 ]; then
  echo "Failed to install Neovim. Exiting script."
  exit 1
fi
echo "Finished installing Neovim."

# 5. Install Zsh
echo "Installing Zsh..."
sudo apt install zsh -y
if [ $? -ne 0 ]; then
  echo "Failed to install Zsh. Exiting script."
  exit 1
fi
echo "Finished installing Zsh."

# 6. Install NVM and Node.js
echo "Installing NVM and Node.js..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
if [ $? -ne 0 ]; then
  echo "Failed to install NVM. Exiting script."
  exit 1
fi

# Source the profile to make nvm command available
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install --lts
if [ $? -ne 0 ]; then
  echo "Failed to install Node.js. Exiting script."
  exit 1
fi

nvm use --lts
echo "Successfully installed Node.js."

# 7. Set up git
echo "Setting up Git..."
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

git config --global user.name "Neil Casas"
git config --global user.email "neilalfonzcasas@gmail.com"

echo "Successfully set Git username and email:"
git config --get user.name
git config --get user.email
