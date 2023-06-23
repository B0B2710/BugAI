#!/bin/bash

# Update package list and install necessary tools
sudo apt-get update
sudo apt-get -y install nmap curl git python3-pip jq dnsutils
pip3 install -r requirements.txt

#installed in requirements :CORScanner,paramspider,xsrfprobe,CRLFsuite



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







# Install crlfuzz
if ! command -v crlfuzz &> /dev/null;then
    echo "Installing crlfuzz..."
    sudo git clone https://github.com/dwisiswant0/crlfuzz.git /opt/crlfuzz
    sudo ln -s /opt/crlfuzz/crlfuzz.py /usr/bin/crlfuzz
fi

# Install Corsy
if ! command -v corsy &> /dev/null;then
    echo "Installing Corsy..."
    sudo git clone https://github.com/s0md3v/Corsy.git /opt/Corsy
    sudo chmod +x /opt/Corsy/corsy.py
    sudo ln -s /opt/Corsy/corsy.py /usr/bin/corsy
fi





#getallurls (gau)
go install github.com/lc/gau/v2/cmd/gau@latest

#getallurls (headi)
go install github.com/mlcsec/headi@latest


echo "Installing ParamSpider..."
git clone https://github.com/devanshbatham/ParamSpider /opt/ParamSpider

echo "Installing Injectus..."
git clone https://github.com/dubs3c/Injectus.git /opt/Injectus



echo "Installing gf..."
go get -u github.com/tomnomnom/gf



sudo apt install subjack
sudo apt install hakrawler
sudo apt install gospider
sudo apt install wfuzz
sudo apt install ffuf
sudo apt install commix
sudo apt install dotdotpwn
sudo apt install sqlmap
sudo apt install dnsenum
sudo apt install arjun
sudo apt install dirsearch
sudo apt install dirsearch
sudo apt install gobuster
sudo apt install assetfinder
sudo apt install massdns
sudo apt install subfinder

echo "Installing FDsploit..."
git clone https://github.com/chrispetrou/FDsploit.git /opt/FDsploit

echo "Installing GraphQLmap..."
git clone https://github.com/swisskyrepo/GraphQLmap /opt/GraphQLmap
python setup.py install


git clone https://github.com/r0075h3ll/Oralyzer.git /opt/Oralyzer


# Check if fuzzdb is installed and clone it if not
if [ ! -d "fuzzdb" ]
then
    echo "[*] Cloning fuzzdb repository..."
    git clone https://github.com/fuzzdb-project/fuzzdb.git /opt/fuzzdb
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



# Install amass
if ! command -v amass &> /dev/null;then
    echo "Installing amass..."
    sudo apt-get install -y snapd
    sudo snap install amass
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
    # Add LinkFinder to the PATH
    
    source ~/.bashrc
fi











echo "Installation complete!"
exit 0