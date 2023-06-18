#!/bin/bash

# Update package list and install necessary tools
sudo apt-get update
sudo apt-get -y install nmap curl git python3-pip jq dnsutils
pip3 install -r requirements.txt



# Install Golang
if ! command -v go &> /dev/null; then
    echo "Go programming language is not found. Installing Go..."

    # Check if apt-get is available
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y golang
    elif command -v yum &> /dev/null; then
        sudo yum install -y golang
    else
        echo "Unable to install Go. Please install Go manually."
        exit 1
    fi

    # Verify Go installation
    if ! command -v go &> /dev/null; then
        echo "Go installation failed. Please install Go manually."
        exit 1
    fi
fi



if ! command -v java &> /dev/null; then
    echo "Java Development Kit (JDK) is not found. Installing JDK..."
    
    # Check if apt-get is available
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y default-jdk
    else
        echo "Unable to install Java. Please install JDK manually."
        exit 1
    fi
    
    # Verify Java installation
    if ! command -v java &> /dev/null; then
        echo "Java installation failed. Please install JDK manually."
        exit 1
    fi
fi



# Gospider
if ! command -v gospider &> /dev/null;then
    echo "Installing Gospider..."
    sudo apt install gospider
fi

#wappalyzer/cli
if ! command -v wappalyzer &>/dev/null; then
    echo "Installing wappalyzer/cli..."
    # Install wappalyzer/cli using npm
    sudo npm install -g wappalyzer-cli
fi

# webanalyze
if ! command -v webanalyze &>/dev/null; then
    echo "Installing webanalyze..."
    # Install webanalyze using apt
    sudo apt update
    sudo apt install -y webanalyze
fi


# hakrawler
if ! command -v hakrawler &> /dev/null;then
    echo "Installing hakrawler..."
    sudo apt install hakrawler
fi



# Install xsrfprobe
if ! command -v xsrfprobe &> /dev/null;then
    echo "Installing xsrfprobe..."
    sudo git clone https://github.com/0xInfection/xsrfprobe.git /opt/xsrfprobe
    sudo ln -s /opt/xsrfprobe/xsrfprobe.py /usr/bin/xsrfprobe
fi

# Install crlfuzz
if ! command -v crlfuzz &> /dev/null;then
    echo "Installing crlfuzz..."
    sudo git clone https://github.com/dwisiswant0/crlfuzz.git /opt/crlfuzz
    sudo ln -s /opt/crlfuzz/crlfuzz.py /usr/bin/crlfuzz
fi

#Install CRLFsuite
#Installed in requirements

# Install Corsy
if ! command -v corsy &> /dev/null;then
    echo "Installing Corsy..."
    sudo git clone https://github.com/s0md3v/Corsy.git /opt/Corsy
    sudo chmod +x /opt/Corsy/corsy.py
    sudo ln -s /opt/Corsy/corsy.py /usr/bin/corsy
fi

# Install CORScanner
#installed in requirements

# Install Dirsearch
if ! command -v dirsearch &> /dev/null;then
    echo "Installing Dirsearch..."
    sudo apt install dirsearch
fi
# Install gobuster
if ! command -v gobuster  &> /dev/null;then
   sudo apt install gobuster
fi
# Install httpx
if ! command -v httpx &> /dev/null;then
    echo "Installing httpx..."
    sudo GO111MODULE=on go get -u -v github.com/projectdiscovery/httpx/cmd/httpx
fi

# Install nuclei
if ! command -v nuclei &> /dev/null;then
    echo "Installing nuclei..."
    sudo GO111MODULE=on go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
fi

# Install naabu
if ! command -v naabu &> /dev/null;then
    echo "Installing naabu..."
    sudo GO111MODULE=on go get -u -v github.com/projectdiscovery/naabu/v2/cmd/naabu
fi

# Install assetfinder
if ! command -v assetfinder &> /dev/null;then
    echo "Installing assetfinder..."
    sudo apt install assetfinder
fi

# Install amass
if ! command -v amass &> /dev/null;then
    echo "Installing amass..."
    sudo apt-get install -y snapd
    sudo snap install amass
fi

# Install subfinder
if ! command -v subfinder &> /dev/null;then
    echo "Installing subfinder..."
    sudo apt install subfinder
fi

# Install massdns
if ! command -v massdns &> /dev/null;then
    sudo apt install massdns
fi

# Install shuffledns
if ! command -v shuffledns &> /dev/null;then
    echo "Installing shuffledns..."
    sudo GO111MODULE=on go get -u -v github.com/projectdiscovery/shuffledns/cmd/shuffledns
fi

# Install dnsx
if ! command -v dnsx &> /dev/null;then
    echo "Installing dnsx..."
    sudo GO111MODULE=on go get -u -v github.com/projectdiscovery/dnsx/cmd/dnsx
fi
##############################################################################
change_directory() {
  ( cd "$1" && "$2" )
}
# Bash Tools Installation
if ! command -v XSStrike &> /dev/null;then
  echo "Installing XSStrike..."
  sudo git clone https://github.com/s0md3v/XSStrike.git /opt/XSStrike
  sudo ln -s /opt/XSStrike/xsstrike.py /usr/bin/XSStrike
fi

if ! command -v dalfox &> /dev/null;then
  echo "Installing dalfox..."
  sudo git clone https://github.com/hahwul/dalfox.git /opt/dalfox
  sudo ln -s /opt/dalfox/dalfox /usr/bin/dalfox
fi

if ! command -v NoSQLMap &> /dev/null;then
  echo "Installing NoSQLMap..."
  sudo git clone https://github.com/codingo/NoSQLMap.git /opt/NoSQLMap
  sudo ln -s /opt/NoSQLMap/NoSQLMap.py /usr/bin/NoSQLMap
fi

sudo apt install -y gobuster

if ! command -v SSRFmap &> /dev/null;then
  echo "Installing SSRFmap..."
  sudo git clone https://github.com/swisskyrepo/SSRFmap.git /opt/SSRFmap
  sudo ln -s /opt/SSRFmap/ssrfmap.py /usr/bin/SSRFmap
fi

if ! command -v Gopherus &> /dev/null;then
  echo "Installing Gopherus..."
  sudo git clone https://github.com/tarunkant/Gopherus.git /opt/Gopherus
  sudo ln -s /opt/Gopherus/gopherus.py /usr/bin/Gopherus
fi

if ! command -v ground-control &> /dev/null;then
  echo "Installing ground-control..."
  sudo git clone https://github.com/jobertabma/ground-control.git /opt/ground-control
  sudo ln -s /opt/ground-control/ground-control /usr/bin/ground-control
fi

if ! command -v feroxbuster &> /dev/null;then
  echo "Installing feroxbuster..."
  curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash -s $HOME/.local/bin
fi

# Metasploit Framework
# Burp Suite
# OWASP ZAP

if ! command -v nikto &> /dev/null;then
  echo "Installing nikto..."
  sudo git clone https://github.com/sullo/nikto.git /opt/nikto
  sudo ln -s /opt/nikto/nikto.pl /usr/bin/nikto
fi

# Nessus
#need to be added

# OpenVAS: Follow the installation guide at https://www.openvas.org/download.html
#need to be added

# Sublist3r
if ! command -v Sublist3r &> /dev/null;then
  echo "Installing Sublist3r..."
  sudo git clone https://github.com/aboul3la/Sublist3r.git /opt/Sublist3r
  sudo ln -s /opt/Sublist3r/sublist3r.py /usr/bin/Sublist3r
fi

# Amass: Follow the installation guide at https://github.com/OWASP/Amass

# Findomain
if ! command -v LinkFinder &> /dev/null;then
  echo "Installing LinkFinder..."
  sudo git clone https://github.com/GerbenJavado/LinkFinder.git /opt/LinkFinder
  sudo ln -s /opt/LinkFinder/linkfinder.py /usr/bin/LinkFinder
fi
# Install dnsenum
if ! command -v subfinder &> /dev/null;then
    echo "Installing dnsenum..."
    sudo apt install dnsenum
fi









echo "Installation complete!"
exit 0