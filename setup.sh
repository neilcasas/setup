#!/bin/bash
# Ask if barebones install or include GUI apps

echo "Welcome to your install script."
echo "Include GUI prerequisites such as flatpak, ttfs? (Y/N)"
read isgui

echo "Include GUI development apps such as VSCode? (Y/N)"
read isdev

# Update system
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y
if [ $? -ne 0 ]; then
  echo "System update failed. Exiting script."
  exit 1
fi
echo "Finished updating system."

# Installing curl
echo "Installing curl..."
sudo apt install curl -y
if [ $? -ne 0 ]; then
  echo "Failed to install curl. Exiting script."
  exit 1
fi
echo "Finished installing curl."

# Install pip (Python's package installer)
echo "Installing pip..."
sudo apt install python3-pip -y
if [ $? -ne 0 ]; then
  echo "Failed to install pip. Exiting script."
  exit 1
fi
echo "Successfully installed pip."


# Install NVM and Node.js
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

# Set up git
echo "Setting up Git..."
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

git config --global user.name "Neil Casas"
git config --global user.email "neilalfonzcasas@gmail.com"

echo "Successfully set Git username and email:"
git config --get user.name
git config --get user.email

# Install Neovim
echo "Installing Neovim..."
sudo apt install neovim -y
if [ $? -ne 0 ]; then
  echo "Failed to install Neovim. Exiting script."
fi
echo "Finished installing Neovim."

# Install Zsh
echo "Installing Zsh..."
sudo apt install zsh -y
if [ $? -ne 0 ]; then
  echo "Failed to install Zsh. Exiting script."
  exit 1
fi
echo "Finished installing Zsh."

if [[ "$isgui" == "Y" ]] || [[ "$isgui" == "y" ]]; then

	# Installing flatpak
	echo "Installing flatpak.."
	sudo add-apt-repository ppa:flatpak/stable
	sudo apt update 
	sudo apt install flatpak -y
	
	if [ $? -ne 0]; then
   	echo "Failed to install flatpak"
   	exit 1
	fi
	echo "Successfully installed flatpak."
	
	echo "Adding flatpak support to software center"
	sudo apt install gnome-software-plugin-flatpak -y
	
	if [ $? -ne 0 ]; then
   		echo "Failed to install flatpak support for software center"
   		exit 1
	fi
	echo "Successfully added flatpak support to software center"
	
	echo "Adding flathub repo..."
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	if [ $? -ne 0 ]; then
		echo "Failed to add flathub repo"
		exit 1;
	fi
	echo "Successfully added flathub repo."


	# Getting AppImage support 
	echo "Installing libfuse2t64 for AppImage support..."
	sudo apt install libfuse2t64 -y
	if [ $? - ne 0 ]; then
   		echo "Failed to install AppImage support"
   		exit 1
	fi
	
	echo "Finished installing libfuse2t64"

	# Installing media codecs and Microsoft TrueType Fonts
	echo "Installing media codecs and Microsoft TrueType fonts..."
	sudo apt install ubuntu-restricted-extras -y
	if [ $? -ne 0 ]; then
   		echo "Failed to install media codecs and TrueType fonts"
   		exit 1 
	fi
	echo "Finished installing ubuntu-restricted-extras"

	# Installing gdebi
	echo "Installing gdebi..."
	sudo apt install gdebi -y
	if [ $? -ne 0 ]; then
		echo "Failed to install gdebi"
		exit 1
	fi
	echo "Finished installing gdebi"

 	# Installing VLC media player
  	echo "Installing VLC media player"
   	sudo apt install vlc -y
    
    	if [ $? -ne 0 ]; then
     		echo "Failed to install VLC Media player"
       		exit 1
	fi
	
 	# Installing Brave Browser
  	echo "Installing Brave Browser"
   	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

 	if [ $? -ne 0 ]; then
  		echo "Failed to add Brave Browser repo"
    		exit 1
      	fi
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

	sudo apt update
 
 	if [ $? -ne 0 ]; then
  		echo "Failed to download Brave Browser"
    		exit 1
      	fi

	sudo apt install brave-browser -y
 
 	if [ $? -ne 0 ]; then
  		echo "Failed to download Brave Browser"
    		exit 1
      	fi

fi

if [[ "$isdev" == "Y" ]] || [[ "$isdev" == "y" ]]; then 
	# Installing VSCode for Debian/Ubuntu-based distros
	echo "Installing VSCode..."
	echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
	sudo apt-get install wget gpg
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
	rm -f packages.microsoft.gpg
	sudo apt install apt-transport-https
	sudo apt update -y
	sudo apt install code -y # or code-insiders

fi
